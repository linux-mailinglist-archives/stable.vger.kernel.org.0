Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98D5B6C1133
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 12:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbjCTLvj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 07:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbjCTLvi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 07:51:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3BC722DFA
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 04:51:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F9706149D
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 11:51:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34AF7C433A4;
        Mon, 20 Mar 2023 11:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679313088;
        bh=PG2TZLNFZtVKGEMnyKgSWkvbMOBz7KD/X+Su7SKEYXg=;
        h=Subject:To:Cc:From:Date:From;
        b=vWMCaLys6XzlnAdiwPv7EqS5d5H6lXcxaefnv2vnUVYLgcit8f7sx8UJRFqHqtGHM
         C2KyLys+f0PkOk/yICwSbyo2l2xRHFLcusLOmrXMAO2zYlxJEqJwwHm9+RqX9Ki6x2
         o1KtH2JuqtmAyR1a8DrXuz3l6RscUi6dov9Cs+zg=
Subject: FAILED: patch "[PATCH] x86/mm: Fix use of uninitialized buffer in sme_enable()" failed to apply to 4.14-stable tree
To:     n.zhandarovich@fintech.ru, bp@alien8.de, stable@kernel.org,
        thomas.lendacky@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Mar 2023 12:51:25 +0100
Message-ID: <167931308586149@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-4.14.y
git checkout FETCH_HEAD
git cherry-pick -x cbebd68f59f03633469f3ecf9bea99cd6cce3854
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167931308586149@kroah.com' --subject-prefix 'PATCH 4.14.y' HEAD^..

Possible dependencies:

cbebd68f59f0 ("x86/mm: Fix use of uninitialized buffer in sme_enable()")
1cd9c22fee3a ("x86/mm/encrypt: Move page table helpers into separate translation unit")
91cfc88c66bf ("x86: Use __nostackprotect for sme_encrypt_kernel")
107cd2532181 ("x86/mm: Encrypt the initrd earlier for BSP microcode update")
cc5f01e28d6c ("x86/mm: Prepare sme_encrypt_kernel() for PAGE aligned encryption")
2b5d00b6c2cd ("x86/mm: Centralize PMD flags in sme_encrypt_kernel()")
bacf6b499e11 ("x86/mm: Use a struct to reduce parameters for SME PGD mapping")
1303880179e6 ("x86/mm: Clean up register saving in the __enc_copy() assembly code")
dfaaec9033b8 ("x86: Add support for changing memory encryption attribute in early boot")
1958b5fc4010 ("x86/boot: Add early boot support when running with SEV active")
d7b417fa08d1 ("x86/mm: Add DMA support for SEV memory encryption")
682af54399b6 ("x86/mm: Don't attempt to encrypt initrd under SEV")
d8aa7eea78a1 ("x86/mm: Add Secure Encrypted Virtualization (SEV) support")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From cbebd68f59f03633469f3ecf9bea99cd6cce3854 Mon Sep 17 00:00:00 2001
From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Date: Mon, 6 Mar 2023 08:06:56 -0800
Subject: [PATCH] x86/mm: Fix use of uninitialized buffer in sme_enable()

cmdline_find_option() may fail before doing any initialization of
the buffer array. This may lead to unpredictable results when the same
buffer is used later in calls to strncmp() function.  Fix the issue by
returning early if cmdline_find_option() returns an error.

Found by Linux Verification Center (linuxtesting.org) with static
analysis tool SVACE.

Fixes: aca20d546214 ("x86/mm: Add support to make use of Secure Memory Encryption")
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/r/20230306160656.14844-1-n.zhandarovich@fintech.ru

diff --git a/arch/x86/mm/mem_encrypt_identity.c b/arch/x86/mm/mem_encrypt_identity.c
index 88cccd65029d..c6efcf559d88 100644
--- a/arch/x86/mm/mem_encrypt_identity.c
+++ b/arch/x86/mm/mem_encrypt_identity.c
@@ -600,7 +600,8 @@ void __init sme_enable(struct boot_params *bp)
 	cmdline_ptr = (const char *)((u64)bp->hdr.cmd_line_ptr |
 				     ((u64)bp->ext_cmd_line_ptr << 32));
 
-	cmdline_find_option(cmdline_ptr, cmdline_arg, buffer, sizeof(buffer));
+	if (cmdline_find_option(cmdline_ptr, cmdline_arg, buffer, sizeof(buffer)) < 0)
+		return;
 
 	if (!strncmp(buffer, cmdline_on, sizeof(buffer)))
 		sme_me_mask = me_mask;

