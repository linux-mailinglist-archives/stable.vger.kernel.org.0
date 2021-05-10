Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B30A6378630
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234497AbhEJLEm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:04:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235025AbhEJK5a (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:57:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5653361959;
        Mon, 10 May 2021 10:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643867;
        bh=OwcsqU4PLySawmBUJfohkZ3H3aAEwZ96ZNnc4P1EYA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uV0yDScDhc/tIqJKoCekFvypsAFiGPKI82XI4sQHJmyjefdsygitBJzvoEG5m0urr
         j8OG9H4MtEwjCAxv2GnS3S73T8j7XDmWp/ctjRuAcPbe13gkJMjlMjfaMj5hMs6seR
         j1LOpjT2YdJIwo5pugrguZtzG+dJp1vcLOTQrZJ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Carl Philipp Klemm <philipp@uvos.xyz>,
        Tony Lindgren <tony@atomide.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 192/342] power: supply: cpcap-charger: Add usleep to cpcap charger to avoid usb plug bounce
Date:   Mon, 10 May 2021 12:19:42 +0200
Message-Id: <20210510102016.435944323@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
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



