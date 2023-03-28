Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14D976CC360
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233204AbjC1Oxb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233497AbjC1OxS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:53:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C77C7D325
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:53:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57413B81BBF
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:53:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AABC1C4339B;
        Tue, 28 Mar 2023 14:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015195;
        bh=yWPBRrFI/oYaXjmv3+o4pmMnCU+y0h1oA5LCrzYs3pg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sdErljGFpi28qoCZbRZCliFS7R+2uccfjiCkAzbZ83/9rRngF3dTlYTR3PLhYUNpx
         3kxdwof2Wp1C/u4mxH47e10bdV7p6qlEzRU01P73P6f2uLucdl4SJOZ5RVr8VNsGSI
         BugY/Fp+GOJRw2rsW9/n8oAb6egeD2AeJ1z9Aaak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 6.2 169/240] x86/mm: Do not shuffle CPU entry areas without KASLR
Date:   Tue, 28 Mar 2023 16:42:12 +0200
Message-Id: <20230328142626.702956348@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Koutný <mkoutny@suse.com>

commit a3f547addcaa10df5a226526bc9e2d9a94542344 upstream.

The commit 97e3d26b5e5f ("x86/mm: Randomize per-cpu entry area") fixed
an omission of KASLR on CPU entry areas. It doesn't take into account
KASLR switches though, which may result in unintended non-determinism
when a user wants to avoid it (e.g. debugging, benchmarking).

Generate only a single combination of CPU entry areas offsets -- the
linear array that existed prior randomization when KASLR is turned off.

Since we have 3f148f331814 ("x86/kasan: Map shadow for percpu pages on
demand") and followups, we can use the more relaxed guard
kasrl_enabled() (in contrast to kaslr_memory_enabled()).

Fixes: 97e3d26b5e5f ("x86/mm: Randomize per-cpu entry area")
Signed-off-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20230306193144.24605-1-mkoutny%40suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/cpu_entry_area.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/mm/cpu_entry_area.c b/arch/x86/mm/cpu_entry_area.c
index 7316a8224259..e91500a80963 100644
--- a/arch/x86/mm/cpu_entry_area.c
+++ b/arch/x86/mm/cpu_entry_area.c
@@ -10,6 +10,7 @@
 #include <asm/fixmap.h>
 #include <asm/desc.h>
 #include <asm/kasan.h>
+#include <asm/setup.h>
 
 static DEFINE_PER_CPU_PAGE_ALIGNED(struct entry_stack_page, entry_stack_storage);
 
@@ -29,6 +30,12 @@ static __init void init_cea_offsets(void)
 	unsigned int max_cea;
 	unsigned int i, j;
 
+	if (!kaslr_enabled()) {
+		for_each_possible_cpu(i)
+			per_cpu(_cea_offset, i) = i;
+		return;
+	}
+
 	max_cea = (CPU_ENTRY_AREA_MAP_SIZE - PAGE_SIZE) / CPU_ENTRY_AREA_SIZE;
 
 	/* O(sodding terrible) */
-- 
2.40.0



