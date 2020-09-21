Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36BD4272D03
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728426AbgIUQgl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:36:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:36354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727248AbgIUQgc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:36:32 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E98C238E6;
        Mon, 21 Sep 2020 16:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706191;
        bh=vxsrXq1iVCVPmn3PdUADQGC7/PKbgbGJOPvJNxxLMyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gpNkqRCft9X/W9HwztKJSejjToQ08UV04GuQLlMQWHse1W60SVWFUfRSPMEh+IZmw
         uXs3M882lF+RQo1jq6ICYhtZicpbxJGi/65daIbxDLKRSnpr3jBmhpiiCYyga3jwV/
         7bvDbp7+dYZwxCtECH7zA0ktiUZ9jzYAJu3cgPbM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 4.9 64/70] USB: UAS: fix disconnect by unplugging a hub
Date:   Mon, 21 Sep 2020 18:28:04 +0200
Message-Id: <20200921162038.058971659@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162035.136047591@linuxfoundation.org>
References: <20200921162035.136047591@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

commit 325b008723b2dd31de020e85ab9d2e9aa4637d35 upstream.

The SCSI layer can go into an ugly loop if you ignore that a device is
gone. You need to report an error in the command rather than in the
return value of the queue method.

We need to specifically check for ENODEV. The issue goes back to the
introduction of the driver.

Fixes: 115bb1ffa54c3 ("USB: Add UAS driver")
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200916094026.30085-2-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/storage/uas.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -670,8 +670,7 @@ static int uas_queuecommand_lck(struct s
 	if (devinfo->resetting) {
 		cmnd->result = DID_ERROR << 16;
 		cmnd->scsi_done(cmnd);
-		spin_unlock_irqrestore(&devinfo->lock, flags);
-		return 0;
+		goto zombie;
 	}
 
 	/* Find a free uas-tag */
@@ -706,6 +705,16 @@ static int uas_queuecommand_lck(struct s
 		cmdinfo->state &= ~(SUBMIT_DATA_IN_URB | SUBMIT_DATA_OUT_URB);
 
 	err = uas_submit_urbs(cmnd, devinfo);
+	/*
+	 * in case of fatal errors the SCSI layer is peculiar
+	 * a command that has finished is a success for the purpose
+	 * of queueing, no matter how fatal the error
+	 */
+	if (err == -ENODEV) {
+		cmnd->result = DID_ERROR << 16;
+		cmnd->scsi_done(cmnd);
+		goto zombie;
+	}
 	if (err) {
 		/* If we did nothing, give up now */
 		if (cmdinfo->state & SUBMIT_STATUS_URB) {
@@ -716,6 +725,7 @@ static int uas_queuecommand_lck(struct s
 	}
 
 	devinfo->cmnd[idx] = cmnd;
+zombie:
 	spin_unlock_irqrestore(&devinfo->lock, flags);
 	return 0;
 }


