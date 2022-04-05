Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D55A4F259A
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232277AbiDEHum (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233254AbiDEHrl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:47:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 786736355;
        Tue,  5 Apr 2022 00:43:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB925B81B92;
        Tue,  5 Apr 2022 07:43:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19FA9C340EE;
        Tue,  5 Apr 2022 07:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144623;
        bh=E+kINYDa4vjmR2/Ac/d85f684pQx7sVqJoLby8JcQdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LKdx5n6hjvgFGPecud8wFgjoYVbourRREl0yT6Scfm0G20nBXUZ9/tVlhNKMDyN7e
         SpYe+/3JK9lgTrYaeOKEdt8Pj7yAZ0lCpuzWMsjW0jV8jfcXatcl49Aei5VbHW9Kp6
         fEcKkWGh0i9ibJW2vt5E9VK6VtnHPQpnhfIEYfMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kirill Tkhai <ktkhai@virtuozzo.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.17 0112/1126] dm: fix use-after-free in dm_cleanup_zoned_dev()
Date:   Tue,  5 Apr 2022 09:14:19 +0200
Message-Id: <20220405070410.858214332@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Kirill Tkhai <ktkhai@virtuozzo.com>

commit 588b7f5df0cb64f281290c7672470c006abe7160 upstream.

dm_cleanup_zoned_dev() uses queue, so it must be called
before blk_cleanup_disk() starts its killing:

blk_cleanup_disk->blk_cleanup_queue()->kobject_put()->blk_release_queue()->
->...RCU...->blk_free_queue_rcu()->kmem_cache_free()

Otherwise, RCU callback may be executed first and
dm_cleanup_zoned_dev() will touch free'd memory:

 BUG: KASAN: use-after-free in dm_cleanup_zoned_dev+0x33/0xd0
 Read of size 8 at addr ffff88805ac6e430 by task dmsetup/681

 CPU: 4 PID: 681 Comm: dmsetup Not tainted 5.17.0-rc2+ #6
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
 Call Trace:
  <TASK>
  dump_stack_lvl+0x57/0x7d
  print_address_description.constprop.0+0x1f/0x150
  ? dm_cleanup_zoned_dev+0x33/0xd0
  kasan_report.cold+0x7f/0x11b
  ? dm_cleanup_zoned_dev+0x33/0xd0
  dm_cleanup_zoned_dev+0x33/0xd0
  __dm_destroy+0x26a/0x400
  ? dm_blk_ioctl+0x230/0x230
  ? up_write+0xd8/0x270
  dev_remove+0x156/0x1d0
  ctl_ioctl+0x269/0x530
  ? table_clear+0x140/0x140
  ? lock_release+0xb2/0x750
  ? remove_all+0x40/0x40
  ? rcu_read_lock_sched_held+0x12/0x70
  ? lock_downgrade+0x3c0/0x3c0
  ? rcu_read_lock_sched_held+0x12/0x70
  dm_ctl_ioctl+0xa/0x10
  __x64_sys_ioctl+0xb9/0xf0
  do_syscall_64+0x3b/0x90
  entry_SYSCALL_64_after_hwframe+0x44/0xae
 RIP: 0033:0x7fb6dfa95c27

Fixes: bb37d77239af ("dm: introduce zone append emulation")
Cc: stable@vger.kernel.org
Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1609,6 +1609,7 @@ static void cleanup_mapped_device(struct
 		md->dax_dev = NULL;
 	}
 
+	dm_cleanup_zoned_dev(md);
 	if (md->disk) {
 		spin_lock(&_minor_lock);
 		md->disk->private_data = NULL;
@@ -1629,7 +1630,6 @@ static void cleanup_mapped_device(struct
 	mutex_destroy(&md->swap_bios_lock);
 
 	dm_mq_cleanup_mapped_device(md);
-	dm_cleanup_zoned_dev(md);
 }
 
 /*


