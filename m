Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD92D6AE947
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbjCGRWn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:22:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbjCGRWR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:22:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E5E09CFC7
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:17:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BDD2E614FF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:17:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEBFBC433D2;
        Tue,  7 Mar 2023 17:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209454;
        bh=HOtCvFV7QgJB3l2Msh75P/ypyYVYmrVsSWPi3kBb8gY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=06dFiViI9eLpKB6O+3tCuHIVSp3bmnUQyLuu0+RFCod7Z8rubwHpxCn/ZKv07PzFO
         xH6AbRontQ4DSGn3XlIuQzVp4NXIwUGtPpKbKp3toLEBNZQ56slV58THjzVibM3yVd
         6jnKkd+EHy0M/I8zDCmEPqzaFG17+h3/qZlRzUZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0194/1001] s390/vfio-ap: fix an error handling path in vfio_ap_mdev_probe_queue()
Date:   Tue,  7 Mar 2023 17:49:26 +0100
Message-Id: <20230307170030.319488534@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 08866d34c7099e981918d34aab5d6a437436628f ]

The commit in Fixes: has switch the order of a sysfs_create_group() and a
kzalloc().

It correctly removed the now useless kfree() but forgot to add a
sysfs_remove_group() in case of (unlikely) memory allocation failure.

Add it now.

Fixes: 260f3ea14138 ("s390/vfio-ap: move probe and remove callbacks to vfio_ap_ops.c")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Link: https://lore.kernel.org/r/d0c0a35eec4fa87cb7f3910d8ac4dc0f7dc9008a.1659283738.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/vfio_ap_ops.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 9c01957e56b3f..b0b25bc95985b 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1857,8 +1857,10 @@ int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
 		return ret;
 
 	q = kzalloc(sizeof(*q), GFP_KERNEL);
-	if (!q)
-		return -ENOMEM;
+	if (!q) {
+		ret = -ENOMEM;
+		goto err_remove_group;
+	}
 
 	q->apqn = to_ap_queue(&apdev->device)->qid;
 	q->saved_isc = VFIO_AP_ISC_INVALID;
@@ -1876,6 +1878,10 @@ int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
 	release_update_locks_for_mdev(matrix_mdev);
 
 	return 0;
+
+err_remove_group:
+	sysfs_remove_group(&apdev->device.kobj, &vfio_queue_attr_group);
+	return ret;
 }
 
 void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
-- 
2.39.2



