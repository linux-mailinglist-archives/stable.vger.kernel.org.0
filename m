Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 768EA60AB57
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236386AbiJXNuP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236644AbiJXNtf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:49:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0F9FB7EF5;
        Mon, 24 Oct 2022 05:41:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6B3C612B9;
        Mon, 24 Oct 2022 12:40:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C19C4C433C1;
        Mon, 24 Oct 2022 12:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615251;
        bh=U2S+lBkDEJP0n2Y1e91v0Q4zrFh2grhkUExIe7gZqng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cFZRODLAsJ5XHgMxieuwKaFMsVj/+tXnBdQOPGcHWM3XzW2yw9IpMhWF/Owy4nrvb
         uY9Xec2N2kmUIC+iB2SpAnL0JW2nciRdo9mp1OFse3hY8ICOXP0UZqZ88jbTgDwxlt
         iW7qdBLulf3jqoCs0G5qVoLxwy0rs2z9J/S8U+Pk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+576dfca25381fb6fbc5f@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 180/530] Bluetooth: hci_{ldisc,serdev}: check percpu_init_rwsem() failure
Date:   Mon, 24 Oct 2022 13:28:44 +0200
Message-Id: <20221024113053.177686231@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 5ed2cfa7da1d..2d960a5e3679 100644
--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -490,6 +490,11 @@ static int hci_uart_tty_open(struct tty_struct *tty)
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
@@ -502,8 +507,6 @@ static int hci_uart_tty_open(struct tty_struct *tty)
 	INIT_WORK(&hu->init_ready, hci_uart_init_work);
 	INIT_WORK(&hu->write_work, hci_uart_write_work);
 
-	percpu_init_rwsem(&hu->proto_lock);
-
 	/* Flush any pending characters in the driver */
 	tty_driver_flush_buffer(tty);
 
diff --git a/drivers/bluetooth/hci_serdev.c b/drivers/bluetooth/hci_serdev.c
index 4cda890ce647..649d112eea78 100644
--- a/drivers/bluetooth/hci_serdev.c
+++ b/drivers/bluetooth/hci_serdev.c
@@ -301,11 +301,12 @@ int hci_uart_register_device(struct hci_uart *hu,
 
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
@@ -378,6 +379,8 @@ int hci_uart_register_device(struct hci_uart *hu,
 	p->close(hu);
 err_open:
 	serdev_device_close(hu->serdev);
+err_rwsem:
+	percpu_free_rwsem(&hu->proto_lock);
 	return err;
 }
 EXPORT_SYMBOL_GPL(hci_uart_register_device);
@@ -399,5 +402,6 @@ void hci_uart_unregister_device(struct hci_uart *hu)
 		clear_bit(HCI_UART_PROTO_READY, &hu->flags);
 		serdev_device_close(hu->serdev);
 	}
+	percpu_free_rwsem(&hu->proto_lock);
 }
 EXPORT_SYMBOL_GPL(hci_uart_unregister_device);
-- 
2.35.1



