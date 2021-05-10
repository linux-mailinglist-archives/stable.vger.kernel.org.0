Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E795E37845E
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233135AbhEJKvr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:51:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:41652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233525AbhEJKuL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:50:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C834619FE;
        Mon, 10 May 2021 10:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643156;
        bh=OwcsqU4PLySawmBUJfohkZ3H3aAEwZ96ZNnc4P1EYA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cz8eroWLhy1HzgVJfeRDRLcNbFOf8uef1ZkdOrglCzSooHHMJxrSgZXG7AtC9vkdl
         OzWA34XhBRnNShXA91Tg2Zodjcd6zzCLXAo4LOFPApy4shy0ZCnbhfNBHvQ8JKBUxX
         u6FqL9Qu+P815HYm5q2ZCFkCooZHntiF+COD524Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Carl Philipp Klemm <philipp@uvos.xyz>,
        Tony Lindgren <tony@atomide.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 165/299] power: supply: cpcap-charger: Add usleep to cpcap charger to avoid usb plug bounce
Date:   Mon, 10 May 2021 12:19:22 +0200
Message-Id: <20210510102010.401939099@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Carl Philipp Klemm <philipp@uvos.xyz>

[ Upstream commit 751faedf06e895a17e985a88ef5b6364ffd797ed ]

Adds 80000 us sleep when the usb cable is plugged in to hopefully avoid
bouncing contacts.

Upon pluging in the usb cable vbus will bounce for some time, causing cpcap to
dissconnect charging due to detecting an undervoltage condition. This is a
scope of vbus on xt894 while quickly inserting the usb cable with firm force,
probed at the far side of the usb socket and vbus loaded with approx 1k:
http://uvos.xyz/maserati/usbplug.jpg.

As can clearly be seen, vbus is all over the place for the first 15 ms or so
with a small blip at ~40 ms this causes the cpcap to trip up and disable
charging again.

The delay helps cpcap_usb_detect avoid the worst of this. It is, however, still
not ideal as strong vibrations can cause the issue to reapear any time during
charging. I have however not been able to cause the device to stop charging due
to this in practice as it is hard to vibrate the device such that the vbus pins
start bouncing again but cpcap_usb_detect is not called again due to a detected
disconnect/reconnect event.

Signed-off-by: Carl Philipp Klemm <philipp@uvos.xyz>
Tested-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/cpcap-charger.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/power/supply/cpcap-charger.c b/drivers/power/supply/cpcap-charger.c
index 22fff01425d6..891e1eb8e39d 100644
--- a/drivers/power/supply/cpcap-charger.c
+++ b/drivers/power/supply/cpcap-charger.c
@@ -633,6 +633,9 @@ static void cpcap_usb_detect(struct work_struct *work)
 		return;
 	}
 
+	/* Delay for 80ms to avoid vbus bouncing when usb cable is plugged in */
+	usleep_range(80000, 120000);
+
 	/* Throttle chrgcurr2 interrupt for charger done and retry */
 	switch (ddata->state) {
 	case CPCAP_CHARGER_CHARGING:
-- 
2.30.2



