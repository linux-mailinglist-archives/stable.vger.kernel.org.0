Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79C2A45C0FC
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244430AbhKXNOH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:14:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:53880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347702AbhKXNKW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:10:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A00061244;
        Wed, 24 Nov 2021 12:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757691;
        bh=fbRDW4GzMnNPx6XtOaPS/giSOKA0M33SGAmnbuZODsA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2DvjaYS3LTQ+iVsAcY+Mk2mUOuibjk6M1hZfSwoMHx2p6gMhUxcuyMmD0FW7iYNQv
         ymOVt819PkSZ3/Wvt5k9p8OmfyolXv3qTQ2RXWjPgQ7/EEGrMwOrfBxog/rLWAivKZ
         fK3PQSxY/IpDN/qRQ9Sbmyse+rh5hLFm9JDM8CmM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.19 245/323] video: backlight: Drop maximum brightness override for brightness zero
Date:   Wed, 24 Nov 2021 12:57:15 +0100
Message-Id: <20211124115727.177359655@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
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
@@ -610,12 +610,6 @@ struct backlight_device *of_find_backlig
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
 


