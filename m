Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 785D0411FF8
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345382AbhITRrU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:47:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:51348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353532AbhITRpJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:45:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 263FA6187D;
        Mon, 20 Sep 2021 17:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157800;
        bh=lsZ68qhhRhGkJwDdVYPaZdXrc3xqCYIPrfP8kZoODPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cDUJsTI6HlOOJx5kMJfrfw4wdDfopDozI9EhdDGvujBZ4rihcu+rED1ACOs1+jC8x
         sLlNQ0GMONyOIfT4a+19KpFK1pBaBJ1MH1cOi/0tI4No/z99ZEGPLVwNne7uN9vpaH
         nYv46MMEMQVfCIxbqdIzE0qvyf61620TUVsNVxh8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kenneth Albanowski <kenalba@google.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 157/293] HID: input: do not report stylus battery state as "full"
Date:   Mon, 20 Sep 2021 18:41:59 +0200
Message-Id: <20210920163938.661995241@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit f4abaa9eebde334045ed6ac4e564d050f1df3013 ]

The power supply states of discharging, charging, full, etc, represent
state of charging, not the capacity level of the battery (for which
we have a separate property). Current HID usage tables to not allow
for expressing charging state of the batteries found in generic
styli, so we should simply assume that the battery is discharging
even if current capacity is at 100% when battery strength reporting
is done via HID interface. In fact, we were doing just that before
commit 581c4484769e.

This change helps UIs to not mis-represent fully charged batteries in
styli as being charging/topping-off.

Fixes: 581c4484769e ("HID: input: map digitizer battery usage")
Reported-by: Kenneth Albanowski <kenalba@google.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-input.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 4dd151b2924e..d56ef395eb69 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -427,8 +427,6 @@ static int hidinput_get_battery_property(struct power_supply *psy,
 
 		if (dev->battery_status == HID_BATTERY_UNKNOWN)
 			val->intval = POWER_SUPPLY_STATUS_UNKNOWN;
-		else if (dev->battery_capacity == 100)
-			val->intval = POWER_SUPPLY_STATUS_FULL;
 		else
 			val->intval = POWER_SUPPLY_STATUS_DISCHARGING;
 		break;
-- 
2.30.2



