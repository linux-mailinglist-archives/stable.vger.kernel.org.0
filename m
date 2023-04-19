Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4364F6E7633
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 11:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232889AbjDSJ0p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 05:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232825AbjDSJ0k (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 05:26:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD5C912CB1
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 02:26:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D112F62FC7
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 09:26:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E28D3C433EF;
        Wed, 19 Apr 2023 09:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681896389;
        bh=VMgfdnns4q3sqqIBJX6kVBjHZTbBCdLLt8RIcqdSDco=;
        h=Subject:To:Cc:From:Date:From;
        b=debNGLZ6MNKe7NoVTKmfBuWhWIbjxctPeWv4uqqi3t9lBO4S+EyDSanCBZZ0nW3yN
         hnleaWiouCOTcn/TalnHQ+oeRu/JbbZjCZZo+8XvxWPZn1Gw0zOYECCBfe9E+rQS2W
         Uep1pjOvEw7UD3j2kNFumu18EkJQQs9uQ0AUVJdg=
Subject: FAILED: patch "[PATCH] riscv: Do not set initial_boot_params to the linear address" failed to apply to 5.15-stable tree
To:     alexghiti@rivosinc.com, palmer@rivosinc.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Apr 2023 11:26:26 +0200
Message-ID: <2023041926-clique-washout-2197@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
git checkout FETCH_HEAD
git cherry-pick -x f1581626071c8e37c58c5e8f0b4126b17172a211
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023041926-clique-washout-2197@gregkh' --subject-prefix 'PATCH 5.15.y' HEAD^..

Possible dependencies:

f1581626071c ("riscv: Do not set initial_boot_params to the linear address of the dtb")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f1581626071c8e37c58c5e8f0b4126b17172a211 Mon Sep 17 00:00:00 2001
From: Alexandre Ghiti <alexghiti@rivosinc.com>
Date: Wed, 29 Mar 2023 10:19:31 +0200
Subject: [PATCH] riscv: Do not set initial_boot_params to the linear address
 of the dtb

early_init_dt_verify() is already called in parse_dtb() and since the dtb
address does not change anymore (it is now in the fixmap region), no need
to reset initial_boot_params by calling early_init_dt_verify() again.

Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20230329081932.79831-3-alexghiti@rivosinc.com
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>

diff --git a/arch/riscv/kernel/setup.c b/arch/riscv/kernel/setup.c
index 542eed85ad2c..a059b73f4ddb 100644
--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -278,10 +278,7 @@ void __init setup_arch(char **cmdline_p)
 #if IS_ENABLED(CONFIG_BUILTIN_DTB)
 	unflatten_and_copy_device_tree();
 #else
-	if (early_init_dt_verify(__va(XIP_FIXUP(dtb_early_pa))))
-		unflatten_device_tree();
-	else
-		pr_err("No DTB found in kernel mappings\n");
+	unflatten_device_tree();
 #endif
 	misc_mem_init();
 

