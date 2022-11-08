Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0026F6213A9
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234760AbiKHNwo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:52:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234704AbiKHNw0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:52:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24D1F65E70
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:52:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5021D615A2
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:52:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ECB8C433C1;
        Tue,  8 Nov 2022 13:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915539;
        bh=CqGaXFlVl0vjU4TpAlaxXLb1f+jGKs3faf/uTr7rs2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OxfZNfRREr/sR2mIx1tCwahZw78XNtCTmbOrNurp/C+UUlnE06DN0YtdALjfFWVnC
         1XM+EWAZ8Vi714FjhTg6by7uuGIIIdLnAtet25pbNL1G/BVGi1KgGjdBkgM34Slc33
         woxK6lQFt+KShs6fvS51/u5/0e1GN4hX6XdwHh8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Borislav Petkov <bp@alien8.de>,
        Yazen Ghannam <yazen.ghannam@amd.com>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 007/118] x86/topology: Set cpu_die_id only if DIE_TYPE found
Date:   Tue,  8 Nov 2022 14:38:05 +0100
Message-Id: <20221108133341.032643577@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yazen Ghannam <yazen.ghannam@amd.com>

[ Upstream commit cb09a379724d299c603a7a79f444f52a9a75b8d2 ]

CPUID Leaf 0x1F defines a DIE_TYPE level (nb: ECX[8:15] level type == 0x5),
but CPUID Leaf 0xB does not. However, detect_extended_topology() will
set struct cpuinfo_x86.cpu_die_id regardless of whether a valid Die ID
was found.

Only set cpu_die_id if a DIE_TYPE level is found. CPU topology code may
use another value for cpu_die_id, e.g. the AMD NodeId on AMD-based
systems. Code ordering should be maintained so that the CPUID Leaf 0x1F
Die ID value will take precedence on systems that may use another value.

Suggested-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20201109210659.754018-5-Yazen.Ghannam@amd.com
Stable-dep-of: 2b12a7a126d6 ("x86/topology: Fix multiple packages shown on a single-package system")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/topology.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/topology.c b/arch/x86/kernel/cpu/topology.c
index 91288da29599..8678864ce712 100644
--- a/arch/x86/kernel/cpu/topology.c
+++ b/arch/x86/kernel/cpu/topology.c
@@ -96,6 +96,7 @@ int detect_extended_topology(struct cpuinfo_x86 *c)
 	unsigned int ht_mask_width, core_plus_mask_width, die_plus_mask_width;
 	unsigned int core_select_mask, core_level_siblings;
 	unsigned int die_select_mask, die_level_siblings;
+	bool die_level_present = false;
 	int leaf;
 
 	leaf = detect_extended_topology_leaf(c);
@@ -126,6 +127,7 @@ int detect_extended_topology(struct cpuinfo_x86 *c)
 			die_plus_mask_width = BITS_SHIFT_NEXT_LEVEL(eax);
 		}
 		if (LEAFB_SUBTYPE(ecx) == DIE_TYPE) {
+			die_level_present = true;
 			die_level_siblings = LEVEL_MAX_SIBLINGS(ebx);
 			die_plus_mask_width = BITS_SHIFT_NEXT_LEVEL(eax);
 		}
@@ -139,8 +141,12 @@ int detect_extended_topology(struct cpuinfo_x86 *c)
 
 	c->cpu_core_id = apic->phys_pkg_id(c->initial_apicid,
 				ht_mask_width) & core_select_mask;
-	c->cpu_die_id = apic->phys_pkg_id(c->initial_apicid,
-				core_plus_mask_width) & die_select_mask;
+
+	if (die_level_present) {
+		c->cpu_die_id = apic->phys_pkg_id(c->initial_apicid,
+					core_plus_mask_width) & die_select_mask;
+	}
+
 	c->phys_proc_id = apic->phys_pkg_id(c->initial_apicid,
 				die_plus_mask_width);
 	/*
-- 
2.35.1



