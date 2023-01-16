Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2FC666CC8F
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234528AbjAPR1P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:27:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234760AbjAPR0k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:26:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E93943FF18
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:04:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 780CDB81014
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:04:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4940C433EF;
        Mon, 16 Jan 2023 17:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888640;
        bh=Cib16DsQQ0IUYfQ1kuaBXfwgwm6Le9uegRZ1RU3H2vU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PaE4RoN+W45lpXAQBo4jU83rRyJ7zZtAlWhOICjgr4SFogAlqqiiOapiFFgFL8AV/
         /op7Jnt6P9+2z+4ww1haqCPpp9WU7UPB03J4db/xpfOOhEA1TMwMgKuiKo70QNwHvh
         8VicAbC54hyDPdqreNzqg27V+mtaTbbVlRggxJvk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Alexandre Bounine <alex.bou9@gmail.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 054/338] rapidio: fix possible name leaks when rio_add_device() fails
Date:   Mon, 16 Jan 2023 16:48:47 +0100
Message-Id: <20230116154823.190469304@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
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
index a87c024d5670..ce12b5c25b8c 100644
--- a/drivers/rapidio/devices/rio_mport_cdev.c
+++ b/drivers/rapidio/devices/rio_mport_cdev.c
@@ -1863,8 +1863,11 @@ static int rio_mport_add_riodev(struct mport_cdev_priv *priv,
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
index 23429bdaca84..26ab8c463dae 100644
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



