Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE6265B04D
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 12:10:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbjABLKz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 06:10:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232527AbjABKvR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 05:51:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A0A725F4
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 02:51:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FC0160F25
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 10:51:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9404C433D2;
        Mon,  2 Jan 2023 10:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672656667;
        bh=be2U4LxZreIeJzFfYn8MDVMIXbs6l0ZyNLqtEUPO8i0=;
        h=Subject:To:Cc:From:Date:From;
        b=X2B1c8T4T6aIddx0qpo/xCWWetmjosLhePICLJVwpgCV+rMFkz3AkRfCzaVYxP/Dz
         fOICmRvE/YnjpMereGwzveBrPp9EhVjO3hbKylj9sJKQq5B+jzJuKuyLoIjjSvmYGW
         TKUV/uZVqGYuN4Jr0XW8JeXk01zq9DCcJuXQ1sN8=
Subject: FAILED: patch "[PATCH] binfmt: Fix error return code in load_elf_fdpic_binary()" failed to apply to 4.9-stable tree
To:     wangyufen@huawei.com, keescook@chromium.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 02 Jan 2023 11:50:52 +0100
Message-ID: <1672656652179157@kroah.com>
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


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

e7f703ff2507 ("binfmt: Fix error return code in load_elf_fdpic_binary()")
e7f7785449a1 ("binfmt: Move install_exec_creds after setup_new_exec to match binfmt_elf")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e7f703ff2507f4e9f496da96cd4b78fd3026120c Mon Sep 17 00:00:00 2001
From: Wang Yufen <wangyufen@huawei.com>
Date: Fri, 2 Dec 2022 09:41:01 +0800
Subject: [PATCH] binfmt: Fix error return code in load_elf_fdpic_binary()

Fix to return a negative error code from create_elf_fdpic_tables()
instead of 0.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/1669945261-30271-1-git-send-email-wangyufen@huawei.com

diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index e90c1192dec6..096e3520a0b1 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -434,8 +434,9 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm)
 	current->mm->start_stack = current->mm->start_brk + stack_size;
 #endif
 
-	if (create_elf_fdpic_tables(bprm, current->mm,
-				    &exec_params, &interp_params) < 0)
+	retval = create_elf_fdpic_tables(bprm, current->mm, &exec_params,
+					 &interp_params);
+	if (retval < 0)
 		goto error;
 
 	kdebug("- start_code  %lx", current->mm->start_code);

