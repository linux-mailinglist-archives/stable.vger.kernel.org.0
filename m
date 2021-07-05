Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 687773BC04F
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232585AbhGEPfV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:35:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:58876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232810AbhGEPeR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:34:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DACE619D2;
        Mon,  5 Jul 2021 15:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625499076;
        bh=tLzq40I5rp2sftIpF6kx7cinp4UMtxwfUEqPR7i3oVc=;
        h=From:To:Cc:Subject:Date:From;
        b=qW+rcHALE9TYuEX2APV1s09kLw1gHTAeuXLXla3V7Wcow/o+5G/kBJKjY+c78Wrp4
         M1PcrqphRIWfHSoiIcVFKcAUmBROi4g8tWzLDEC9pU4dWbqU4Ihd8uZZFQTng7PAwO
         S2gTEa9bvpsYBJ4JvWM8QK4J+wBjKz7H1FbOC56XpKrBhuTXHaORINircTeXRIIPkj
         AjgrZvL9ts9XG1844Z/Mv0Omy5GkB7Ds9FMvyrQUpYqRYkcZn+uo71tAIUXgDLyt0R
         JNNdabcNdhdEVQvV6Z/TlDivoGgc4bQwsf5Y0qAWV0DGqwaxwyiOyMlP02X3/AU5ib
         9rtWCzWfskBOg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 01/17] HID: do not use down_interruptible() when unbinding devices
Date:   Mon,  5 Jul 2021 11:30:57 -0400
Message-Id: <20210705153114.1522046-1-sashal@kernel.org>
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
index acbbc21e6233..4549fbb74156 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2124,12 +2124,8 @@ static int hid_device_remove(struct device *dev)
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
@@ -2144,8 +2140,8 @@ static int hid_device_remove(struct device *dev)
 
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

