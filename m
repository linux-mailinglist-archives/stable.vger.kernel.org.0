Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAF2E45E500
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 03:39:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358238AbhKZCiR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 21:38:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:48580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357814AbhKZCgK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 21:36:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0854261184;
        Fri, 26 Nov 2021 02:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637893953;
        bh=n3597jHgL7vSM4mrRLxmd/92eVmOD7NHilGmdvqz/JA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EoEVJQ7FjkEmtastP93PyKL748tIIP2VkawzST5fCayZdWbxvIhM8F6L04H+9K+to
         aVxBKPd7epO8liC5230BECV3iqBO6g+pNDKd5SN4VMdYimm+IwiKMnBCHHePrOH3yH
         1bRztgbOPYzORO87xOVRWJuB3w4IaH1zU+FU9YH48nsRH8Wji7rSHJpD2/EX9N7dp1
         cq8O+eV+Y5yGBsDYL+FnmXwfTklJgMh62yGtwNbv6b3jHnltkrmYoYW4fL3ca3Ce6L
         e438JWTy47J5NRwutz+eZA7M3/mQ7sa4uRhU5PEd4M8rDLBO39VtEVvbS5D8jrVf5Z
         LDRmktCLmlqrQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Slark Xiao <slark_xiao@163.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, hmh@hmh.eng.br,
        markgross@kernel.org, ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 17/39] platform/x86: thinkpad_acpi: Fix WWAN device disabled issue after S3 deep
Date:   Thu, 25 Nov 2021 21:31:34 -0500
Message-Id: <20211126023156.441292-17-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023156.441292-1-sashal@kernel.org>
References: <20211126023156.441292-1-sashal@kernel.org>
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
index 6aa31816159cf..3dc055ce6e61b 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -1178,15 +1178,6 @@ static int tpacpi_rfk_update_swstate(const struct tpacpi_rfk *tp_rfk)
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
@@ -3129,9 +3120,6 @@ static void tpacpi_send_radiosw_update(void)
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

