Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A74A34061EF
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233253AbhIJAoR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:44:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:46184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233481AbhIJAT7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:19:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94AF7610A3;
        Fri, 10 Sep 2021 00:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233129;
        bh=S2kBUEestuULlMUO4FoWwB67zsAW7zLe4FdjdnFH428=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GkjB80vqXZvzaBcnQx+mOnkih9zwT0HJhiTfVTYxxeKHwLljfn9ZE8gLZj8aVMApG
         XEmKhAfINP1Snznu2uSpBWCr2P/b5a68OtSrKeaqlJ1HTGRv+//zPjtQ29btyuxNTc
         hCT9s1g6rlR0139DTjavvchJM1GtoAgYzNyL/4kQdBrrfRf+prFag+6IIrUWCcIP6i
         bw6AJbh4/j9L/SLV9Kr4ETAmV7Z+yZFsqW8ZY/lWecWwrRP0lR7uLziWmcxEeqgBmE
         0kjYkqJVWC8SQphh32KZ1IJuifxi1P3h8N7V8sGykbrv5fUuueXzd5lyNmqyY+2Oth
         mVCYY0IVn2WDA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anirudh Rayabharam <mail@anirudhrb.com>,
        syzbot+47b26cd837ececfc666d@syzkaller.appspotmail.com,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 20/88] HID: usbhid: free raw_report buffers in usbhid_stop
Date:   Thu,  9 Sep 2021 20:17:12 -0400
Message-Id: <20210910001820.174272-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001820.174272-1-sashal@kernel.org>
References: <20210910001820.174272-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anirudh Rayabharam <mail@anirudhrb.com>

[ Upstream commit f7744fa16b96da57187dc8e5634152d3b63d72de ]

Free the unsent raw_report buffers when the device is removed.

Fixes a memory leak reported by syzbot at:
https://syzkaller.appspot.com/bug?id=7b4fa7cb1a7c2d3342a2a8a6c53371c8c418ab47

Reported-by: syzbot+47b26cd837ececfc666d@syzkaller.appspotmail.com
Tested-by: syzbot+47b26cd837ececfc666d@syzkaller.appspotmail.com
Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/usbhid/hid-core.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 4e9077363c96..9c970e63670e 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -505,7 +505,7 @@ static void hid_ctrl(struct urb *urb)
 
 	if (unplug) {
 		usbhid->ctrltail = usbhid->ctrlhead;
-	} else {
+	} else if (usbhid->ctrlhead != usbhid->ctrltail) {
 		usbhid->ctrltail = (usbhid->ctrltail + 1) & (HID_CONTROL_FIFO_SIZE - 1);
 
 		if (usbhid->ctrlhead != usbhid->ctrltail &&
@@ -1223,9 +1223,20 @@ static void usbhid_stop(struct hid_device *hid)
 	mutex_lock(&usbhid->mutex);
 
 	clear_bit(HID_STARTED, &usbhid->iofl);
+
 	spin_lock_irq(&usbhid->lock);	/* Sync with error and led handlers */
 	set_bit(HID_DISCONNECTED, &usbhid->iofl);
+	while (usbhid->ctrltail != usbhid->ctrlhead) {
+		if (usbhid->ctrl[usbhid->ctrltail].dir == USB_DIR_OUT) {
+			kfree(usbhid->ctrl[usbhid->ctrltail].raw_report);
+			usbhid->ctrl[usbhid->ctrltail].raw_report = NULL;
+		}
+
+		usbhid->ctrltail = (usbhid->ctrltail + 1) &
+			(HID_CONTROL_FIFO_SIZE - 1);
+	}
 	spin_unlock_irq(&usbhid->lock);
+
 	usb_kill_urb(usbhid->urbin);
 	usb_kill_urb(usbhid->urbout);
 	usb_kill_urb(usbhid->urbctrl);
-- 
2.30.2

