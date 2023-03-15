Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A35E6BB185
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232539AbjCOM2Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232120AbjCOM15 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:27:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E87D9B2E3
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:26:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3266361CC2
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:26:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 466CAC433EF;
        Wed, 15 Mar 2023 12:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883208;
        bh=/TDAOyJhZKj1uIenEYQhaN9JceBpcOEw2uaip9XC77s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sG2q+OyoB1pkx6ijUzcAIAUz/nWsexGpsV5/PUD+feTNJ73qwdivxSRvdooidLg5r
         Rq1hmedMvWvGN8qLJ7AXR602Jk88uYeEN9huLMW7QUQiGEMvE7/HCkL7+YTj1C6JHz
         ZhmPE9OOr0nnHbigMqqu2pP/QFucs0QaHV71SaiA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "sjur.brandeland@stericsson.com" <sjur.brandeland@stericsson.com>,
        syzbot+b563d33852b893653a9e@syzkaller.appspotmail.com,
        Shigeru Yoshida <syoshida@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 057/145] net: caif: Fix use-after-free in cfusbl_device_notify()
Date:   Wed, 15 Mar 2023 13:12:03 +0100
Message-Id: <20230315115740.921156134@linuxfoundation.org>
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

From: Shigeru Yoshida <syoshida@redhat.com>

[ Upstream commit 9781e98a97110f5e76999058368b4be76a788484 ]

syzbot reported use-after-free in cfusbl_device_notify() [1].  This
causes a stack trace like below:

BUG: KASAN: use-after-free in cfusbl_device_notify+0x7c9/0x870 net/caif/caif_usb.c:138
Read of size 8 at addr ffff88807ac4e6f0 by task kworker/u4:6/1214

CPU: 0 PID: 1214 Comm: kworker/u4:6 Not tainted 5.19.0-rc3-syzkaller-00146-g92f20ff72066 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0xeb/0x467 mm/kasan/report.c:313
 print_report mm/kasan/report.c:429 [inline]
 kasan_report.cold+0xf4/0x1c6 mm/kasan/report.c:491
 cfusbl_device_notify+0x7c9/0x870 net/caif/caif_usb.c:138
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1945
 call_netdevice_notifiers_extack net/core/dev.c:1983 [inline]
 call_netdevice_notifiers net/core/dev.c:1997 [inline]
 netdev_wait_allrefs_any net/core/dev.c:10227 [inline]
 netdev_run_todo+0xbc0/0x10f0 net/core/dev.c:10341
 default_device_exit_batch+0x44e/0x590 net/core/dev.c:11334
 ops_exit_list+0x125/0x170 net/core/net_namespace.c:167
 cleanup_net+0x4ea/0xb00 net/core/net_namespace.c:594
 process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:302
 </TASK>

When unregistering a net device, unregister_netdevice_many_notify()
sets the device's reg_state to NETREG_UNREGISTERING, calls notifiers
with NETDEV_UNREGISTER, and adds the device to the todo list.

Later on, devices in the todo list are processed by netdev_run_todo().
netdev_run_todo() waits devices' reference count become 1 while
rebdoadcasting NETDEV_UNREGISTER notification.

When cfusbl_device_notify() is called with NETDEV_UNREGISTER multiple
times, the parent device might be freed.  This could cause UAF.
Processing NETDEV_UNREGISTER multiple times also causes inbalance of
reference count for the module.

This patch fixes the issue by accepting only first NETDEV_UNREGISTER
notification.

Fixes: 7ad65bf68d70 ("caif: Add support for CAIF over CDC NCM USB interface")
CC: sjur.brandeland@stericsson.com <sjur.brandeland@stericsson.com>
Reported-by: syzbot+b563d33852b893653a9e@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?id=c3bfd8e2450adab3bffe4d80821fbbced600407f [1]
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
Link: https://lore.kernel.org/r/20230301163913.391304-1-syoshida@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/caif/caif_usb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/caif/caif_usb.c b/net/caif/caif_usb.c
index b02e1292f7f19..24488a4e2d26e 100644
--- a/net/caif/caif_usb.c
+++ b/net/caif/caif_usb.c
@@ -134,6 +134,9 @@ static int cfusbl_device_notify(struct notifier_block *me, unsigned long what,
 	struct usb_device *usbdev;
 	int res;
 
+	if (what == NETDEV_UNREGISTER && dev->reg_state >= NETREG_UNREGISTERED)
+		return 0;
+
 	/* Check whether we have a NCM device, and find its VID/PID. */
 	if (!(dev->dev.parent && dev->dev.parent->driver &&
 	      strcmp(dev->dev.parent->driver->name, "cdc_ncm") == 0))
-- 
2.39.2



