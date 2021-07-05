Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5252F3BBEDF
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231702AbhGEPaz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:30:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:55174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231535AbhGEPay (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:30:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1204361261;
        Mon,  5 Jul 2021 15:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625498897;
        bh=AvVlSDNy0AAtQWk8lZb/vzYhrKvuJa3s3p+idilQiEg=;
        h=From:To:Cc:Subject:Date:From;
        b=Tn6B0CMukrko9DexBYrVeQuKNSThdFV1OcNk69ZfmSOsXX06wi1X0fGyBlodrgWJV
         h2+Vr1fZzsRuaoW3IEPgnVIUSg5sm6Od9XOU+mMuyXhSe70x8vowoXTXxyd4dqlz3J
         JT46Qvaaa6lft/puNeqBKcHonCmEADHa2V7tgcP81CffzKdnMal9pWZaZQ3h6CDU2x
         PRONoU94tC24qsnli041nkb+DEoQJYOohQFDtaQoIOrNbmV/EB1krMbXmjGn/dReFt
         4yq7vW3nKULfNHpwkPxptd4WKQU6qqrN2wHEmnBCVhuW0iv70S3iKOBIWLzso+TZ0A
         O851boWTR7DwA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 01/59] HID: do not use down_interruptible() when unbinding devices
Date:   Mon,  5 Jul 2021 11:27:17 -0400
Message-Id: <20210705152815.1520546-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit f2145f8dc566c4f3b5a8deb58dcd12bed4e20194 ]

Action of unbinding driver from a device is not cancellable and should not
fail, and driver core does not pay attention to the result of "remove"
method, therefore using down_interruptible() in hid_device_remove() does
not make sense.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-core.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 0de2788b9814..7db332139f7d 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2306,12 +2306,8 @@ static int hid_device_remove(struct device *dev)
 {
 	struct hid_device *hdev = to_hid_device(dev);
 	struct hid_driver *hdrv;
-	int ret = 0;
 
-	if (down_interruptible(&hdev->driver_input_lock)) {
-		ret = -EINTR;
-		goto end;
-	}
+	down(&hdev->driver_input_lock);
 	hdev->io_started = false;
 
 	hdrv = hdev->driver;
@@ -2326,8 +2322,8 @@ static int hid_device_remove(struct device *dev)
 
 	if (!hdev->io_started)
 		up(&hdev->driver_input_lock);
-end:
-	return ret;
+
+	return 0;
 }
 
 static ssize_t modalias_show(struct device *dev, struct device_attribute *a,
-- 
2.30.2

