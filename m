Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 985F96157CE
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:39:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbiKBCjW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:39:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbiKBCjU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:39:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA07DFD5
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:39:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD088617AD
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:39:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50835C433D7;
        Wed,  2 Nov 2022 02:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667356759;
        bh=aS5UlwD1ZaivyrAFPuFhTMIkmtD/v0Kv7IytHAk1eZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ikc5gTRgNtmjm4Raj3/STKlZMIpfzZvA9JFhA7mk98/PtS1vfnO7Ve99qCpPHILiV
         4YczllhTG8AhALgR4CHhbEc16qOYVkhFfTZkqftk/Nj3X8gklC2aO0Z3nrnO4MXtoG
         KWTT7wA2ESrvH0mdi39+UEFPDPNPU0WQEwrwVxfk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Li Zetao <lizetao1@huawei.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 6.0 054/240] fs/binfmt_elf: Fix memory leak in load_elf_binary()
Date:   Wed,  2 Nov 2022 03:30:29 +0100
Message-Id: <20221102022112.622931682@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Zetao <lizetao1@huawei.com>

commit 594d2a14f2168c09b13b114c3d457aa939403e52 upstream.

There is a memory leak reported by kmemleak:

  unreferenced object 0xffff88817104ef80 (size 224):
    comm "xfs_admin", pid 47165, jiffies 4298708825 (age 1333.476s)
    hex dump (first 32 bytes):
      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
      60 a8 b3 00 81 88 ff ff a8 10 5a 00 81 88 ff ff  `.........Z.....
    backtrace:
      [<ffffffff819171e1>] __alloc_file+0x21/0x250
      [<ffffffff81918061>] alloc_empty_file+0x41/0xf0
      [<ffffffff81948cda>] path_openat+0xea/0x3d30
      [<ffffffff8194ec89>] do_filp_open+0x1b9/0x290
      [<ffffffff8192660e>] do_open_execat+0xce/0x5b0
      [<ffffffff81926b17>] open_exec+0x27/0x50
      [<ffffffff81a69250>] load_elf_binary+0x510/0x3ed0
      [<ffffffff81927759>] bprm_execve+0x599/0x1240
      [<ffffffff8192a997>] do_execveat_common.isra.0+0x4c7/0x680
      [<ffffffff8192b078>] __x64_sys_execve+0x88/0xb0
      [<ffffffff83bbf0a5>] do_syscall_64+0x35/0x80

If "interp_elf_ex" fails to allocate memory in load_elf_binary(),
the program will take the "out_free_ph" error handing path,
resulting in "interpreter" file resource is not released.

Fix it by adding an error handing path "out_free_file", which will
release the file resource when "interp_elf_ex" failed to allocate
memory.

Fixes: 0693ffebcfe5 ("fs/binfmt_elf.c: allocate less for static executable")
Signed-off-by: Li Zetao <lizetao1@huawei.com>
Reviewed-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221024154421.982230-1-lizetao1@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/binfmt_elf.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -911,7 +911,7 @@ static int load_elf_binary(struct linux_
 		interp_elf_ex = kmalloc(sizeof(*interp_elf_ex), GFP_KERNEL);
 		if (!interp_elf_ex) {
 			retval = -ENOMEM;
-			goto out_free_ph;
+			goto out_free_file;
 		}
 
 		/* Get the exec headers */
@@ -1354,6 +1354,7 @@ out:
 out_free_dentry:
 	kfree(interp_elf_ex);
 	kfree(interp_elf_phdata);
+out_free_file:
 	allow_write_access(interpreter);
 	if (interpreter)
 		fput(interpreter);


