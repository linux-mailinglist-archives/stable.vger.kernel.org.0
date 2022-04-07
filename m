Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 113154F702B
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 03:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237751AbiDGBR0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 21:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237343AbiDGBQI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 21:16:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 778A9181DAF;
        Wed,  6 Apr 2022 18:12:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1E7E61DA8;
        Thu,  7 Apr 2022 01:12:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28CC0C385A1;
        Thu,  7 Apr 2022 01:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649293940;
        bh=8Eyzmrf4fHO/R4UgorIum0ZxR6EXxJppZCNGHEPJ16k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HzR2m0pOtt/KhvTl5DV/pGORQ5Y3727ZurDljHvg0zFAGPM7/R9gAytjpHGxukVdE
         pz4Y9tTk1JhOU3YEW4qR3xd9AVlC4wF/Agojk3PIBty42HqH9KwyS4jUH/m6tIvEXC
         yVBLU1yLyZSZGZfS+Tdd42XL8sKEbV1wA1S4mKDCIgQajrhJxTE1D5YVY/LFf3ulBu
         Ytfys/jNMn7+ISLFCq6ktEkF7q7iyIbhQ79g+9SPB46VsqCRodyd1krSlgnsFSaBiH
         7R0swea766ZUWzPY6t4+Enoi9lqjJLhoMIWFALFMyjWKdhZLYJQqTQj3XyJmG8dEEo
         HyjxgoXlE1l+g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, agordeev@linux.ibm.com,
        svens@linux.ibm.com, ebiederm@xmission.com, iii@linux.ibm.com,
        linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 17/30] s390/traps: improve panic message for translation-specification exception
Date:   Wed,  6 Apr 2022 21:11:27 -0400
Message-Id: <20220407011140.113856-17-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220407011140.113856-1-sashal@kernel.org>
References: <20220407011140.113856-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit f09354ffd84eef3c88efa8ba6df05efe50cfd16a ]

There are many different types of translation exceptions but only a
translation-specification exception leads to a kernel panic since it
indicates corrupted page tables, which must never happen.

Improve the panic message so it is a bit more obvious what this is about.

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/traps.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kernel/traps.c b/arch/s390/kernel/traps.c
index 2b780786fc68..ead721965b9f 100644
--- a/arch/s390/kernel/traps.c
+++ b/arch/s390/kernel/traps.c
@@ -142,10 +142,10 @@ static inline void do_fp_trap(struct pt_regs *regs, __u32 fpc)
 	do_trap(regs, SIGFPE, si_code, "floating point exception");
 }
 
-static void translation_exception(struct pt_regs *regs)
+static void translation_specification_exception(struct pt_regs *regs)
 {
 	/* May never happen. */
-	panic("Translation exception");
+	panic("Translation-Specification Exception");
 }
 
 static void illegal_op(struct pt_regs *regs)
@@ -374,7 +374,7 @@ static void (*pgm_check_table[128])(struct pt_regs *regs) = {
 	[0x0f]		= hfp_divide_exception,
 	[0x10]		= do_dat_exception,
 	[0x11]		= do_dat_exception,
-	[0x12]		= translation_exception,
+	[0x12]		= translation_specification_exception,
 	[0x13]		= special_op_exception,
 	[0x14]		= default_trap_handler,
 	[0x15]		= operand_exception,
-- 
2.35.1

