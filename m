Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80C29147F95
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733294AbgAXLD3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:03:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:37296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387568AbgAXLD3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:03:29 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D2CB2071A;
        Fri, 24 Jan 2020 11:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579863808;
        bh=/R47wDSfB8zpeWmmkHUrK6cTXsG0BpvTEpbs1Wk73d4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qewq1noSJ1CqupqH/QYeOwkPjgcPZ7aw2Sprgy/D+dB6JVB8t1D6o7lD92Q97lMXM
         m8VgloQxm4rr4l8t67PnhmlEmJJVWMnrHItNDICpCNpLw1Ks7A4pm4C3G7DDDBsLGk
         75XduhiJkMQhbDUYlIaS8WaEsaHeUtPFdSuk8igc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Wahren <stefan.wahren@i2se.com>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 081/639] staging: bcm2835-camera: Abort probe if there is no camera
Date:   Fri, 24 Jan 2020 10:24:11 +0100
Message-Id: <20200124093057.530953361@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Wahren <stefan.wahren@i2se.com>

[ Upstream commit 7566f39dfdc11f8a97d5810c6e6295a88f97ef91 ]

Abort the probing of the camera driver in case there isn't a camera
actually connected to the Raspberry Pi. This solution also avoids a
NULL ptr dereference of mmal instance on driver unload.

Fixes: 7b3ad5abf027 ("staging: Import the BCM2835 MMAL-based V4L2 camera driver.")
Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Reviewed-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../vc04_services/bcm2835-camera/bcm2835-camera.c        | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/staging/vc04_services/bcm2835-camera/bcm2835-camera.c b/drivers/staging/vc04_services/bcm2835-camera/bcm2835-camera.c
index 455082867246d..068e5b9ab2323 100644
--- a/drivers/staging/vc04_services/bcm2835-camera/bcm2835-camera.c
+++ b/drivers/staging/vc04_services/bcm2835-camera/bcm2835-camera.c
@@ -1854,6 +1854,12 @@ static int bcm2835_mmal_probe(struct platform_device *pdev)
 	num_cameras = get_num_cameras(instance,
 				      resolutions,
 				      MAX_BCM2835_CAMERAS);
+
+	if (num_cameras < 1) {
+		ret = -ENODEV;
+		goto cleanup_mmal;
+	}
+
 	if (num_cameras > MAX_BCM2835_CAMERAS)
 		num_cameras = MAX_BCM2835_CAMERAS;
 
@@ -1953,6 +1959,9 @@ cleanup_gdev:
 	pr_info("%s: error %d while loading driver\n",
 		BM2835_MMAL_MODULE_NAME, ret);
 
+cleanup_mmal:
+	vchiq_mmal_finalise(instance);
+
 	return ret;
 }
 
-- 
2.20.1



