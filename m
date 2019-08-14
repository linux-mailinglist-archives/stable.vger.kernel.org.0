Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD3388C8DB
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 04:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728488AbfHNCNz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 22:13:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:45980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728487AbfHNCNy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 22:13:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1190521721;
        Wed, 14 Aug 2019 02:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748834;
        bh=MYj6W8CbGDp223WLuc940Dq9/deLTRyayxtyfLmqWHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bZK91UK6l+QulZr73N8ExMKhB+5zAsy2Y1+keTiZ6QWNGzMpGbMLX+vdEp4KUZ/wI
         pC/JeXP1i+SeBbhoqhnV+/+C56k6x44bGgmjSXE25yAFDlm6lLKeQeanUQhksSrcIA
         Ns9ljKvswqfaLmwD9onPd2msOHMW5UKqzPRDWEDE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+62a1e04fd3ec2abf099e@syzkaller.appspotmail.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 093/123] HID: hiddev: do cleanup in failure of opening a device
Date:   Tue, 13 Aug 2019 22:10:17 -0400
Message-Id: <20190814021047.14828-93-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021047.14828-1-sashal@kernel.org>
References: <20190814021047.14828-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hillf Danton <hdanton@sina.com>

[ Upstream commit 6d4472d7bec39917b54e4e80245784ea5d60ce49 ]

Undo what we did for opening before releasing the memory slice.

Reported-by: syzbot <syzbot+62a1e04fd3ec2abf099e@syzkaller.appspotmail.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Hillf Danton <hdanton@sina.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/usbhid/hiddev.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/hid/usbhid/hiddev.c b/drivers/hid/usbhid/hiddev.c
index c07df82923802..4e11cc6fc34bc 100644
--- a/drivers/hid/usbhid/hiddev.c
+++ b/drivers/hid/usbhid/hiddev.c
@@ -308,6 +308,10 @@ static int hiddev_open(struct inode *inode, struct file *file)
 	hid_hw_power(hid, PM_HINT_NORMAL);
 bail_unlock:
 	mutex_unlock(&hiddev->existancelock);
+
+	spin_lock_irq(&list->hiddev->list_lock);
+	list_del(&list->node);
+	spin_unlock_irq(&list->hiddev->list_lock);
 bail:
 	file->private_data = NULL;
 	vfree(list);
-- 
2.20.1

