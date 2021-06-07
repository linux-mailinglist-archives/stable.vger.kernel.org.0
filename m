Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C83E39E1D8
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231535AbhFGQOW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:14:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:47422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231382AbhFGQOR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:14:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8F0D61380;
        Mon,  7 Jun 2021 16:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082346;
        bh=rw9OtMzykAKIRnVFKBRCJO42Dv3xma8kkNsPO2gMGgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uvYVHQiybfW26fMIVtKYGxHbEkgQaYDe8UNlPh+e6xYdMqDAUKOuSZDpvGFJIjaWZ
         Sapu/0I+UW328n40NBNCKM0T+FzVzTasW7hlvqEuuKFIlW1OAAKzhExq9xqJpR8Ty9
         MrIMcksHRdymdABPuioaHGheYkDPrvy2grbfAR77sGLsYNm5p2qy5Uved6NQIvSPcD
         rP7aaQir25otS6ZHUr0YR8rLyIZqOe13OjHFbDwm6gTj4Il5e3iAuneKQNlKuFUD4H
         vKFWma3yHgO9tl2g48xQ2kmNjd8gFY2uPtZz4Ndv2uu+/wXw1SKrstTMspQCHvMUMi
         lM24UbSAD3qGA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luke D Jones <luke@ljones.dev>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 08/49] HID: asus: filter G713/G733 key event to prevent shutdown
Date:   Mon,  7 Jun 2021 12:11:34 -0400
Message-Id: <20210607161215.3583176-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161215.3583176-1-sashal@kernel.org>
References: <20210607161215.3583176-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luke D Jones <luke@ljones.dev>

[ Upstream commit c980512b4512adf2c6f9edb948ce19423b23124d ]

The G713 and G733 both emit an unexpected keycode on some key
presses such as Fn+Pause. The device in this case is emitting
two events on key down, and 3 on key up, the third key up event
is report ID 0x02 and is unfiltered, causing incorrect event.

This patch filters out the single problematic event.

Signed-off-by: Luke D Jones <luke@ljones.dev>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-asus.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/hid/hid-asus.c b/drivers/hid/hid-asus.c
index 1ed1c05c3d54..60606c11bdaf 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -355,6 +355,16 @@ static int asus_raw_event(struct hid_device *hdev,
 				return -1;
 			}
 		}
+		if (drvdata->quirks & QUIRK_ROG_NKEY_KEYBOARD) {
+			/*
+			 * G713 and G733 send these codes on some keypresses, depending on
+			 * the key pressed it can trigger a shutdown event if not caught.
+			*/
+			if(data[0] == 0x02 && data[1] == 0x30) {
+				return -1;
+			}
+		}
+
 	}
 
 	return 0;
-- 
2.30.2

