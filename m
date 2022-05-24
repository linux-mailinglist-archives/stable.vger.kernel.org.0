Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4B6532E08
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 18:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239189AbiEXQAC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 12:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239232AbiEXQAA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 12:00:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFCB89CF47;
        Tue, 24 May 2022 08:59:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 392F5B81A3A;
        Tue, 24 May 2022 15:59:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F96C34115;
        Tue, 24 May 2022 15:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653407988;
        bh=mtfcqPLfpPwbKXS08XGxYgeqQ6x+a1HiRMcVM75SB2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eT7ui749mZKJzSbeif5vlv276ziBc2i1nDZxyjlL1gwvOBN68zDHMJEhlptFNqE/O
         mwcsYyf2ufGxUOiMyH5dLe/rYGGvPMMomL44bw8fGqWlqdgXKPBSgF6dC00Yx1Zmtc
         ffeohSfzQZfQnfHxMvAu+PQ1GEGlwz7EtnY8WZqG12YVnHDnNK/wH+6dHfXvAzJRK2
         U8XT9pdOYAlcat5c0pBlfrq5nn3AJCR/LyPp0HcaqFtWIeHmVrN7RKWRCUuyj+d79s
         ZeGJHAnp8n3moAF3chEp8cuppqmWv+kNzsWMyr10I3VNrCYHef7aTtCsgQj7dSQmKE
         T1hnBrbp2TPPQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John David Anglin <dave.anglin@bell.net>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>,
        James.Bottomley@HansenPartnership.com, zhengqi.arch@bytedance.com,
        akpm@linux-foundation.org, linux-parisc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 06/12] parisc: Disable debug code regarding cache flushes in handle_nadtlb_fault()
Date:   Tue, 24 May 2022 11:59:20 -0400
Message-Id: <20220524155929.826793-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220524155929.826793-1-sashal@kernel.org>
References: <20220524155929.826793-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John David Anglin <dave.anglin@bell.net>

[ Upstream commit 67c35a3b646cc68598ff0bb28de5f8bd7b2e81b3 ]

Change the "BUG" to "WARNING" and disable the message because it triggers
occasionally in spite of the check in flush_cache_page_if_present.

The pte value extracted for the "from" page in copy_user_highpage is racy and
occasionally the pte is cleared before the flush is complete.  I assume that
the page is simultaneously flushed by flush_cache_mm before the pte is cleared
as nullifying the fdc doesn't seem to cause problems.

I investigated various locking scenarios but I wasn't able to find a way to
sequence the flushes.  This code is called for every COW break and locks impact
performance.

This patch is related to the bigger cache flush patch because we need the pte
on PA8800/PA8900 to flush using the vma context.
I have also seen this from copy_to_user_page and copy_from_user_page.

The messages appear infrequently when enabled.

Signed-off-by: John David Anglin <dave.anglin@bell.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/parisc/mm/fault.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/parisc/mm/fault.c b/arch/parisc/mm/fault.c
index f114e102aaf2..84bc437be5cd 100644
--- a/arch/parisc/mm/fault.c
+++ b/arch/parisc/mm/fault.c
@@ -22,6 +22,8 @@
 
 #include <asm/traps.h>
 
+#define DEBUG_NATLB 0
+
 /* Various important other fields */
 #define bit22set(x)		(x & 0x00000200)
 #define bits23_25set(x)		(x & 0x000001c0)
@@ -450,8 +452,8 @@ handle_nadtlb_fault(struct pt_regs *regs)
 		fallthrough;
 	case 0x380:
 		/* PDC and FIC instructions */
-		if (printk_ratelimit()) {
-			pr_warn("BUG: nullifying cache flush/purge instruction\n");
+		if (DEBUG_NATLB && printk_ratelimit()) {
+			pr_warn("WARNING: nullifying cache flush/purge instruction\n");
 			show_regs(regs);
 		}
 		if (insn & 0x20) {
-- 
2.35.1

