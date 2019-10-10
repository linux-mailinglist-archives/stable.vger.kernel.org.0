Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 146ABD23BD
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 10:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389146AbfJJIpa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:45:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:51054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387494AbfJJIp2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:45:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03F832190F;
        Thu, 10 Oct 2019 08:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697127;
        bh=RXDJvWVTo8lu8kyUI4kAD6p3ZVPAu2fNww1xcGZrX4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sQALHGGAAqsHL+7CVE8izClpb0U01OVRskpHDNSlOLFngpMDaApXQ7ELFAM1O9A7T
         rca4Ul7w6PwwIiBvRyujOEvIsip6lDTP00bHPsegEWXOvBY669guRvChDq3ISlgJKk
         g/gxo+GbUBiHyAxNQXmLyeetRI58qPxPM88LMn+k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Nosthoff <committed@heine.so>,
        Brian Norris <briannorris@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 4.19 028/114] power: supply: sbs-battery: use correct flags field
Date:   Thu, 10 Oct 2019 10:35:35 +0200
Message-Id: <20191010083558.685954681@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083544.711104709@linuxfoundation.org>
References: <20191010083544.711104709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Nosthoff <committed@heine.so>

commit 99956a9e08251a1234434b492875b1eaff502a12 upstream.

the type flag is stored in the chip->flags field not in the
client->flags field. This currently leads to never using the ti
specific health function as client->flags doesn't use that bit.
So it's always falling back to the general one.

Fixes: 76b16f4cdfb8 ("power: supply: sbs-battery: don't assume MANUFACTURER_DATA formats")
Cc: <stable@vger.kernel.org>
Signed-off-by: Michael Nosthoff <committed@heine.so>
Reviewed-by: Brian Norris <briannorris@chromium.org>
Reviewed-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/power/supply/sbs-battery.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/power/supply/sbs-battery.c
+++ b/drivers/power/supply/sbs-battery.c
@@ -629,7 +629,7 @@ static int sbs_get_property(struct power
 	switch (psp) {
 	case POWER_SUPPLY_PROP_PRESENT:
 	case POWER_SUPPLY_PROP_HEALTH:
-		if (client->flags & SBS_FLAGS_TI_BQ20Z75)
+		if (chip->flags & SBS_FLAGS_TI_BQ20Z75)
 			ret = sbs_get_ti_battery_presence_and_health(client,
 								     psp, val);
 		else


