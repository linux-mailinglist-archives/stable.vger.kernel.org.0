Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFE0310B894
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729136AbfK0Uos (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:44:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:54670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729649AbfK0Uor (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:44:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F3512178F;
        Wed, 27 Nov 2019 20:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887487;
        bh=eO0C6pOQ51XQdb4zeqAMi6qHr22VdWDek6+vI/YW/kw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zpdsRSFg7N/6GYpPHI0SlO3f4FvxV8jP2JDjymj6Rz6ab5ls1nKhba1XQ2JX2dfzN
         M480riqQqvcvST+setFUAu6njWCF+7KmsvkeTVsHLVFKLG56LREzchKV4GkfPQHaJd
         k/kF/xoCjPUg40zioLxrx1G7GMlNmEoYHPP5SOUM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vito Caputo <vcaputo@pengaru.com>,
        syzbot <syzkaller@googlegroups.com>, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 4.9 130/151] media: cxusb: detect cxusb_ctrl_msg error in query
Date:   Wed, 27 Nov 2019 21:31:53 +0100
Message-Id: <20191127203046.240344655@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203000.773542911@linuxfoundation.org>
References: <20191127203000.773542911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vito Caputo <vcaputo@pengaru.com>

commit ca8f245f284eeffa56f3b7a5eb6fc503159ee028 upstream.

Don't use uninitialized ircode[] in cxusb_rc_query() when
cxusb_ctrl_msg() fails to populate its contents.

syzbot reported:

dvb-usb: bulk message failed: -22 (1/-30591)
=====================================================
BUG: KMSAN: uninit-value in ir_lookup_by_scancode drivers/media/rc/rc-main.c:494 [inline]
BUG: KMSAN: uninit-value in rc_g_keycode_from_table drivers/media/rc/rc-main.c:582 [inline]
BUG: KMSAN: uninit-value in rc_keydown+0x1a6/0x6f0 drivers/media/rc/rc-main.c:816
CPU: 1 PID: 11436 Comm: kworker/1:2 Not tainted 5.3.0-rc7+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events dvb_usb_read_remote_control
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x191/0x1f0 lib/dump_stack.c:113
 kmsan_report+0x13a/0x2b0 mm/kmsan/kmsan_report.c:108
 __msan_warning+0x73/0xe0 mm/kmsan/kmsan_instr.c:250
 bsearch+0x1dd/0x250 lib/bsearch.c:41
 ir_lookup_by_scancode drivers/media/rc/rc-main.c:494 [inline]
 rc_g_keycode_from_table drivers/media/rc/rc-main.c:582 [inline]
 rc_keydown+0x1a6/0x6f0 drivers/media/rc/rc-main.c:816
 cxusb_rc_query+0x2e1/0x360 drivers/media/usb/dvb-usb/cxusb.c:548
 dvb_usb_read_remote_control+0xf9/0x290 drivers/media/usb/dvb-usb/dvb-usb-remote.c:261
 process_one_work+0x1572/0x1ef0 kernel/workqueue.c:2269
 worker_thread+0x111b/0x2460 kernel/workqueue.c:2415
 kthread+0x4b5/0x4f0 kernel/kthread.c:256
 ret_from_fork+0x35/0x40 arch/x86/entry/entry_64.S:355

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:150 [inline]
 kmsan_internal_chain_origin+0xd2/0x170 mm/kmsan/kmsan.c:314
 __msan_chain_origin+0x6b/0xe0 mm/kmsan/kmsan_instr.c:184
 rc_g_keycode_from_table drivers/media/rc/rc-main.c:583 [inline]
 rc_keydown+0x2c4/0x6f0 drivers/media/rc/rc-main.c:816
 cxusb_rc_query+0x2e1/0x360 drivers/media/usb/dvb-usb/cxusb.c:548
 dvb_usb_read_remote_control+0xf9/0x290 drivers/media/usb/dvb-usb/dvb-usb-remote.c:261
 process_one_work+0x1572/0x1ef0 kernel/workqueue.c:2269
 worker_thread+0x111b/0x2460 kernel/workqueue.c:2415
 kthread+0x4b5/0x4f0 kernel/kthread.c:256
 ret_from_fork+0x35/0x40 arch/x86/entry/entry_64.S:355

Local variable description: ----ircode@cxusb_rc_query
Variable was created at:
 cxusb_rc_query+0x4d/0x360 drivers/media/usb/dvb-usb/cxusb.c:543
 dvb_usb_read_remote_control+0xf9/0x290 drivers/media/usb/dvb-usb/dvb-usb-remote.c:261

Signed-off-by: Vito Caputo <vcaputo@pengaru.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/dvb-usb/cxusb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/media/usb/dvb-usb/cxusb.c
+++ b/drivers/media/usb/dvb-usb/cxusb.c
@@ -437,7 +437,8 @@ static int cxusb_rc_query(struct dvb_usb
 	u8 ircode[4];
 	int i;
 
-	cxusb_ctrl_msg(d, CMD_GET_IR_CODE, NULL, 0, ircode, 4);
+	if (cxusb_ctrl_msg(d, CMD_GET_IR_CODE, NULL, 0, ircode, 4) < 0)
+		return 0;
 
 	*event = 0;
 	*state = REMOTE_NO_KEY_PRESSED;


