Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 346AB450EC7
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241295AbhKOSTY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:19:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:56284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239086AbhKOSOg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:14:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C37C363269;
        Mon, 15 Nov 2021 17:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998571;
        bh=EWZZMqDChEVRE6v3Fj1Wm/O2D7CsSJLOusrws6Z3K/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZigZyp/UpJIzmZ58v4OQW9M8QVYRBQ4w8DfHuT5BZa20wGN0cZxqSbH3zi38pZk40
         MuVVDvyDfBC4DcyjEHvlzThfy+3OzkgsWt7fWQMKQbEqBh/zWQCJ5+JLe4jrvJEpWS
         MFCmdsVRKUQOEiNWywpGx9qAGtCEyvBU0rX4tWME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 5.10 557/575] video: backlight: Drop maximum brightness override for brightness zero
Date:   Mon, 15 Nov 2021 18:04:42 +0100
Message-Id: <20211115165402.951571036@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

commit 33a5471f8da976bf271a1ebbd6b9d163cb0cb6aa upstream.

The note in c2adda27d202f ("video: backlight: Add of_find_backlight helper
in backlight.c") says that gpio-backlight uses brightness as power state.
This has been fixed since in ec665b756e6f7 ("backlight: gpio-backlight:
Correct initial power state handling") and other backlight drivers do not
require this workaround. Drop the workaround.

This fixes the case where e.g. pwm-backlight can perfectly well be set to
brightness 0 on boot in DT, which without this patch leads to the display
brightness to be max instead of off.

Fixes: c2adda27d202f ("video: backlight: Add of_find_backlight helper in backlight.c")
Cc: <stable@vger.kernel.org> # 5.4+
Cc: <stable@vger.kernel.org> # 4.19.x: ec665b756e6f7: backlight: gpio-backlight: Correct initial power state handling
Signed-off-by: Marek Vasut <marex@denx.de>
Acked-by: Noralf Trønnes <noralf@tronnes.org>
Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/backlight/backlight.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -688,12 +688,6 @@ static struct backlight_device *of_find_
 			of_node_put(np);
 			if (!bd)
 				return ERR_PTR(-EPROBE_DEFER);
-			/*
-			 * Note: gpio_backlight uses brightness as
-			 * power state during probe
-			 */
-			if (!bd->props.brightness)
-				bd->props.brightness = bd->props.max_brightness;
 		}
 	}
 


