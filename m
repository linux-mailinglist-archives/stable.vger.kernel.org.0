Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71F4A532E46
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 18:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239322AbiEXQB7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 12:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239254AbiEXQAm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 12:00:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 758F69BAE5;
        Tue, 24 May 2022 09:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92C5E61770;
        Tue, 24 May 2022 16:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FE74C34113;
        Tue, 24 May 2022 16:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653408018;
        bh=uNYcJ4Cr7Q5JHM1D51Lx3IAU4uaYLwTacB3qIeJzItk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SEnhQXD2Z4o92P66/6rCcy6hhqEoV8iltJWeoFUGn+JwiSUk61ftdxF42VGPkIf7v
         SAr4SmZktPo/rGWIEKlVucGVsJrxpR2ujZWCFN6yFU82VFg7/1QkCWIQTV2b01u7Kn
         +irL30+CP9P7b5LCmCLGkDuANZSdR3gcJmRcY4Ir2zQr3wgrcROl00bsck5zD581N1
         Wtz/VzpCkyztkOS1Efug+j/IBQhqB43B2Ma1kG6++yywlgoxcDuzb+s5muiV5MzEYx
         l7QJyiesb0t8T1vN8s6FK8rOWqRFohQangUT50opMIN/2wPISC4UVRhHZbJ9FXRrCs
         9b+/oPjAC97dQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John David Anglin <dave.anglin@bell.net>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>,
        James.Bottomley@HansenPartnership.com, zhengqi.arch@bytedance.com,
        akpm@linux-foundation.org, linux-parisc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 04/10] parisc: Disable debug code regarding cache flushes in handle_nadtlb_fault()
Date:   Tue, 24 May 2022 12:00:01 -0400
Message-Id: <20220524160009.826957-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220524160009.826957-1-sashal@kernel.org>
References: <20220524160009.826957-1-sashal@kernel.org>
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
index 5faa3cff4738..2472780d4039 100644
--- a/arch/parisc/mm/fault.c
+++ b/arch/parisc/mm/fault.c
@@ -22,6 +22,8 @@
 
 #include <asm/traps.h>
 
+#define DEBUG_NATLB 0
+
 /* Various important other fields */
 #define bit22set(x)		(x & 0x00000200)
 #define bits23_25set(x)		(x & 0x000001c0)
@@ -449,8 +451,8 @@ handle_nadtlb_fault(struct pt_regs *regs)
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

