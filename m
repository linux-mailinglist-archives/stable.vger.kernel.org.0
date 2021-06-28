Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F63C3B6396
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235079AbhF1O6R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:58:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:33816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236867AbhF1O4O (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:56:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41122619BF;
        Mon, 28 Jun 2021 14:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891208;
        bh=ZMRYJ2E5UzaUn6wvHbPgIaGmRjOuSSXEp0XbRGK7eek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z+YoxJySvANBGlU0UifsV9lILWzKKmhPdynzCj+FzZVxlLbv2syQhzx55iDY3c5HE
         Z3MV8K7wxcGL1jUu88dofsaNS9iKUTseBhsh5pbvrasmGlHlViTiLKbLzP44fdP/WP
         aO/9n7E3AlisuE0LkRgIx0GLS27QvM0lox2ck7B4HghGCn6IiwZXYt1hcA+94I2YDL
         VaHGsD95w8tZHC1NiAENIHSEN5pv8kiq8ue1aBRepa6TMTus8GVFilCHSESU8rK9Rd
         Rh2/27Xh+RHAAEY7FVqSPS/roxKmMpstDX5mwv8cc6po93uuiyt8fqoDj+v3ILlmF7
         +cYS8vRQjFeZg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anirudh Rayabharam <mail@anirudhrb.com>,
        syzbot+7c2bb71996f95a82524c@syzkaller.appspotmail.com,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 04/71] HID: usbhid: fix info leak in hid_submit_ctrl
Date:   Mon, 28 Jun 2021 10:38:56 -0400
Message-Id: <20210628144003.34260-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628144003.34260-1-sashal@kernel.org>
References: <20210628144003.34260-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.274-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.274-rc1
X-KernelTest-Deadline: 2021-06-30T14:39+00:00
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

