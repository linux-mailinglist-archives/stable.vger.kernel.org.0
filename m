Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F29EF65846F
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235294AbiL1Q5T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:57:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235238AbiL1Q4e (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:56:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11E4A1D67F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:52:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5E40B8188B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:52:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 195EBC433D2;
        Wed, 28 Dec 2022 16:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246339;
        bh=dyDOPyg+jePFsFzNOFPEqmBLbY1R9nkzmMXaWUBtCLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RtNlybXBIoI4RhBlJJ7DpHYYP68rMOxs6KWyTx9Q/ALCdLkp/M9UN9XeT5zhBzgVg
         2vT2VE3W2I/Rp+XyBmAGm7+I3XHTOpSgUewZ2VO9QkflgVr0mtCtjsBn6bQ+4czuLL
         /8QzNj/Bg74eTopr028OTWtrzLJZA1eE2bGh4NGo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        Denis Efremov <efremov@linux.com>
Subject: [PATCH 6.0 1052/1073] floppy: Fix memory leak in do_floppy_init()
Date:   Wed, 28 Dec 2022 15:44:00 +0100
Message-Id: <20221228144356.795313888@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuan Can <yuancan@huawei.com>

commit f8ace2e304c5dd8a7328db9cd2b8a4b1b98d83ec upstream.

A memory leak was reported when floppy_alloc_disk() failed in
do_floppy_init().

unreferenced object 0xffff888115ed25a0 (size 8):
  comm "modprobe", pid 727, jiffies 4295051278 (age 25.529s)
  hex dump (first 8 bytes):
    00 ac 67 5b 81 88 ff ff                          ..g[....
  backtrace:
    [<000000007f457abb>] __kmalloc_node+0x4c/0xc0
    [<00000000a87bfa9e>] blk_mq_realloc_tag_set_tags.part.0+0x6f/0x180
    [<000000006f02e8b1>] blk_mq_alloc_tag_set+0x573/0x1130
    [<0000000066007fd7>] 0xffffffffc06b8b08
    [<0000000081f5ac40>] do_one_initcall+0xd0/0x4f0
    [<00000000e26d04ee>] do_init_module+0x1a4/0x680
    [<000000001bb22407>] load_module+0x6249/0x7110
    [<00000000ad31ac4d>] __do_sys_finit_module+0x140/0x200
    [<000000007bddca46>] do_syscall_64+0x35/0x80
    [<00000000b5afec39>] entry_SYSCALL_64_after_hwframe+0x46/0xb0
unreferenced object 0xffff88810fc30540 (size 32):
  comm "modprobe", pid 727, jiffies 4295051278 (age 25.529s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000007f457abb>] __kmalloc_node+0x4c/0xc0
    [<000000006b91eab4>] blk_mq_alloc_tag_set+0x393/0x1130
    [<0000000066007fd7>] 0xffffffffc06b8b08
    [<0000000081f5ac40>] do_one_initcall+0xd0/0x4f0
    [<00000000e26d04ee>] do_init_module+0x1a4/0x680
    [<000000001bb22407>] load_module+0x6249/0x7110
    [<00000000ad31ac4d>] __do_sys_finit_module+0x140/0x200
    [<000000007bddca46>] do_syscall_64+0x35/0x80
    [<00000000b5afec39>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

If the floppy_alloc_disk() failed, disks of current drive will not be set,
thus the lastest allocated set->tag cannot be freed in the error handling
path. A simple call graph shown as below:

 floppy_module_init()
   floppy_init()
     do_floppy_init()
       for (drive = 0; drive < N_DRIVE; drive++)
         blk_mq_alloc_tag_set()
           blk_mq_alloc_tag_set_tags()
             blk_mq_realloc_tag_set_tags() # set->tag allocated
         floppy_alloc_disk()
           blk_mq_alloc_disk() # error occurred, disks failed to allocated

       ->out_put_disk:
       for (drive = 0; drive < N_DRIVE; drive++)
         if (!disks[drive][0]) # the last disks is not set and loop break
           break;
         blk_mq_free_tag_set() # the latest allocated set->tag leaked

Fix this problem by free the set->tag of current drive before jump to
error handling path.

Cc: stable@vger.kernel.org
Fixes: 302cfee15029 ("floppy: use a separate gendisk for each media format")
Signed-off-by: Yuan Can <yuancan@huawei.com>
[efremov: added stable list, changed title]
Signed-off-by: Denis Efremov <efremov@linux.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/floppy.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4593,8 +4593,10 @@ static int __init do_floppy_init(void)
 			goto out_put_disk;
 
 		err = floppy_alloc_disk(drive, 0);
-		if (err)
+		if (err) {
+			blk_mq_free_tag_set(&tag_sets[drive]);
 			goto out_put_disk;
+		}
 
 		timer_setup(&motor_off_timer[drive], motor_off_callback, 0);
 	}


