Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 401C68C6A6
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 04:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729330AbfHNCRO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 22:17:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:48564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728812AbfHNCRN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 22:17:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BBF920874;
        Wed, 14 Aug 2019 02:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565749032;
        bh=32vHX0qAiiheZGw7h2T/l4MSrwCLSSm/5k06H7IwmiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ugEL5VZ+0GZJQIRl3Dzh03dbH7MjPd62cAyU4c0ZITHbrMXNYYgPZ1x7BKn+8DKmc
         8jlZl7ssRE0BiASRk0y/CQxEvd5f1vSgx4biftz74l/El1GiQPlf5V9IhYEBl/gClN
         hkHGvw44JFUCa2RTlfy5yryZcptMhUv0NMPwavDA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+62a1e04fd3ec2abf099e@syzkaller.appspotmail.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 49/68] HID: hiddev: do cleanup in failure of opening a device
Date:   Tue, 13 Aug 2019 22:15:27 -0400
Message-Id: <20190814021548.16001-49-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021548.16001-1-sashal@kernel.org>
References: <20190814021548.16001-1-sashal@kernel.org>
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
index 56da33bc3862e..5a949ca42b1d0 100644
--- a/drivers/hid/usbhid/hiddev.c
+++ b/drivers/hid/usbhid/hiddev.c
@@ -321,6 +321,10 @@ static int hiddev_open(struct inode *inode, struct file *file)
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

