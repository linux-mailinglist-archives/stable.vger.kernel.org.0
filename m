Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 683EC38295E
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 12:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236271AbhEQKHL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 06:07:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:54026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236330AbhEQKGz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 06:06:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD869610C9;
        Mon, 17 May 2021 10:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621245927;
        bh=tYCqLfJRyuJ4yv/1riKqBYwWUTjUR4sj/G4c74/mzEc=;
        h=From:To:Cc:Subject:Date:From;
        b=kVSHPwqLd+WDpDWgi9We7u3KCx9lfKBNXfXd7kL1n+8dg0wlsNSuWPuY4DPe2nMXv
         DPwVBgNmb3r0mKf2u15PM2T0GvODqYjFTiJePB7LrXLrwwNMjTz4nELQe36nOcoS1V
         7nmL3B1jW/3nNaE/fi0dA3J7wdh+MtINgb9pCH8mBD/UVGjWQrq79piJ3uhdiaT8Ee
         /cGpQm78qf8t6CB25aBzZ3AIv9EkkEu/uGflC9uiRSFpZWMOvxcCbYT0DROLvQNqkc
         OZHHHJV09uX3q6lz9aGrrnkX/PNwYI9Az5qaIVC+1vABjVHFeh73ecveZExL2rpsjf
         j81Piw8x/eVqg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1lia7p-0006J5-0K; Mon, 17 May 2021 12:05:25 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Jiri Kosina <jikos@kernel.org>
Cc:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        syzbot+ee6f6e2e68886ca256a8@syzkaller.appspotmail.com,
        stable@vger.kernel.org, Claudio Mettler <claudio@ponyfleisch.ch>,
        Marek Wyborski <marek.wyborski@emwesoft.com>,
        Sean O'Brien <seobrien@chromium.org>
Subject: [PATCH] HID: magicmouse: fix NULL-deref on disconnect
Date:   Mon, 17 May 2021 12:04:30 +0200
Message-Id: <20210517100430.20509-1-johan@kernel.org>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 9d7b18668956 ("HID: magicmouse: add support for Apple Magic
Trackpad 2") added a sanity check for an Apple trackpad but returned
success instead of -ENODEV when the check failed. This means that the
remove callback will dereference the never-initialised driver data
pointer when the driver is later unbound (e.g. on USB disconnect).

Reported-by: syzbot+ee6f6e2e68886ca256a8@syzkaller.appspotmail.com
Fixes: 9d7b18668956 ("HID: magicmouse: add support for Apple Magic Trackpad 2")
Cc: stable@vger.kernel.org      # 4.20
Cc: Claudio Mettler <claudio@ponyfleisch.ch>
Cc: Marek Wyborski <marek.wyborski@emwesoft.com>
Cc: Sean O'Brien <seobrien@chromium.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/hid/hid-magicmouse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index 2bb473d8c424..56dda50aa3d8 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -693,7 +693,7 @@ static int magicmouse_probe(struct hid_device *hdev,
 	if (id->vendor == USB_VENDOR_ID_APPLE &&
 	    id->product == USB_DEVICE_ID_APPLE_MAGICTRACKPAD2 &&
 	    hdev->type != HID_TYPE_USBMOUSE)
-		return 0;
+		return -ENODEV;
 
 	msc = devm_kzalloc(&hdev->dev, sizeof(*msc), GFP_KERNEL);
 	if (msc == NULL) {
-- 
2.26.3

