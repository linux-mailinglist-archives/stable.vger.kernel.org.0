Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC1CF6042B9
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 13:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiJSLJW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 07:09:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232959AbiJSLIm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 07:08:42 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22C142A246;
        Wed, 19 Oct 2022 03:37:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B7C9CCE21A0;
        Wed, 19 Oct 2022 09:10:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB82C433C1;
        Wed, 19 Oct 2022 09:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170653;
        bh=Qq/nS/EG95y0I/Z0ahk81L6aZDYvt5NYsst/VyPOYko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M//dTP9Jw++yYqUKymDiKi7OKGzXR0i75avDlZjvdrOeOZj/13/cUUdolxpYunrce
         D/o2c5DiPMEs0pjZXGHAFb+Ww5e+LTnjx94rZkM/csHqGwYuSABLYNnxgjLrQzcmms
         tMqgCUMK1K7hZ4Iu0wu1Qj0oJAQyv3aMjcmhmLn4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Hawkins Jiawei <yin31149@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 709/862] Bluetooth: hci_sysfs: Fix attempting to call device_add multiple times
Date:   Wed, 19 Oct 2022 10:33:16 +0200
Message-Id: <20221019083321.288699533@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 448a496f760664d3e2e79466aa1787e6abc922b5 ]

device_add shall not be called multiple times as stated in its
documentation:

 'Do not call this routine or device_register() more than once for
 any device structure'

Syzkaller reports a bug as follows [1]:
------------[ cut here ]------------
kernel BUG at lib/list_debug.c:33!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
[...]
Call Trace:
 <TASK>
 __list_add include/linux/list.h:69 [inline]
 list_add_tail include/linux/list.h:102 [inline]
 kobj_kset_join lib/kobject.c:164 [inline]
 kobject_add_internal+0x18f/0x8f0 lib/kobject.c:214
 kobject_add_varg lib/kobject.c:358 [inline]
 kobject_add+0x150/0x1c0 lib/kobject.c:410
 device_add+0x368/0x1e90 drivers/base/core.c:3452
 hci_conn_add_sysfs+0x9b/0x1b0 net/bluetooth/hci_sysfs.c:53
 hci_le_cis_estabilished_evt+0x57c/0xae0 net/bluetooth/hci_event.c:6799
 hci_le_meta_evt+0x2b8/0x510 net/bluetooth/hci_event.c:7110
 hci_event_func net/bluetooth/hci_event.c:7440 [inline]
 hci_event_packet+0x63d/0xfd0 net/bluetooth/hci_event.c:7495
 hci_rx_work+0xae7/0x1230 net/bluetooth/hci_core.c:4007
 process_one_work+0x991/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e4/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>

Link: https://syzkaller.appspot.com/bug?id=da3246e2d33afdb92d66bc166a0934c5b146404a
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Tested-by: Hawkins Jiawei <yin31149@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sysfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/bluetooth/hci_sysfs.c b/net/bluetooth/hci_sysfs.c
index 4e3e0451b08c..08542dfc2dc5 100644
--- a/net/bluetooth/hci_sysfs.c
+++ b/net/bluetooth/hci_sysfs.c
@@ -48,6 +48,9 @@ void hci_conn_add_sysfs(struct hci_conn *conn)
 
 	BT_DBG("conn %p", conn);
 
+	if (device_is_registered(&conn->dev))
+		return;
+
 	dev_set_name(&conn->dev, "%s:%d", hdev->name, conn->handle);
 
 	if (device_add(&conn->dev) < 0) {
-- 
2.35.1



