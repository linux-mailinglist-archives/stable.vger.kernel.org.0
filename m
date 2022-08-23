Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6018359E1D7
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239127AbiHWMMx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351906AbiHWMMR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:12:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4E2EE42F4;
        Tue, 23 Aug 2022 02:39:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72F60613CA;
        Tue, 23 Aug 2022 09:38:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D3C0C433D6;
        Tue, 23 Aug 2022 09:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247533;
        bh=EkgEL8VNg3xEP7YC4/zdUsjn0OhSMPb/3b8UAiUZx84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G5jVe4bbp6upFGtX59yFMB//Jn8KzI2ykflZkCaMAyv5esDTQYCQGN2CfGY6I9yZz
         irHzSG1qyG0H1LTjFUC87VbUtE2W7pR2aMTyXUFBMYE3HytI/zzdiU558rdna5uBRq
         eSb5gEAT9JzOHTdRIzl8CdmNg2crvly7n8OBEoEQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 5.10 065/158] nios2: dont leave NULLs in sys_call_table[]
Date:   Tue, 23 Aug 2022 10:26:37 +0200
Message-Id: <20220823080048.711344815@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080046.056825146@linuxfoundation.org>
References: <20220823080046.056825146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Al Viro <viro@zeniv.linux.org.uk>

commit 45ec746c65097c25e77d24eae8fee0def5b6cc5d upstream.

fill the gaps in there with sys_ni_syscall, as everyone does...

Fixes: 82ed08dd1b0e ("nios2: Exception handling")
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/nios2/kernel/entry.S         |    1 -
 arch/nios2/kernel/syscall_table.c |    1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

--- a/arch/nios2/kernel/entry.S
+++ b/arch/nios2/kernel/entry.S
@@ -193,7 +193,6 @@ local_restart:
 	movhi	r11, %hiadj(sys_call_table)
 	add	r1, r1, r11
 	ldw	r1, %lo(sys_call_table)(r1)
-	beq	r1, r0, ret_invsyscall
 
 	/* Check if we are being traced */
 	GET_THREAD_INFO r11
--- a/arch/nios2/kernel/syscall_table.c
+++ b/arch/nios2/kernel/syscall_table.c
@@ -13,5 +13,6 @@
 #define __SYSCALL(nr, call) [nr] = (call),
 
 void *sys_call_table[__NR_syscalls] = {
+	[0 ... __NR_syscalls-1] = sys_ni_syscall,
 #include <asm/unistd.h>
 };


