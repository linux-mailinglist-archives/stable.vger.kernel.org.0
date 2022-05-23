Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4675531758
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241452AbiEWRdX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241335AbiEWRa5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:30:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2720363BD6;
        Mon, 23 May 2022 10:26:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8850A60C42;
        Mon, 23 May 2022 17:25:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B0DC34118;
        Mon, 23 May 2022 17:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326755;
        bh=8Eyzmrf4fHO/R4UgorIum0ZxR6EXxJppZCNGHEPJ16k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oNM+nwYHTKdzSHtofmMF79W2Z9v75EaHZYvp3ONdhI8b3AAwZXZ5BiSlOKsLJ6yUx
         fMl0WOh8WHVbCK8E2sv/lGgMTw9cP/sfsgpM1NEKDfQ8Irm+fXyJ2zxTgoTlRfXQtj
         VuUVBsAoCz8d6CS5Kdx4gnSmEweTMU4QVgBw2ILM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 031/158] s390/traps: improve panic message for translation-specification exception
Date:   Mon, 23 May 2022 19:03:08 +0200
Message-Id: <20220523165835.657970647@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



