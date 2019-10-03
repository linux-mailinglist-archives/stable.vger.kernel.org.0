Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF362C9E11
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 14:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727410AbfJCMKJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 08:10:09 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:58865 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726523AbfJCMKJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 08:10:09 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 1E08021C28;
        Thu,  3 Oct 2019 08:10:08 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 03 Oct 2019 08:10:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=1PoJxO
        DID3RTQhAwI1MFprIlFF/0SnbeMc5GIrJALAg=; b=G6keLlifg8xocPrxxLEb6e
        +Df2hvYL2bjjhETwlLOWLcMJBKhdshE/AaB+P+fF/O/+JvQZCRA+yI8eDaNYzh6R
        4BnVxcM4vKlWQDLN0ob9c4o4J58qBol3ZdMZTyKehzsSR21prn4DPSwsMcAQrCB8
        NvogBHZPvS7SDRzFkvko+Gng19TYm1xBYbC7/E+TplWaQbMhtzV5WAlh1l78Zk4G
        8+0B3swhAoZk/yvCoPB9tJ/LQpKAxaFjtMHQ/yhVCF5TNGZmBYYKV9R1sv5q09ZJ
        bGQiJef6mKaEeFd6A1EyYRzdcsZE0A40QY4Hs3OpN6cWu12CsNMh32ZU4tbf6KSA
        ==
X-ME-Sender: <xms:H-WVXbFuDKBS_MncIXQZ7iInX28xmfBLAjie9h_IvF_NuHGCejmqbw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeekgdehtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:H-WVXSnaqeYKnuFF0Vph_IFIBZL0LNPQZpEuQDDQ_Pn2W_wRXCXQQQ>
    <xmx:H-WVXSlVRxmDtp6UGR7BJQaBjMI5foox7XVPO22_kEMn0HB-vT7c9Q>
    <xmx:H-WVXfU3TTRn5-glsaYBuHFrKfmw8xFU0OqdO8gKIqliO2pqQykWJQ>
    <xmx:IOWVXQAlGFeQ9vmH-04NCteEDVukfbAiRRwxkeRSWRKsnXa_XXHoAQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 89C5D8005C;
        Thu,  3 Oct 2019 08:10:07 -0400 (EDT)
Subject: FAILED: patch "[PATCH] platform/chrome: cros_ec_rpmsg: Fix race with host command" failed to apply to 5.3-stable tree
To:     pihsun@chromium.org, enric.balletbo@collabora.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 03 Oct 2019 14:10:05 +0200
Message-ID: <157010460554182@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.3-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 71cddb7097e2b0feb855d7fd7d59afd12cbee4bb Mon Sep 17 00:00:00 2001
From: Pi-Hsun Shih <pihsun@chromium.org>
Date: Wed, 4 Sep 2019 14:26:13 +0800
Subject: [PATCH] platform/chrome: cros_ec_rpmsg: Fix race with host command
 when probe failed

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

diff --git a/drivers/platform/chrome/cros_ec_rpmsg.c b/drivers/platform/chrome/cros_ec_rpmsg.c
index 8b6bd775cc9a..0c3738c3244d 100644
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
@@ -234,7 +258,7 @@ static void cros_ec_rpmsg_remove(struct rpmsg_device *rpdev)
 	struct cros_ec_rpmsg *ec_rpmsg = ec_dev->priv;
 
 	cros_ec_unregister(ec_dev);
-
+	rpmsg_destroy_ept(ec_rpmsg->ept);
 	cancel_work_sync(&ec_rpmsg->host_event_work);
 }
 
@@ -271,7 +295,6 @@ static struct rpmsg_driver cros_ec_driver_rpmsg = {
 	},
 	.probe		= cros_ec_rpmsg_probe,
 	.remove		= cros_ec_rpmsg_remove,
-	.callback	= cros_ec_rpmsg_callback,
 };
 
 module_rpmsg_driver(cros_ec_driver_rpmsg);

