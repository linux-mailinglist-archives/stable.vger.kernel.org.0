Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D72756BB170
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232384AbjCOM11 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232512AbjCOM1G (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:27:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D1C97491
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:26:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B8F7B81DFC
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:25:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2DD6C433EF;
        Wed, 15 Mar 2023 12:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883156;
        bh=oxZq7lq2Z5LRxuZx6TyZO40tToDw9pNkvhhU5kEbxZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OUEGY8AGViUFCpERFgMQPvaPo0xqPq0G/VvM8XAslOJnQmXZTNI6T2T8woeTfLisn
         7Mw6dHyLFZQtodPLQCEEzRkz5hi8Y0GlN73meD3eMIZGLmwbkgtmuHM+2zfyh1L/kg
         XIuhCPesb0RznqtJMOL38mkz1DL8CVvNVd/KwrjY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 035/145] RISC-V: Avoid dereferening NULL regs in die()
Date:   Wed, 15 Mar 2023 13:11:41 +0100
Message-Id: <20230315115740.231245322@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Palmer Dabbelt <palmer@rivosinc.com>

[ Upstream commit f2913d006fcdb61719635e093d1b5dd0dafecac7 ]

I don't think we can actually die() without a regs pointer, but the
compiler was warning about a NULL check after a dereference.  It seems
prudent to just avoid the possibly-NULL dereference, given that when
die()ing the system is already toast so who knows how we got there.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20220920200037.6727-1-palmer@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Stable-dep-of: 130aee3fd998 ("riscv: Avoid enabling interrupts in die()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/traps.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/kernel/traps.c b/arch/riscv/kernel/traps.c
index 6084bd93d2f58..502cba5029ca4 100644
--- a/arch/riscv/kernel/traps.c
+++ b/arch/riscv/kernel/traps.c
@@ -33,6 +33,7 @@ void die(struct pt_regs *regs, const char *str)
 {
 	static int die_counter;
 	int ret;
+	long cause;
 
 	oops_enter();
 
@@ -42,11 +43,13 @@ void die(struct pt_regs *regs, const char *str)
 
 	pr_emerg("%s [#%d]\n", str, ++die_counter);
 	print_modules();
-	show_regs(regs);
+	if (regs)
+		show_regs(regs);
 
-	ret = notify_die(DIE_OOPS, str, regs, 0, regs->cause, SIGSEGV);
+	cause = regs ? regs->cause : -1;
+	ret = notify_die(DIE_OOPS, str, regs, 0, cause, SIGSEGV);
 
-	if (regs && kexec_should_crash(current))
+	if (kexec_should_crash(current))
 		crash_kexec(regs);
 
 	bust_spinlocks(0);
-- 
2.39.2



