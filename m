Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 309603CDCF3
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239486AbhGSOyX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:54:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:45268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244055AbhGSOwX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:52:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE2BE601FD;
        Mon, 19 Jul 2021 15:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708738;
        bh=tLzq40I5rp2sftIpF6kx7cinp4UMtxwfUEqPR7i3oVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iBwHbshv8AsaXiRI2UtTCDyT1GTfuSPTvoq+SVHQKNbxD/spw7eHul6DtbVL0Y5bm
         cbx8P6DnN72+SFsGAG453LxRv+5eo4J5RDvtF4drLRbdPOL2SglO9MHvFgKGv20Fkx
         5yRLe3O44J4qiOD4v9wIBtVSxHpxJvvCcQOIxN8c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 077/421] HID: do not use down_interruptible() when unbinding devices
Date:   Mon, 19 Jul 2021 16:48:08 +0200
Message-Id: <20210719144948.812760175@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



