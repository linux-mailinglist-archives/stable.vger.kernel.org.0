Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A75032166EE
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 09:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbgGGHBf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 03:01:35 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53650 "EHLO
        mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726889AbgGGHBf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jul 2020 03:01:35 -0400
Received: from ALA-HCB.corp.ad.wrs.com (ala-hcb.corp.ad.wrs.com [147.11.189.41])
        by mail1.windriver.com (8.15.2/8.15.2) with ESMTPS id 06771Mct012838
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL);
        Tue, 7 Jul 2020 00:01:23 -0700 (PDT)
Received: from pek-lpg-core1-vm1.wrs.com (128.224.156.106) by
 ALA-HCB.corp.ad.wrs.com (147.11.189.41) with Microsoft SMTP Server id
 14.3.487.0; Tue, 7 Jul 2020 00:01:07 -0700
From:   <qiang.zhang@windriver.com>
To:     <balbi@kernel.org>
CC:     <colin.king@canonical.com>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: [PATCH v4] usb: gadget: function: fix missing spinlock in f_uac1_legacy
Date:   Mon, 6 Jul 2020 13:14:55 +0800
Message-ID: <20200706051455.33198-1-qiang.zhang@windriver.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qiang <qiang.zhang@windriver.com>

Add a missing spinlock protection for play_queue, because
the play_queue may be destroyed when the "playback_work"
work func and "f_audio_out_ep_complete" callback func
operate this paly_queue at the same time.

Fixes: c6994e6f067cf ("USB: gadget: add USB Audio Gadget driver")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Zhang Qiang <qiang.zhang@windriver.com>
---
 v1->v2->v3->v4:
 Add changelog text and Cc tags, Fixes tags.

 drivers/usb/gadget/function/f_uac1_legacy.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/gadget/function/f_uac1_legacy.c b/drivers/usb/gadget/function/f_uac1_legacy.c
index 349deae7cabd..e2d7f69128a0 100644
--- a/drivers/usb/gadget/function/f_uac1_legacy.c
+++ b/drivers/usb/gadget/function/f_uac1_legacy.c
@@ -336,7 +336,9 @@ static int f_audio_out_ep_complete(struct usb_ep *ep, struct usb_request *req)
 
 	/* Copy buffer is full, add it to the play_queue */
 	if (audio_buf_size - copy_buf->actual < req->actual) {
+		spin_lock_irq(&audio->lock);
 		list_add_tail(&copy_buf->list, &audio->play_queue);
+		spin_unlock_irq(&audio->lock);
 		schedule_work(&audio->playback_work);
 		copy_buf = f_audio_buffer_alloc(audio_buf_size);
 		if (IS_ERR(copy_buf))
-- 
2.24.1

