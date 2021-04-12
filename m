Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29B5E35C0C0
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241359AbhDLJPv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:15:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:34436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240688AbhDLJKw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:10:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24647613A5;
        Mon, 12 Apr 2021 09:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218376;
        bh=MaonFe0P29mlpVyI4IJtLAmzcFhOXzrA9W13F2j3yXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0YKLeLUlBmawcgDMN/gse3tajqBlKm3TKyPRvqRDOVzY3lbydl9uIfqR/SfwDRV7r
         h8oSF065gWVaUF/MgW44rD32Q7G88oXBOwiiOwm57uG7InKsZQ+bL9+iuLombDbZFe
         G2xmhlpmruNppaNM14ywEkkbL8H71nJb/zgQd0io=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Elia Devito <eliadevito@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 175/210] platform/x86: intel-hid: Fix spurious wakeups caused by tablet-mode events during suspend
Date:   Mon, 12 Apr 2021 10:41:20 +0200
Message-Id: <20210412084021.843622620@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit a3790a8a94fc0234c5d38013b48e74ef221ec84c ]

Some devices send (duplicate) tablet-mode events when moved around even
though the mode has not changed; and they do this even when suspended.

Change the tablet-mode event handling when priv->wakeup_mode is set to
update the switch state in case it changed and then return immediately
(without calling pm_wakeup_hard_event()) to avoid spurious wakeups.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=212537
Fixes: 537b0dd4729e ("platform/x86: intel-hid: Add support for SW_TABLET_MODE")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Elia Devito <eliadevito@gmail.com>
Link: https://lore.kernel.org/r/20210404143831.25173-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel-hid.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/platform/x86/intel-hid.c b/drivers/platform/x86/intel-hid.c
index 57cc92891a57..078648a9201b 100644
--- a/drivers/platform/x86/intel-hid.c
+++ b/drivers/platform/x86/intel-hid.c
@@ -483,11 +483,16 @@ static void notify_handler(acpi_handle handle, u32 event, void *context)
 			goto wakeup;
 
 		/*
-		 * Switch events will wake the device and report the new switch
-		 * position to the input subsystem.
+		 * Some devices send (duplicate) tablet-mode events when moved
+		 * around even though the mode has not changed; and they do this
+		 * even when suspended.
+		 * Update the switch state in case it changed and then return
+		 * without waking up to avoid spurious wakeups.
 		 */
-		if (priv->switches && (event == 0xcc || event == 0xcd))
-			goto wakeup;
+		if (event == 0xcc || event == 0xcd) {
+			report_tablet_mode_event(priv->switches, event);
+			return;
+		}
 
 		/* Wake up on 5-button array events only. */
 		if (event == 0xc0 || !priv->array)
@@ -501,9 +506,6 @@ static void notify_handler(acpi_handle handle, u32 event, void *context)
 wakeup:
 		pm_wakeup_hard_event(&device->dev);
 
-		if (report_tablet_mode_event(priv->switches, event))
-			return;
-
 		return;
 	}
 
-- 
2.30.2



