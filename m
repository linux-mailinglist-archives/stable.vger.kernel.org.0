Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 471525415F2
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376385AbiFGUnj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376372AbiFGU03 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:26:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE4F1D7878;
        Tue,  7 Jun 2022 11:32:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 099AD611B9;
        Tue,  7 Jun 2022 18:32:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15D44C385A2;
        Tue,  7 Jun 2022 18:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626757;
        bh=8x8o8T4Mzids+cK+jsJa0aKz+pwiyZUUfGh3jcLvHU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WfQThdyE/0myvCzEULieQDbaU/4QX6CdXHVJcgFWMYRgki3CGmKo9BD60UZNXScil
         cZRiVVtDlqGWK2RMHkKLbK02fvXxVkM9O+P/UWOMipM/Nd4lfSBmRFlhTN+Iy8a68+
         AsrNUijyOAZr/wjSeLgaa8VlFHXC3lo9dD6L0twI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hari Bathini <hbathini@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 493/772] powerpc/fadump: fix PT_LOAD segment for boot memory area
Date:   Tue,  7 Jun 2022 19:01:25 +0200
Message-Id: <20220607165003.511876313@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
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
index d03e488cfe9c..a32d6871de75 100644
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



