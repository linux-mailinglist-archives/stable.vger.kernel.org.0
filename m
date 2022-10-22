Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7136086CD
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232022AbiJVHxg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231791AbiJVHwG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:52:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B7042C2AFF;
        Sat, 22 Oct 2022 00:46:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 771D8B82E28;
        Sat, 22 Oct 2022 07:45:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB40AC433D6;
        Sat, 22 Oct 2022 07:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424732;
        bh=7h9aWcGCfgx2rKr3+DGUU7gZV0M1EwXuVeR7W2iK1KQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=emN9mDtVj3IS3r3i+RJpZWPV2zYr0HZ/H+goF+IBZBeXCewcrB44B2/Yr+0T+W5ts
         h+xRP4tBteUOAnT/nByRJOk3sMHwVIlEVFHbjOZYgTOjpFY6f1jyj8l+uliccET884
         K98NqwEXlx1pI5bO4cVoJyRI1YTc6JptJ2aRswTs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+576dfca25381fb6fbc5f@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 255/717] Bluetooth: hci_{ldisc,serdev}: check percpu_init_rwsem() failure
Date:   Sat, 22 Oct 2022 09:22:14 +0200
Message-Id: <20221022072459.894957866@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 3124d320c22f3f4388d9ac5c8f37eaad0cefd6b1 ]

syzbot is reporting NULL pointer dereference at hci_uart_tty_close() [1],
for rcu_sync_enter() is called without rcu_sync_init() due to
hci_uart_tty_open() ignoring percpu_init_rwsem() failure.

While we are at it, fix that hci_uart_register_device() ignores
percpu_init_rwsem() failure and hci_uart_unregister_device() does not
call percpu_free_rwsem().

Link: https://syzkaller.appspot.com/bug?extid=576dfca25381fb6fbc5f [1]
Reported-by: syzbot <syzbot+576dfca25381fb6fbc5f@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Fixes: 67d2f8781b9f00d1 ("Bluetooth: hci_ldisc: Allow sleeping while proto locks are held.")
Fixes: d73e172816652772 ("Bluetooth: hci_serdev: Init hci_uart proto_lock to avoid oops")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_ldisc.c  |  7 +++++--
 drivers/bluetooth/hci_serdev.c | 10 +++++++---
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/bluetooth/hci_ldisc.c b/drivers/bluetooth/hci_ldisc.c
index f537673ede17..865112e96ff9 100644
--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -493,6 +493,11 @@ static int hci_uart_tty_open(struct tty_struct *tty)
 		BT_ERR("Can't allocate control structure");
 		return -ENFILE;
 	}
+	if (percpu_init_rwsem(&hu->proto_lock)) {
+		BT_ERR("Can't allocate semaphore structure");
+		kfree(hu);
+		return -ENOMEM;
+	}
 
 	tty->disc_data = hu;
 	hu->tty = tty;
@@ -505,8 +510,6 @@ static int hci_uart_tty_open(struct tty_struct *tty)
 	INIT_WORK(&hu->init_ready, hci_uart_init_work);
 	INIT_WORK(&hu->write_work, hci_uart_write_work);
 
-	percpu_init_rwsem(&hu->proto_lock);
-
 	/* Flush any pending characters in the driver */
 	tty_driver_flush_buffer(tty);
 
diff --git a/drivers/bluetooth/hci_serdev.c b/drivers/bluetooth/hci_serdev.c
index c0e5f42ec6b7..f16fd79bc02b 100644
--- a/drivers/bluetooth/hci_serdev.c
+++ b/drivers/bluetooth/hci_serdev.c
@@ -310,11 +310,12 @@ int hci_uart_register_device(struct hci_uart *hu,
 
 	serdev_device_set_client_ops(hu->serdev, &hci_serdev_client_ops);
 
+	if (percpu_init_rwsem(&hu->proto_lock))
+		return -ENOMEM;
+
 	err = serdev_device_open(hu->serdev);
 	if (err)
-		return err;
-
-	percpu_init_rwsem(&hu->proto_lock);
+		goto err_rwsem;
 
 	err = p->open(hu);
 	if (err)
@@ -389,6 +390,8 @@ int hci_uart_register_device(struct hci_uart *hu,
 	p->close(hu);
 err_open:
 	serdev_device_close(hu->serdev);
+err_rwsem:
+	percpu_free_rwsem(&hu->proto_lock);
 	return err;
 }
 EXPORT_SYMBOL_GPL(hci_uart_register_device);
@@ -410,5 +413,6 @@ void hci_uart_unregister_device(struct hci_uart *hu)
 		clear_bit(HCI_UART_PROTO_READY, &hu->flags);
 		serdev_device_close(hu->serdev);
 	}
+	percpu_free_rwsem(&hu->proto_lock);
 }
 EXPORT_SYMBOL_GPL(hci_uart_unregister_device);
-- 
2.35.1



