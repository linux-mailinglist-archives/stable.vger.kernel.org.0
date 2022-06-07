Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 448BB54069C
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240500AbiFGRhN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347760AbiFGRfq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:35:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD5B10A600;
        Tue,  7 Jun 2022 10:31:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1369FB822B5;
        Tue,  7 Jun 2022 17:31:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC9FC385A5;
        Tue,  7 Jun 2022 17:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623074;
        bh=UjyGDJ0/V1WJUaLWf/X0zXbs93iWcKUJUEAjXL4IIaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AC2FB7m7RF5FBRkwjKIbi8coRQlv2vU/pz94aCWCXy/FOlFez3oHKpBonn0QzTybq
         MKwiV8dj90c445ONRDRckMe3W+BEZCHHIJhFyyxSGkYJwlEeFeeTJhS868jz3+Lwpj
         trXnEDd/NbEUtd0Yjx1SpPRE2QrRw8qGFZ1C8yxY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hari Bathini <hbathini@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 284/452] powerpc/fadump: fix PT_LOAD segment for boot memory area
Date:   Tue,  7 Jun 2022 19:02:21 +0200
Message-Id: <20220607164917.013753371@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hari Bathini <hbathini@linux.ibm.com>

[ Upstream commit 15eb77f873255cf9f4d703b63cfbd23c46579654 ]

Boot memory area is setup as separate PT_LOAD segment in the vmcore
as it is moved by f/w, on crash, to a destination address provided by
the kernel. Having separate PT_LOAD segment helps in handling the
different physical address and offset for boot memory area in the
vmcore.

Commit ced1bf52f477 ("powerpc/fadump: merge adjacent memory ranges to
reduce PT_LOAD segements") inadvertly broke this pre-condition for
cases where some of the first kernel memory is available adjacent to
boot memory area. This scenario is rare but possible when memory for
fadump could not be reserved adjacent to boot memory area owing to
memory hole or such. Reading memory from a vmcore exported in such
scenario provides incorrect data.  Fix it by ensuring no other region
is folded into boot memory area.

Fixes: ced1bf52f477 ("powerpc/fadump: merge adjacent memory ranges to reduce PT_LOAD segements")
Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220406093839.206608-2-hbathini@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/fadump.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/fadump.c b/arch/powerpc/kernel/fadump.c
index c3bb800dc435..1a5ba26aab15 100644
--- a/arch/powerpc/kernel/fadump.c
+++ b/arch/powerpc/kernel/fadump.c
@@ -861,7 +861,6 @@ static int fadump_alloc_mem_ranges(struct fadump_mrange_info *mrange_info)
 				       sizeof(struct fadump_memory_range));
 	return 0;
 }
-
 static inline int fadump_add_mem_range(struct fadump_mrange_info *mrange_info,
 				       u64 base, u64 end)
 {
@@ -880,7 +879,12 @@ static inline int fadump_add_mem_range(struct fadump_mrange_info *mrange_info,
 		start = mem_ranges[mrange_info->mem_range_cnt - 1].base;
 		size  = mem_ranges[mrange_info->mem_range_cnt - 1].size;
 
-		if ((start + size) == base)
+		/*
+		 * Boot memory area needs separate PT_LOAD segment(s) as it
+		 * is moved to a different location at the time of crash.
+		 * So, fold only if the region is not boot memory area.
+		 */
+		if ((start + size) == base && start >= fw_dump.boot_mem_top)
 			is_adjacent = true;
 	}
 	if (!is_adjacent) {
-- 
2.35.1



