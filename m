Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9416A54105B
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350159AbiFGTXZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:23:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351539AbiFGTVj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:21:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7787954024;
        Tue,  7 Jun 2022 11:08:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9FA84B81F38;
        Tue,  7 Jun 2022 18:08:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1185EC385A5;
        Tue,  7 Jun 2022 18:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625330;
        bh=h34rondOn47nWzZpl0QqcrreH+sX+3Rn1+rYXxFag80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WLNV7qelLUKureDsMu91Jwe/3ZaMP1lykbieh+rIqajAMFL3gkIVBbqzmAVx2MFqJ
         PCEbzlc+FCoyl4o/IzP4BaOKnSt3DyCEb+bVd0SeLpHPNyWf0lg0dq1hvQR8Tov1L5
         6zrhBNrSX60F3fIvBQLLgqzbK/mr73q1Kd5b+Wdc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mike Leach <mike.leach@linaro.org>,
        Mao Jinlong <quic_jinlmao@quicinc.com>
Subject: [PATCH 5.15 647/667] coresight: core: Fix coresight device probe failure issue
Date:   Tue,  7 Jun 2022 19:05:12 +0200
Message-Id: <20220607164954.059382356@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mao Jinlong <quic_jinlmao@quicinc.com>

commit 8c1d3f79d9ca48e406b78e90e94cf09a8c076bf2 upstream.

It is possibe that probe failure issue happens when the device
and its child_device's probe happens at the same time.
In coresight_make_links, has_conns_grp is true for parent, but
has_conns_grp is false for child device as has_conns_grp is set
to true in coresight_create_conns_sysfs_group. The probe of parent
device will fail at this condition. Add has_conns_grp check for
child device before make the links and make the process from
device_register to connection_create be atomic to avoid this
probe failure issue.

Cc: stable@vger.kernel.org
Suggested-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Suggested-by: Mike Leach <mike.leach@linaro.org>
Signed-off-by: Mao Jinlong <quic_jinlmao@quicinc.com>
Link: https://lore.kernel.org/r/20220309142206.15632-1-quic_jinlmao@quicinc.com
[ Added Cc stable ]
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/coresight/coresight-core.c |   33 ++++++++++++++++++---------
 1 file changed, 22 insertions(+), 11 deletions(-)

--- a/drivers/hwtracing/coresight/coresight-core.c
+++ b/drivers/hwtracing/coresight/coresight-core.c
@@ -1382,7 +1382,7 @@ static int coresight_fixup_device_conns(
 			continue;
 		conn->child_dev =
 			coresight_find_csdev_by_fwnode(conn->child_fwnode);
-		if (conn->child_dev) {
+		if (conn->child_dev && conn->child_dev->has_conns_grp) {
 			ret = coresight_make_links(csdev, conn,
 						   conn->child_dev);
 			if (ret)
@@ -1574,6 +1574,7 @@ struct coresight_device *coresight_regis
 	int nr_refcnts = 1;
 	atomic_t *refcnts = NULL;
 	struct coresight_device *csdev;
+	bool registered = false;
 
 	csdev = kzalloc(sizeof(*csdev), GFP_KERNEL);
 	if (!csdev) {
@@ -1594,7 +1595,8 @@ struct coresight_device *coresight_regis
 	refcnts = kcalloc(nr_refcnts, sizeof(*refcnts), GFP_KERNEL);
 	if (!refcnts) {
 		ret = -ENOMEM;
-		goto err_free_csdev;
+		kfree(csdev);
+		goto err_out;
 	}
 
 	csdev->refcnt = refcnts;
@@ -1619,6 +1621,13 @@ struct coresight_device *coresight_regis
 	csdev->dev.fwnode = fwnode_handle_get(dev_fwnode(desc->dev));
 	dev_set_name(&csdev->dev, "%s", desc->name);
 
+	/*
+	 * Make sure the device registration and the connection fixup
+	 * are synchronised, so that we don't see uninitialised devices
+	 * on the coresight bus while trying to resolve the connections.
+	 */
+	mutex_lock(&coresight_mutex);
+
 	ret = device_register(&csdev->dev);
 	if (ret) {
 		put_device(&csdev->dev);
@@ -1626,7 +1635,7 @@ struct coresight_device *coresight_regis
 		 * All resources are free'd explicitly via
 		 * coresight_device_release(), triggered from put_device().
 		 */
-		goto err_out;
+		goto out_unlock;
 	}
 
 	if (csdev->type == CORESIGHT_DEV_TYPE_SINK ||
@@ -1641,11 +1650,11 @@ struct coresight_device *coresight_regis
 			 * from put_device(), which is in turn called from
 			 * function device_unregister().
 			 */
-			goto err_out;
+			goto out_unlock;
 		}
 	}
-
-	mutex_lock(&coresight_mutex);
+	/* Device is now registered */
+	registered = true;
 
 	ret = coresight_create_conns_sysfs_group(csdev);
 	if (!ret)
@@ -1655,16 +1664,18 @@ struct coresight_device *coresight_regis
 	if (!ret && cti_assoc_ops && cti_assoc_ops->add)
 		cti_assoc_ops->add(csdev);
 
+out_unlock:
 	mutex_unlock(&coresight_mutex);
-	if (ret) {
+	/* Success */
+	if (!ret)
+		return csdev;
+
+	/* Unregister the device if needed */
+	if (registered) {
 		coresight_unregister(csdev);
 		return ERR_PTR(ret);
 	}
 
-	return csdev;
-
-err_free_csdev:
-	kfree(csdev);
 err_out:
 	/* Cleanup the connection information */
 	coresight_release_platform_data(NULL, desc->pdata);


