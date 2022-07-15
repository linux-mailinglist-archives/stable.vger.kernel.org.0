Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4700C576676
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 19:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbiGOR4B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 13:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiGORz7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 13:55:59 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 017EC357D9;
        Fri, 15 Jul 2022 10:55:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 72401CE312A;
        Fri, 15 Jul 2022 17:55:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E73DBC341C6;
        Fri, 15 Jul 2022 17:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657907754;
        bh=glq1x5HjisMX5ci0YsvyB4Ygu//43duXbX0NbnuWshE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hwiOW9YiIbTCMdE0Tf/wDkTu2UsIH14atZA/yHy8G06FnwGKtOvtYIp7JmSM860P4
         m+G2KTFISLmBB0n/oEn8K3iH1lIn6aH1fWMLr7ww7PITjexJM6W7ZiuqU1DabSZBq6
         ZkcjxYbTGCjxLiP6g/cFeKH/FkCdsABIN2KAKfZMBEOIvPbq2P2UCQEPLEtUiPMz9J
         bLjFGcCRLmlNFaclKw6IP4+80g51MAYkepMQwlXy4XO8/e3VSueMCLT0xHfCpQw5WP
         8V1Pa5gDFUAvwHJgrms8TjifJPJ4u8v1dljABKadLQRH9bMyMnHIve039sDnxUTegP
         cIcw+eyH/Bk9A==
From:   SeongJae Park <sj@kernel.org>
To:     roger.pau@citrix.com
Cc:     axboe@kernel.dk, boris.ostrovsky@oracle.com, jgross@suse.com,
        olekstysh@gmail.com, andrii.chepurnyi82@gmail.com,
        mheyne@amazon.de, xen-devel@lists.xenproject.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, SeongJae Park <sj@kernel.org>
Subject: [PATCH 2/2] xen-blkfront: Apply 'feature_persistent' parameter when connect
Date:   Fri, 15 Jul 2022 17:55:21 +0000
Message-Id: <20220715175521.126649-3-sj@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220715175521.126649-1-sj@kernel.org>
References: <20220715175521.126649-1-sj@kernel.org>
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

Previous commit made xen-blkback's 'feature_persistent' parameter to
make effect for not only newly created backends but also for every
reconnected backends.  This commit makes xen-blkfront's counterpart
parameter to works in same manner and update the document to avoid any
confusion due to inconsistent behavior of same-named parameters.

Cc: <stable@vger.kernel.org> # 5.10.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-driver-xen-blkfront | 2 +-
 drivers/block/xen-blkfront.c                        | 4 +---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-xen-blkfront b/Documentation/ABI/testing/sysfs-driver-xen-blkfront
index 7f646c58832e..4d36c5a10546 100644
--- a/Documentation/ABI/testing/sysfs-driver-xen-blkfront
+++ b/Documentation/ABI/testing/sysfs-driver-xen-blkfront
@@ -15,5 +15,5 @@ KernelVersion:  5.10
 Contact:        Maximilian Heyne <mheyne@amazon.de>
 Description:
                 Whether to enable the persistent grants feature or not.  Note
-                that this option only takes effect on newly created frontends.
+                that this option only takes effect on newly connected frontends.
                 The default is Y (enable).
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 3646c0cae672..4e763701b372 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1988,8 +1988,6 @@ static int blkfront_probe(struct xenbus_device *dev,
 	info->vdevice = vdevice;
 	info->connected = BLKIF_STATE_DISCONNECTED;
 
-	info->feature_persistent = feature_persistent;
-
 	/* Front end dir is a number, which is used as the id. */
 	info->handle = simple_strtoul(strrchr(dev->nodename, '/')+1, NULL, 0);
 	dev_set_drvdata(&dev->dev, info);
@@ -2283,7 +2281,7 @@ static void blkfront_gather_backend_features(struct blkfront_info *info)
 	if (xenbus_read_unsigned(info->xbdev->otherend, "feature-discard", 0))
 		blkfront_setup_discard(info);
 
-	if (info->feature_persistent)
+	if (feature_persistent)
 		info->feature_persistent =
 			!!xenbus_read_unsigned(info->xbdev->otherend,
 					       "feature-persistent", 0);
-- 
2.25.1

