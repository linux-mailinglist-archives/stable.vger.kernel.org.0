Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE1D45E560
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 03:39:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358543AbhKZClr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 21:41:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:49868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358343AbhKZCjo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 21:39:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CD3461245;
        Fri, 26 Nov 2021 02:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637894045;
        bh=GSP3UZ7sKxYc+dtiH8QG+sbHE7U8JQS0WY4IwXsaMZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l7YedSqVUyKD3d5irzhGXHGlyzoa/K3BY+DR3LGuOY4PdjbEtGSzAakgFWoj9Ls8B
         +sB/Pu3bKQFfz5Dym/gwBjWoNNnKQrrK/gcVMB6ADZZfZooXQn7v83uAibeWSXs/+F
         650rNi6p8JH/F4OiPjwlr1XKqw4wKWNjhorUSFk5g8hO8auwe4Ka/2LRtvzLvEmN6S
         WpufJl2DEM79PQ5r5Cgep+o+XeHF5xC9zJUA3Nr1pHLWUkdIFVrDeHnkKFmqV5E9vY
         pbgwuXDbC4U/ib14wVmF5AOBNdTSgm/EkEwsjNvb95nHgHgH50QrsDGDN8v1toMDNI
         l7o8WuuQnwmDg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Slark Xiao <slark_xiao@163.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, hmh@hmh.eng.br,
        markgross@kernel.org, ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 13/28] platform/x86: thinkpad_acpi: Fix WWAN device disabled issue after S3 deep
Date:   Thu, 25 Nov 2021 21:33:28 -0500
Message-Id: <20211126023343.442045-13-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023343.442045-1-sashal@kernel.org>
References: <20211126023343.442045-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Slark Xiao <slark_xiao@163.com>

[ Upstream commit 39f53292181081d35174a581a98441de5da22bc9 ]

When WWAN device wake from S3 deep, under thinkpad platform,
WWAN would be disabled. This disable status could be checked
by command 'nmcli r wwan' or 'rfkill list'.

Issue analysis as below:
  When host resume from S3 deep, thinkpad_acpi driver would
call hotkey_resume() function. Finnaly, it will use
wan_get_status to check the current status of WWAN device.
During this resume progress, wan_get_status would always
return off even WWAN boot up completely.
  In patch V2, Hans said 'sw_state should be unchanged
after a suspend/resume. It's better to drop the
tpacpi_rfk_update_swstate call all together from the
resume path'.
  And it's confimed by Lenovo that GWAN is no longer
 available from WHL generation because the design does not
 match with current pin control.

Signed-off-by: Slark Xiao <slark_xiao@163.com>
Link: https://lore.kernel.org/r/20211108060648.8212-1-slark_xiao@163.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/thinkpad_acpi.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 840bbc312aedd..d8d241344d22d 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -1170,15 +1170,6 @@ static int tpacpi_rfk_update_swstate(const struct tpacpi_rfk *tp_rfk)
 	return status;
 }
 
-/* Query FW and update rfkill sw state for all rfkill switches */
-static void tpacpi_rfk_update_swstate_all(void)
-{
-	unsigned int i;
-
-	for (i = 0; i < TPACPI_RFK_SW_MAX; i++)
-		tpacpi_rfk_update_swstate(tpacpi_rfkill_switches[i]);
-}
-
 /*
  * Sync the HW-blocking state of all rfkill switches,
  * do notice it causes the rfkill core to schedule uevents
@@ -3121,9 +3112,6 @@ static void tpacpi_send_radiosw_update(void)
 	if (wlsw == TPACPI_RFK_RADIO_OFF)
 		tpacpi_rfk_update_hwblock_state(true);
 
-	/* Sync sw blocking state */
-	tpacpi_rfk_update_swstate_all();
-
 	/* Sync hw blocking state last if it is hw-unblocked */
 	if (wlsw == TPACPI_RFK_RADIO_ON)
 		tpacpi_rfk_update_hwblock_state(false);
-- 
2.33.0

