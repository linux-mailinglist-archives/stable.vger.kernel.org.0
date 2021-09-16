Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 212F340E580
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345927AbhIPRMI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:12:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:37568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245477AbhIPRKG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:10:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F4C4613E8;
        Thu, 16 Sep 2021 16:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810263;
        bh=Ro5hnwtteUQgbUV0dW/07sQ67En5/vCj9MEXfNkuXoM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZyN1NNbvICQn4zJT52aIKLeMi2tQLY2/qveJnVF59uQqpCdRWcgTD4Xs8xK5pkfnz
         xu8p2MOGVYon1p+R4pQbZEahK5L7/R/z/hE0KrN9/ygoajwMMDIyEzOd8Pj+AlYwAH
         pFVahtQFtuTXc9e2BDY50MjRznbgDieimvpjaAMo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kenneth Albanowski <kenalba@google.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 076/432] HID: input: do not report stylus battery state as "full"
Date:   Thu, 16 Sep 2021 17:57:05 +0200
Message-Id: <20210916155813.362278134@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
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
index 4286a51f7f16..4b5ebeacd283 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -419,8 +419,6 @@ static int hidinput_get_battery_property(struct power_supply *psy,
 
 		if (dev->battery_status == HID_BATTERY_UNKNOWN)
 			val->intval = POWER_SUPPLY_STATUS_UNKNOWN;
-		else if (dev->battery_capacity == 100)
-			val->intval = POWER_SUPPLY_STATUS_FULL;
 		else
 			val->intval = POWER_SUPPLY_STATUS_DISCHARGING;
 		break;
-- 
2.30.2



