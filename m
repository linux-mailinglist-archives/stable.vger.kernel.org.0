Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79BDB40DF2B
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbhIPQHM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:07:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:46666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233083AbhIPQHE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:07:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D443961263;
        Thu, 16 Sep 2021 16:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808343;
        bh=Gu7JCVohVotJTRucFHdqrqHjRRLjk7V4vTgNo7ThTPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZHT7OkytrL6bYj3UGayFwHlhhjgiiI9vDHpq+FU2m4M0VMgxQwdLgyB/rpMcnIhA8
         Q7kEV2DoOw3UhDwDcoIdwJJNKtV2nEy+NX/mvzLyil2GoffnVmr7kOm+13K+XmW43V
         eFMbVYwvgY+Y5DtQxQPh6iy1hb8ARjdTBM5LZy1o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kenneth Albanowski <kenalba@google.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 054/306] HID: input: do not report stylus battery state as "full"
Date:   Thu, 16 Sep 2021 17:56:39 +0200
Message-Id: <20210916155755.790110920@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
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
index d1ab2dccf6fd..580d378342c4 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -415,8 +415,6 @@ static int hidinput_get_battery_property(struct power_supply *psy,
 
 		if (dev->battery_status == HID_BATTERY_UNKNOWN)
 			val->intval = POWER_SUPPLY_STATUS_UNKNOWN;
-		else if (dev->battery_capacity == 100)
-			val->intval = POWER_SUPPLY_STATUS_FULL;
 		else
 			val->intval = POWER_SUPPLY_STATUS_DISCHARGING;
 		break;
-- 
2.30.2



