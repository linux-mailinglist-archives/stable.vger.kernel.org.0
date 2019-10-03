Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB71BCA604
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404756AbfJCQjF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:39:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:47728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404700AbfJCQiH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:38:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A50B821783;
        Thu,  3 Oct 2019 16:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120686;
        bh=L0SmYGtaGcxI3+BLpfscRZ+R1XBFygt6MAgF3wzw8/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z+1Ta1xKwhsl7y+aFZQnoEMzuLwm2HhuUMa5UWrDXdHLzYoRg6nRq3qcwKL8RCiwd
         65vXIHyXP65a2rVQaQpdUGEU2f9Hm/cuap9q/jpTuedS4XhUxfvdSJDOl3IVYxxakY
         B+bFg8fnSdIwN3OVA4dCpEceKjXq5+mIwB7Im1As=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pi-Hsun Shih <pihsun@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 313/313] platform/chrome: cros_ec_rpmsg: Fix race with host command when probe failed
Date:   Thu,  3 Oct 2019 17:54:51 +0200
Message-Id: <20191003154604.030111391@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pi-Hsun Shih <pihsun@chromium.org>

[ Upstream commit 71cddb7097e2b0feb855d7fd7d59afd12cbee4bb ]

Since the rpmsg_endpoint is created before probe is called, it's
possible that a host event is received during cros_ec_register, and
there would be some pending work in the host_event_work workqueue while
cros_ec_register is called.

If cros_ec_register fails, when the leftover work in host_event_work
run, the ec_dev from the drvdata of the rpdev could be already set to
NULL, causing kernel crash when trying to run cros_ec_get_next_event.

Fix this by creating the rpmsg_endpoint by ourself, and when
cros_ec_register fails (or on remove), destroy the endpoint first (to
make sure there's no more new calls to cros_ec_rpmsg_callback), and then
cancel all works in the host_event_work workqueue.

Cc: stable@vger.kernel.org
Fixes: 2de89fd98958 ("platform/chrome: cros_ec: Add EC host command support using rpmsg")
Signed-off-by: Pi-Hsun Shih <pihsun@chromium.org>
Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_ec_rpmsg.c | 32 +++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/chrome/cros_ec_rpmsg.c b/drivers/platform/chrome/cros_ec_rpmsg.c
index 5d3fb2abad1d6..bec19d4814aba 100644
--- a/drivers/platform/chrome/cros_ec_rpmsg.c
+++ b/drivers/platform/chrome/cros_ec_rpmsg.c
@@ -41,6 +41,7 @@ struct cros_ec_rpmsg {
 	struct rpmsg_device *rpdev;
 	struct completion xfer_ack;
 	struct work_struct host_event_work;
+	struct rpmsg_endpoint *ept;
 };
 
 /**
@@ -72,7 +73,6 @@ static int cros_ec_pkt_xfer_rpmsg(struct cros_ec_device *ec_dev,
 				  struct cros_ec_command *ec_msg)
 {
 	struct cros_ec_rpmsg *ec_rpmsg = ec_dev->priv;
-	struct rpmsg_device *rpdev = ec_rpmsg->rpdev;
 	struct ec_host_response *response;
 	unsigned long timeout;
 	int len;
@@ -85,7 +85,7 @@ static int cros_ec_pkt_xfer_rpmsg(struct cros_ec_device *ec_dev,
 	dev_dbg(ec_dev->dev, "prepared, len=%d\n", len);
 
 	reinit_completion(&ec_rpmsg->xfer_ack);
-	ret = rpmsg_send(rpdev->ept, ec_dev->dout, len);
+	ret = rpmsg_send(ec_rpmsg->ept, ec_dev->dout, len);
 	if (ret) {
 		dev_err(ec_dev->dev, "rpmsg send failed\n");
 		return ret;
@@ -196,11 +196,24 @@ static int cros_ec_rpmsg_callback(struct rpmsg_device *rpdev, void *data,
 	return 0;
 }
 
+static struct rpmsg_endpoint *
+cros_ec_rpmsg_create_ept(struct rpmsg_device *rpdev)
+{
+	struct rpmsg_channel_info chinfo = {};
+
+	strscpy(chinfo.name, rpdev->id.name, RPMSG_NAME_SIZE);
+	chinfo.src = rpdev->src;
+	chinfo.dst = RPMSG_ADDR_ANY;
+
+	return rpmsg_create_ept(rpdev, cros_ec_rpmsg_callback, NULL, chinfo);
+}
+
 static int cros_ec_rpmsg_probe(struct rpmsg_device *rpdev)
 {
 	struct device *dev = &rpdev->dev;
 	struct cros_ec_rpmsg *ec_rpmsg;
 	struct cros_ec_device *ec_dev;
+	int ret;
 
 	ec_dev = devm_kzalloc(dev, sizeof(*ec_dev), GFP_KERNEL);
 	if (!ec_dev)
@@ -225,7 +238,18 @@ static int cros_ec_rpmsg_probe(struct rpmsg_device *rpdev)
 	INIT_WORK(&ec_rpmsg->host_event_work,
 		  cros_ec_rpmsg_host_event_function);
 
-	return cros_ec_register(ec_dev);
+	ec_rpmsg->ept = cros_ec_rpmsg_create_ept(rpdev);
+	if (!ec_rpmsg->ept)
+		return -ENOMEM;
+
+	ret = cros_ec_register(ec_dev);
+	if (ret < 0) {
+		rpmsg_destroy_ept(ec_rpmsg->ept);
+		cancel_work_sync(&ec_rpmsg->host_event_work);
+		return ret;
+	}
+
+	return 0;
 }
 
 static void cros_ec_rpmsg_remove(struct rpmsg_device *rpdev)
@@ -233,6 +257,7 @@ static void cros_ec_rpmsg_remove(struct rpmsg_device *rpdev)
 	struct cros_ec_device *ec_dev = dev_get_drvdata(&rpdev->dev);
 	struct cros_ec_rpmsg *ec_rpmsg = ec_dev->priv;
 
+	rpmsg_destroy_ept(ec_rpmsg->ept);
 	cancel_work_sync(&ec_rpmsg->host_event_work);
 }
 
@@ -249,7 +274,6 @@ static struct rpmsg_driver cros_ec_driver_rpmsg = {
 	},
 	.probe		= cros_ec_rpmsg_probe,
 	.remove		= cros_ec_rpmsg_remove,
-	.callback	= cros_ec_rpmsg_callback,
 };
 
 module_rpmsg_driver(cros_ec_driver_rpmsg);
-- 
2.20.1



