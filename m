Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AABD469A64
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346789AbhLFPHe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:07:34 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38854 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346274AbhLFPGO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:06:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB424B8111D;
        Mon,  6 Dec 2021 15:02:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFA35C341C2;
        Mon,  6 Dec 2021 15:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638802963;
        bh=gvjWPLtzM3BXopeM8WkgcMjOOkskZuLJnSwZKgC41kk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ghD/41mff83i3DrcvZIDWEHgUqopol7R1mJ2H+ACF2j+FW6T5xYawBKSv3Vkt9scR
         t5Kj4zm/VQ+3h9OCoaCr+p2H1f2eEqTJa1+wrnXkkVqI/HzZuIOorozJBWXK0HhdzS
         BjUd9JpYyq5yAFGZ5OAhFDAi6S2Zdl2sbNiL1D/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Slark Xiao <slark_xiao@163.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 41/62] platform/x86: thinkpad_acpi: Fix WWAN device disabled issue after S3 deep
Date:   Mon,  6 Dec 2021 15:56:24 +0100
Message-Id: <20211206145550.627448934@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145549.155163074@linuxfoundation.org>
References: <20211206145549.155163074@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 9c929b5ce58e2..b19a51d12651d 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -1169,15 +1169,6 @@ static int tpacpi_rfk_update_swstate(const struct tpacpi_rfk *tp_rfk)
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
@@ -3029,9 +3020,6 @@ static void tpacpi_send_radiosw_update(void)
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



