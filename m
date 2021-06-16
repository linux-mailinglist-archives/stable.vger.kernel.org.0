Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A57C23A9FAC
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 17:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235108AbhFPPkA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 11:40:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:51360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235128AbhFPPit (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 11:38:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3290C613DF;
        Wed, 16 Jun 2021 15:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623857789;
        bh=HVeLsmrSRwJUos9ss1pz455I7/UCxPtH2jgZwRv0/I4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B+I+QNXVInfw/5MU8zSOaFonYU/hCa+9FE/QfXNMgmRIL1loA1ZvEbyX0Vg/0yHF5
         FWUZpiUfIpZnSMyMTwMxTVJ+iog3PWmvAAiMKP3pQMykPbhBHWLhPhAtcat9w6jRd9
         7LlNt1Qz28UAaAJeuU4ZaaGw4vfMBa+Sk1EnsXsw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+7c2bb71996f95a82524c@syzkaller.appspotmail.com,
        Anirudh Rayabharam <mail@anirudhrb.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 09/38] HID: usbhid: fix info leak in hid_submit_ctrl
Date:   Wed, 16 Jun 2021 17:33:18 +0200
Message-Id: <20210616152835.697511779@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210616152835.407925718@linuxfoundation.org>
References: <20210616152835.407925718@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 17a29ee0ac6c..8d4ac4b9fb9d 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -374,7 +374,7 @@ static int hid_submit_ctrl(struct hid_device *hid)
 	raw_report = usbhid->ctrl[usbhid->ctrltail].raw_report;
 	dir = usbhid->ctrl[usbhid->ctrltail].dir;
 
-	len = ((report->size - 1) >> 3) + 1 + (report->id > 0);
+	len = hid_report_len(report);
 	if (dir == USB_DIR_OUT) {
 		usbhid->urbctrl->pipe = usb_sndctrlpipe(hid_to_usb_dev(hid), 0);
 		usbhid->urbctrl->transfer_buffer_length = len;
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 8578db50ad73..6ed2a97eb55f 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -1156,8 +1156,7 @@ static inline void hid_hw_wait(struct hid_device *hdev)
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



