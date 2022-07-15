Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03161576A2D
	for <lists+stable@lfdr.de>; Sat, 16 Jul 2022 00:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbiGOWvY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 18:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbiGOWvX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 18:51:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B50E43326;
        Fri, 15 Jul 2022 15:51:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03DEAB82EF0;
        Fri, 15 Jul 2022 22:51:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B07D5C341CA;
        Fri, 15 Jul 2022 22:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657925479;
        bh=mrIb/ElueXH2WPoRY6/+AIbMzXNHxy0Ea9Il6Cse/O8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tZxT+pQbuYr4srnjPLlT74GcfOoy9RBpxXwayjAkFgyh5LrNUY2q22OQHx045z57h
         JdL3SjIYgm+lnKlOTPxlxhxTXrDItgz5B7Iq0KW9mCCuECOsfsPxQLvCGEY2TAaylX
         2k3Ob5C7883feGULACavffuwP/y6NAcpUwh1zqITBCaRejmAzNJdScnUecrJbb03C1
         56w9YccBqDpPCC3y+dRiauLqFDY13lTcAFOM9J+bJQugs6+dxc7q/fhpTvxXAmKs6/
         UFobBSH5woSg6vsIMZc1Ne6tlWWStPO2MzvrYtDH9IlB94a1Y1CeYMd2QJpBnzdiOD
         V5dPouOxOxBTA==
From:   SeongJae Park <sj@kernel.org>
To:     roger.pau@citrix.com
Cc:     axboe@kernel.dk, boris.ostrovsky@oracle.com, jgross@suse.com,
        olekstysh@gmail.com, andrii.chepurnyi82@gmail.com,
        mheyne@amazon.de, xen-devel@lists.xenproject.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, SeongJae Park <sj@kernel.org>
Subject: [PATCH v4 2/3] xen-blkback: Apply 'feature_persistent' parameter when connect
Date:   Fri, 15 Jul 2022 22:51:07 +0000
Message-Id: <20220715225108.193398-3-sj@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220715225108.193398-1-sj@kernel.org>
References: <20220715225108.193398-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maximilian Heyne <mheyne@amazon.de>

In some use cases[1], the backend is created while the frontend doesn't
support the persistent grants feature, but later the frontend can be
changed to support the feature and reconnect.  In the past, 'blkback'
enabled the persistent grants feature since it unconditionally checked
if frontend supports the persistent grants feature for every connect
('connect_ring()') and decided whether it should use persistent grans or
not.

However, commit aac8a70db24b ("xen-blkback: add a parameter for
disabling of persistent grants") has mistakenly changed the behavior.
It made the frontend feature support check to not be repeated once it
shown the 'feature_persistent' as 'false', or the frontend doesn't
support persistent grants.

This commit changes the behavior of the parameter to make effect for
every connect, so that the previous workflow can work again as expected.

[1] https://lore.kernel.org/xen-devel/CAJwUmVB6H3iTs-C+U=v-pwJB7-_ZRHPxHzKRJZ22xEPW7z8a=g@mail.gmail.com/

Reported-by: Andrii Chepurnyi <andrii.chepurnyi82@gmail.com>
Fixes: aac8a70db24b ("xen-blkback: add a parameter for disabling of persistent grants")
Cc: <stable@vger.kernel.org> # 5.10.x
Signed-off-by: Maximilian Heyne <mheyne@amazon.de>
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-driver-xen-blkback | 2 +-
 drivers/block/xen-blkback/xenbus.c                 | 9 +++------
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-xen-blkback b/Documentation/ABI/testing/sysfs-driver-xen-blkback
index 7faf719af165..fac0f429a869 100644
--- a/Documentation/ABI/testing/sysfs-driver-xen-blkback
+++ b/Documentation/ABI/testing/sysfs-driver-xen-blkback
@@ -42,5 +42,5 @@ KernelVersion:  5.10
 Contact:        Maximilian Heyne <mheyne@amazon.de>
 Description:
                 Whether to enable the persistent grants feature or not.  Note
-                that this option only takes effect on newly created backends.
+                that this option only takes effect on newly connected backends.
                 The default is Y (enable).
diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index 16c6785d260c..ee7ad2fb432d 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -186,8 +186,6 @@ static struct xen_blkif *xen_blkif_alloc(domid_t domid)
 	__module_get(THIS_MODULE);
 	INIT_WORK(&blkif->free_work, xen_blkif_deferred_free);
 
-	blkif->vbd.feature_gnt_persistent = feature_persistent;
-
 	return blkif;
 }
 
@@ -1086,10 +1084,9 @@ static int connect_ring(struct backend_info *be)
 		xenbus_dev_fatal(dev, err, "unknown fe protocol %s", protocol);
 		return -ENOSYS;
 	}
-	if (blkif->vbd.feature_gnt_persistent)
-		blkif->vbd.feature_gnt_persistent =
-			xenbus_read_unsigned(dev->otherend,
-					"feature-persistent", 0);
+
+	blkif->vbd.feature_gnt_persistent = feature_persistent &&
+		xenbus_read_unsigned(dev->otherend, "feature-persistent", 0);
 
 	blkif->vbd.overflow_max_grants = 0;
 
-- 
2.25.1

