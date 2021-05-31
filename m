Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD12A396073
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232480AbhEaO1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:27:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:47638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233456AbhEaOZD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:25:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90E666157E;
        Mon, 31 May 2021 13:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468775;
        bh=sVg6SB/8K3yyZdgO0ZP29Rf+pPOA/vY5LIPQHKTVJMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gTSU5SHVJ9AkiWqAdhm7oQid4nELDrt1i5dTPV0ljQ/eZukQTOaZpIFU1KIL5J5DE
         pyUxdxp2tOqr4EIUbiyC7N/k8Urv0EVAVYKAC2AXih+S5iWhVqfsVK2wbzzWDhkv2y
         eJE3hVfQa8ARzgZFIBiatbi2sPs3uzDIfwlYt21g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 088/177] Revert "media: usb: gspca: add a missed check for goto_low_power"
Date:   Mon, 31 May 2021 15:14:05 +0200
Message-Id: <20210531130650.929867579@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit fd013265e5b5576a74a033920d6c571e08d7c423 ]

This reverts commit 5b711870bec4dc9a6d705d41e127e73944fa3650.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to do does nothing useful as a user
can do nothing with this information and if an error did happen, the
code would continue on as before.  Because of this, just revert it.

Cc: Kangjie Lu <kjlu@umn.edu>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Link: https://lore.kernel.org/r/20210503115736.2104747-7-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/gspca/cpia1.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/media/usb/gspca/cpia1.c b/drivers/media/usb/gspca/cpia1.c
index a4f7431486f3..d93d384286c1 100644
--- a/drivers/media/usb/gspca/cpia1.c
+++ b/drivers/media/usb/gspca/cpia1.c
@@ -1424,7 +1424,6 @@ static int sd_config(struct gspca_dev *gspca_dev,
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 	struct cam *cam;
-	int ret;
 
 	sd->mainsFreq = FREQ_DEF == V4L2_CID_POWER_LINE_FREQUENCY_60HZ;
 	reset_camera_params(gspca_dev);
@@ -1436,10 +1435,7 @@ static int sd_config(struct gspca_dev *gspca_dev,
 	cam->cam_mode = mode;
 	cam->nmodes = ARRAY_SIZE(mode);
 
-	ret = goto_low_power(gspca_dev);
-	if (ret)
-		gspca_err(gspca_dev, "Cannot go to low power mode: %d\n",
-			  ret);
+	goto_low_power(gspca_dev);
 	/* Check the firmware version. */
 	sd->params.version.firmwareVersion = 0;
 	get_version_information(gspca_dev);
-- 
2.30.2



