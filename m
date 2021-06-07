Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC4E039E3A6
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233386AbhFGQ1Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:27:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:60180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233728AbhFGQYX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:24:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 092EE6193D;
        Mon,  7 Jun 2021 16:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082550;
        bh=ZMRYJ2E5UzaUn6wvHbPgIaGmRjOuSSXEp0XbRGK7eek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aR7PbQs0NHZQVc72k4TvjFri4NyuzqUepN+OCYm3T5y73RNJfN4XyHwli9CHWmZy/
         GDEfnPjdy/gCqaCywReJpf1qjd91DDC1cfUg9iSH0+eb3ELNVp+iXs5VSQKTTi3J85
         I2/Drz3tR/gNP+kcTahBL6BnHGQUdNRmJZPF3Y6BnKRW3vZd4jM4TCETzgTFBRa3rg
         5N6YLxBssWVa3iQmOOnxesTy69ewXFf6HiQYfDAOXm4oHbw6sV2WSNqvjM8kVLmny3
         GFozGZW1XFo/3tr2UPMK7csrTW5jruwjSZcT3SXu/QVcYsJjxz2/eQwyW0mIpNt3MD
         nQPpsrZLQJFqQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anirudh Rayabharam <mail@anirudhrb.com>,
        syzbot+7c2bb71996f95a82524c@syzkaller.appspotmail.com,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 04/15] HID: usbhid: fix info leak in hid_submit_ctrl
Date:   Mon,  7 Jun 2021 12:15:32 -0400
Message-Id: <20210607161543.3584778-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161543.3584778-1-sashal@kernel.org>
References: <20210607161543.3584778-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anirudh Rayabharam <mail@anirudhrb.com>

[ Upstream commit 6be388f4a35d2ce5ef7dbf635a8964a5da7f799f ]

In hid_submit_ctrl(), the way of calculating the report length doesn't
take into account that report->size can be zero. When running the
syzkaller reproducer, a report of size 0 causes hid_submit_ctrl) to
calculate transfer_buffer_length as 16384. When this urb is passed to
the usb core layer, KMSAN reports an info leak of 16384 bytes.

To fix this, first modify hid_report_len() to account for the zero
report size case by using DIV_ROUND_UP for the division. Then, call it
from hid_submit_ctrl().

Reported-by: syzbot+7c2bb71996f95a82524c@syzkaller.appspotmail.com
Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
Acked-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/usbhid/hid-core.c | 2 +-
 include/linux/hid.h           | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 7838343eb37c..b6600329a272 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -372,7 +372,7 @@ static int hid_submit_ctrl(struct hid_device *hid)
 	raw_report = usbhid->ctrl[usbhid->ctrltail].raw_report;
 	dir = usbhid->ctrl[usbhid->ctrltail].dir;
 
-	len = ((report->size - 1) >> 3) + 1 + (report->id > 0);
+	len = hid_report_len(report);
 	if (dir == USB_DIR_OUT) {
 		usbhid->urbctrl->pipe = usb_sndctrlpipe(hid_to_usb_dev(hid), 0);
 		usbhid->urbctrl->transfer_buffer_length = len;
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 41c372573a28..2ed6850356ea 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -1127,8 +1127,7 @@ static inline void hid_hw_wait(struct hid_device *hdev)
  */
 static inline u32 hid_report_len(struct hid_report *report)
 {
-	/* equivalent to DIV_ROUND_UP(report->size, 8) + !!(report->id > 0) */
-	return ((report->size - 1) >> 3) + 1 + (report->id > 0);
+	return DIV_ROUND_UP(report->size, 8) + (report->id > 0);
 }
 
 int hid_report_raw_event(struct hid_device *hid, int type, u8 *data, u32 size,
-- 
2.30.2

