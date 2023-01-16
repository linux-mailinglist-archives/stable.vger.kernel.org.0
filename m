Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AABD66C9E8
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234092AbjAPQ5g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:57:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234056AbjAPQ5N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:57:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A23675864B
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:40:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31DB761077
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:40:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 408BEC43392;
        Mon, 16 Jan 2023 16:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887207;
        bh=QTEi+Pw2XkePJRE0UeZwcANlx5BDbR68sNlpZtWj9zM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OT86OUk0AhI0fNEMX2eI0hOox0oc17JRZp5xfnAJU7ZKwCa1bokIG42fwL69syDsj
         sxpeLS8JNZrM19JsTBDGvvfulpH8fOafNgYHzg6bhcp1gQAz9McWa1S0yQzjhmHeiD
         oCfYnupgaL+1pqAFhlt8S/SYwD51c4USfSb/VRQs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Alexandre Bounine <alex.bou9@gmail.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 061/521] rapidio: fix possible name leaks when rio_add_device() fails
Date:   Mon, 16 Jan 2023 16:45:23 +0100
Message-Id: <20230116154849.957434600@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit f9574cd48679926e2a569e1957a5a1bcc8a719ac ]

Patch series "rapidio: fix three possible memory leaks".

This patchset fixes three name leaks in error handling.
 - patch #1 fixes two name leaks while rio_add_device() fails.
 - patch #2 fixes a name leak while  rio_register_mport() fails.

This patch (of 2):

If rio_add_device() returns error, the name allocated by dev_set_name()
need be freed.  It should use put_device() to give up the reference in the
error path, so that the name can be freed in kobject_cleanup(), and the
'rdev' can be freed in rio_release_dev().

Link: https://lkml.kernel.org/r/20221114152636.2939035-1-yangyingliang@huawei.com
Link: https://lkml.kernel.org/r/20221114152636.2939035-2-yangyingliang@huawei.com
Fixes: e8de370188d0 ("rapidio: add mport char device driver")
Fixes: 1fa5ae857bb1 ("driver core: get rid of struct device's bus_id string array")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rapidio/devices/rio_mport_cdev.c | 7 +++++--
 drivers/rapidio/rio-scan.c               | 8 ++++++--
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/rapidio/devices/rio_mport_cdev.c b/drivers/rapidio/devices/rio_mport_cdev.c
index a136a7ae7714..01eb1a594ce6 100644
--- a/drivers/rapidio/devices/rio_mport_cdev.c
+++ b/drivers/rapidio/devices/rio_mport_cdev.c
@@ -1809,8 +1809,11 @@ static int rio_mport_add_riodev(struct mport_cdev_priv *priv,
 		rio_init_dbell_res(&rdev->riores[RIO_DOORBELL_RESOURCE],
 				   0, 0xffff);
 	err = rio_add_device(rdev);
-	if (err)
-		goto cleanup;
+	if (err) {
+		put_device(&rdev->dev);
+		return err;
+	}
+
 	rio_dev_get(rdev);
 
 	return 0;
diff --git a/drivers/rapidio/rio-scan.c b/drivers/rapidio/rio-scan.c
index fd7b517132ac..d2ddc173c5bd 100644
--- a/drivers/rapidio/rio-scan.c
+++ b/drivers/rapidio/rio-scan.c
@@ -460,8 +460,12 @@ static struct rio_dev *rio_setup_device(struct rio_net *net,
 				   0, 0xffff);
 
 	ret = rio_add_device(rdev);
-	if (ret)
-		goto cleanup;
+	if (ret) {
+		if (rswitch)
+			kfree(rswitch->route_table);
+		put_device(&rdev->dev);
+		return NULL;
+	}
 
 	rio_dev_get(rdev);
 
-- 
2.35.1



