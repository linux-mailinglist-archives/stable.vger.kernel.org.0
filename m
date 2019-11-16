Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38603FF3BD
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:28:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730400AbfKPQ10 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 11:27:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:44806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727940AbfKPPlh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:41:37 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 330592075E;
        Sat, 16 Nov 2019 15:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918896;
        bh=fIClEW6Xb6bv2w8wKJIOdu1DZKfm+EPitpf1xMFHoVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OnslipVTreNDo9bW9ylopikUrejDYPC6d/yOA9BvSngl5ide7asn0Xna+RYne1ptp
         pr7SrzThspS7djtAA7AJu3aKsxlDTPNM/sJvKyGlWS26at7JuCJMrX0U6c8kieQFlj
         FbU5eQ7pb6qELGq0YY140b7lhjZ8KmC0W2GhOoqk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Ondrej Zary <linux@rainbow-software.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 022/237] cdrom: don't attempt to fiddle with cdo->capability
Date:   Sat, 16 Nov 2019 10:37:37 -0500
Message-Id: <20191116154113.7417-22-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 8f94004e2a51a3ea195cf3447eb5d5906f36d8b3 ]

We can't modify cdo->capability as it is defined as a const.
Change the modification hack to just WARN_ON_ONCE() if we hit
any of the invalid combinations.

This fixes a regression for pcd, which doesn't work after the
constify patch.

Fixes: 853fe1bf7554 ("cdrom: Make device operations read-only")
Tested-by: Ondrej Zary <linux@rainbow-software.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cdrom/cdrom.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 27a82a559ab94..933268b8d6a54 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -411,10 +411,10 @@ static int cdrom_get_disc_info(struct cdrom_device_info *cdi,
  * hack to have the capability flags defined const, while we can still
  * change it here without gcc complaining at every line.
  */
-#define ENSURE(call, bits)			\
-do {						\
-	if (cdo->call == NULL)			\
-		*change_capability &= ~(bits);	\
+#define ENSURE(cdo, call, bits)					\
+do {								\
+	if (cdo->call == NULL)					\
+		WARN_ON_ONCE((cdo)->capability & (bits));	\
 } while (0)
 
 /*
@@ -590,7 +590,6 @@ int register_cdrom(struct cdrom_device_info *cdi)
 {
 	static char banner_printed;
 	const struct cdrom_device_ops *cdo = cdi->ops;
-	int *change_capability = (int *)&cdo->capability; /* hack */
 
 	cd_dbg(CD_OPEN, "entering register_cdrom\n");
 
@@ -602,16 +601,16 @@ int register_cdrom(struct cdrom_device_info *cdi)
 		cdrom_sysctl_register();
 	}
 
-	ENSURE(drive_status, CDC_DRIVE_STATUS);
+	ENSURE(cdo, drive_status, CDC_DRIVE_STATUS);
 	if (cdo->check_events == NULL && cdo->media_changed == NULL)
-		*change_capability = ~(CDC_MEDIA_CHANGED | CDC_SELECT_DISC);
-	ENSURE(tray_move, CDC_CLOSE_TRAY | CDC_OPEN_TRAY);
-	ENSURE(lock_door, CDC_LOCK);
-	ENSURE(select_speed, CDC_SELECT_SPEED);
-	ENSURE(get_last_session, CDC_MULTI_SESSION);
-	ENSURE(get_mcn, CDC_MCN);
-	ENSURE(reset, CDC_RESET);
-	ENSURE(generic_packet, CDC_GENERIC_PACKET);
+		WARN_ON_ONCE(cdo->capability & (CDC_MEDIA_CHANGED | CDC_SELECT_DISC));
+	ENSURE(cdo, tray_move, CDC_CLOSE_TRAY | CDC_OPEN_TRAY);
+	ENSURE(cdo, lock_door, CDC_LOCK);
+	ENSURE(cdo, select_speed, CDC_SELECT_SPEED);
+	ENSURE(cdo, get_last_session, CDC_MULTI_SESSION);
+	ENSURE(cdo, get_mcn, CDC_MCN);
+	ENSURE(cdo, reset, CDC_RESET);
+	ENSURE(cdo, generic_packet, CDC_GENERIC_PACKET);
 	cdi->mc_flags = 0;
 	cdi->options = CDO_USE_FFLAGS;
 
-- 
2.20.1

