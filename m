Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C21A4F27E3
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233759AbiDEIJ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236021AbiDEIBI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:01:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A5C49FB3;
        Tue,  5 Apr 2022 00:59:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4221361668;
        Tue,  5 Apr 2022 07:59:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55A16C340EE;
        Tue,  5 Apr 2022 07:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145548;
        bh=cHh6Am89UvKmAAC6DhpJgKI9IPbPSd8DeXy2OH/l794=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xvmbXZ4Fo2QugKLgEytW6K9ucyOrhEoHihc0t/Cfr869iZx+89OTwhSa/p3XyeAW4
         m+BTF3lJbFPSkiQDW8YnAdFeav+lXq2D47eQav3FqqpVPqGsARL85L/CSSoEIzPdD9
         wT+ILDXvh6iXBnyl93nk5JfPPsckx8RpaWOcB1oQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yiru Xu <xyru1999@gmail.com>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0445/1126] Bluetooth: hci_serdev: call init_rwsem() before p->open()
Date:   Tue,  5 Apr 2022 09:19:52 +0200
Message-Id: <20220405070420.686154785@linuxfoundation.org>
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

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit 9d7cbe2b9cf5f650067df4f402fdd799d4bbb4e1 ]

kvartet reported, that hci_uart_tx_wakeup() uses uninitialized rwsem.
The problem was in wrong place for percpu_init_rwsem() call.

hci_uart_proto::open() may register a timer whose callback may call
hci_uart_tx_wakeup(). There is a chance, that hci_uart_register_device()
thread won't be fast enough to call percpu_init_rwsem().

Fix it my moving percpu_init_rwsem() call before p->open().

INFO: trying to register non-static key.
The code is fine but needs lockdep annotation, or maybe
you didn't initialize this object before use?
turning off the locking correctness validator.
CPU: 2 PID: 18524 Comm: syz-executor.5 Not tainted 5.16.0-rc6 #9
...
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 assign_lock_key kernel/locking/lockdep.c:951 [inline]
 register_lock_class+0x148d/0x1950 kernel/locking/lockdep.c:1263
 __lock_acquire+0x106/0x57e0 kernel/locking/lockdep.c:4906
 lock_acquire kernel/locking/lockdep.c:5637 [inline]
 lock_acquire+0x1ab/0x520 kernel/locking/lockdep.c:5602
 percpu_down_read_trylock include/linux/percpu-rwsem.h:92 [inline]
 hci_uart_tx_wakeup+0x12e/0x490 drivers/bluetooth/hci_ldisc.c:124
 h5_timed_event+0x32f/0x6a0 drivers/bluetooth/hci_h5.c:188
 call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1421

Fixes: d73e17281665 ("Bluetooth: hci_serdev: Init hci_uart proto_lock to avoid oops")
Reported-by: Yiru Xu <xyru1999@gmail.com>
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_serdev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/hci_serdev.c b/drivers/bluetooth/hci_serdev.c
index 3b00d82d36cf..4cda890ce647 100644
--- a/drivers/bluetooth/hci_serdev.c
+++ b/drivers/bluetooth/hci_serdev.c
@@ -305,6 +305,8 @@ int hci_uart_register_device(struct hci_uart *hu,
 	if (err)
 		return err;
 
+	percpu_init_rwsem(&hu->proto_lock);
+
 	err = p->open(hu);
 	if (err)
 		goto err_open;
@@ -327,7 +329,6 @@ int hci_uart_register_device(struct hci_uart *hu,
 
 	INIT_WORK(&hu->init_ready, hci_uart_init_work);
 	INIT_WORK(&hu->write_work, hci_uart_write_work);
-	percpu_init_rwsem(&hu->proto_lock);
 
 	/* Only when vendor specific setup callback is provided, consider
 	 * the manufacturer information valid. This avoids filling in the
-- 
2.34.1



