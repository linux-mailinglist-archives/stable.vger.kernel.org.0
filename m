Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 764EB461F27
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239908AbhK2SoR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:44:17 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:56130 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237476AbhK2Slz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:41:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E1676CE139A;
        Mon, 29 Nov 2021 18:38:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 910E5C53FC7;
        Mon, 29 Nov 2021 18:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211114;
        bh=hWETnBSe4qogJq67JHOa6T+6Lo9CUK5lNWwv2SQokTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=04cneB6xfmmVoNn+KBTgZKu2h92bC9Jvux/gjbrn2ZbOC8R3f7sOr8N8Zk/Uo6l0z
         +9G2RQw3z0p/BfuajWCittangf0oZSm0frkWEIEVGHK4RVYOHUzdzJMMDjsRL2HSRE
         MYiHInLhY1U985/b0m9jsA6LikagyigMJ131vtWo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Claudia Pellegrino <linux@cpellegrino.de>,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 097/179] HID: magicmouse: prevent division by 0 on scroll
Date:   Mon, 29 Nov 2021 19:18:11 +0100
Message-Id: <20211129181722.119489930@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudia Pellegrino <linux@cpellegrino.de>

[ Upstream commit a1091118e0d6d84c2fdb94e6c397ac790bfb9dd6 ]

In hid_magicmouse, if the user has set scroll_speed to a value between
55 and 63 and scrolls seven times in quick succession, the
step_hr variable in the magicmouse_emit_touch function becomes 0.

That causes a division by zero further down in the function when
it does `step_x_hr /= step_hr`.

To reproduce, create `/etc/modprobe.d/hid_magicmouse.conf` with the
following content:

```
options hid_magicmouse scroll_acceleration=1 scroll_speed=55
```

Then reboot, connect a Magic Mouse and scroll seven times quickly.
The system will freeze for a minute, and after that `dmesg` will
confirm that a division by zero occurred.

Enforce a minimum of 1 for the variable so the high resolution
step count can never reach 0 even at maximum scroll acceleration.

Fixes: d4b9f10a0eb6 ("HID: magicmouse: enable high-resolution scroll")

Signed-off-by: Claudia Pellegrino <linux@cpellegrino.de>
Tested-by: José Expósito <jose.exposito89@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-magicmouse.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index 686788ebf3e1e..d7687ce706144 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -256,8 +256,11 @@ static void magicmouse_emit_touch(struct magicmouse_sc *msc, int raw_id, u8 *tda
 		unsigned long now = jiffies;
 		int step_x = msc->touches[id].scroll_x - x;
 		int step_y = msc->touches[id].scroll_y - y;
-		int step_hr = ((64 - (int)scroll_speed) * msc->scroll_accel) /
-			      SCROLL_HR_STEPS;
+		int step_hr =
+			max_t(int,
+			      ((64 - (int)scroll_speed) * msc->scroll_accel) /
+					SCROLL_HR_STEPS,
+			      1);
 		int step_x_hr = msc->touches[id].scroll_x_hr - x;
 		int step_y_hr = msc->touches[id].scroll_y_hr - y;
 
-- 
2.33.0



