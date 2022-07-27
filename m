Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE8DA582F29
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241727AbiG0RVu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:21:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241742AbiG0RUG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:20:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CFC25FE5;
        Wed, 27 Jul 2022 09:45:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A72960D38;
        Wed, 27 Jul 2022 16:45:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A882C433D6;
        Wed, 27 Jul 2022 16:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940310;
        bh=zGCAgJhBf44iFooeQHPvXDPv29VQrkH+AaDCuOzx3rs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gwWZYoPUUyYcqhSxkJNKvyXXSHS0z5Sn9cV9bL9XYS9ptWr24KyitbiUOT/JB2wyt
         chIJM/5eLeP+e2hI0A53p7OYaJ4KDZGEfqpdwkRxjDI6vX6VLdyMdTQPdeV0GfnfMQ
         bTlyKNtDT7JX4375GBuGFqsx8Emd5gsdyHkF2RMc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 172/201] um: virtio_uml: Allow probing from devicetree
Date:   Wed, 27 Jul 2022 18:11:16 +0200
Message-Id: <20220727161034.940412654@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Whitchurch <vincent.whitchurch@axis.com>

[ Upstream commit db0dd9cee82270e032123169ceff659eced5115d ]

Allow the virtio_uml device to be probed from the devicetree so that
sub-devices can be specified using the standard virtio bindings, for
example:

  virtio@1 {
    compatible = "virtio,uml";
    socket-path = "i2c.sock";
    virtio-device-id = <0x22>;

    i2c-controller {
      compatible = "virtio,device22";
      #address-cells = <0x01>;
      #size-cells = <0x00>;

      light-sensor@01 {
        compatible = "ti,opt3001";
        reg = <0x01>;
      };
    };
  };

Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/virtio_uml.c | 50 +++++++++++++++++++++++++++++++++---
 1 file changed, 47 insertions(+), 3 deletions(-)

diff --git a/arch/um/drivers/virtio_uml.c b/arch/um/drivers/virtio_uml.c
index 7755cb4ff9fc..ba562d68dc04 100644
--- a/arch/um/drivers/virtio_uml.c
+++ b/arch/um/drivers/virtio_uml.c
@@ -21,6 +21,7 @@
  * Based on Virtio MMIO driver by Pawel Moll, copyright 2011-2014, ARM Ltd.
  */
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/virtio.h>
@@ -49,6 +50,7 @@ struct virtio_uml_platform_data {
 struct virtio_uml_device {
 	struct virtio_device vdev;
 	struct platform_device *pdev;
+	struct virtio_uml_platform_data *pdata;
 
 	spinlock_t sock_lock;
 	int sock, req_fd, irq;
@@ -149,7 +151,7 @@ static int vhost_user_recv(struct virtio_uml_device *vu_dev,
 	if (rc == -ECONNRESET && vu_dev->registered) {
 		struct virtio_uml_platform_data *pdata;
 
-		pdata = vu_dev->pdev->dev.platform_data;
+		pdata = vu_dev->pdata;
 
 		virtio_break_device(&vu_dev->vdev);
 		schedule_work(&pdata->conn_broken_wk);
@@ -1115,21 +1117,63 @@ void virtio_uml_set_no_vq_suspend(struct virtio_device *vdev,
 		 no_vq_suspend ? "dis" : "en");
 }
 
+static void vu_of_conn_broken(struct work_struct *wk)
+{
+	/*
+	 * We can't remove the device from the devicetree so the only thing we
+	 * can do is warn.
+	 */
+	WARN_ON(1);
+}
+
 /* Platform device */
 
+static struct virtio_uml_platform_data *
+virtio_uml_create_pdata(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct virtio_uml_platform_data *pdata;
+	int ret;
+
+	if (!np)
+		return ERR_PTR(-EINVAL);
+
+	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return ERR_PTR(-ENOMEM);
+
+	INIT_WORK(&pdata->conn_broken_wk, vu_of_conn_broken);
+	pdata->pdev = pdev;
+
+	ret = of_property_read_string(np, "socket-path", &pdata->socket_path);
+	if (ret)
+		return ERR_PTR(ret);
+
+	ret = of_property_read_u32(np, "virtio-device-id",
+				   &pdata->virtio_device_id);
+	if (ret)
+		return ERR_PTR(ret);
+
+	return pdata;
+}
+
 static int virtio_uml_probe(struct platform_device *pdev)
 {
 	struct virtio_uml_platform_data *pdata = pdev->dev.platform_data;
 	struct virtio_uml_device *vu_dev;
 	int rc;
 
-	if (!pdata)
-		return -EINVAL;
+	if (!pdata) {
+		pdata = virtio_uml_create_pdata(pdev);
+		if (IS_ERR(pdata))
+			return PTR_ERR(pdata);
+	}
 
 	vu_dev = kzalloc(sizeof(*vu_dev), GFP_KERNEL);
 	if (!vu_dev)
 		return -ENOMEM;
 
+	vu_dev->pdata = pdata;
 	vu_dev->vdev.dev.parent = &pdev->dev;
 	vu_dev->vdev.dev.release = virtio_uml_release_dev;
 	vu_dev->vdev.config = &virtio_uml_config_ops;
-- 
2.35.1



