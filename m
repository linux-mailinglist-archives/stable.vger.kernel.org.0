Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADC4F5A83E8
	for <lists+stable@lfdr.de>; Wed, 31 Aug 2022 19:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232419AbiHaQ77 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Aug 2022 12:59:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232282AbiHaQ7k (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Aug 2022 12:59:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F408DDA99;
        Wed, 31 Aug 2022 09:58:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE3A2B8220D;
        Wed, 31 Aug 2022 16:58:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A36C433B5;
        Wed, 31 Aug 2022 16:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661965116;
        bh=VwhcFoR15fxSac+d9djkuB0nYm46oJiHPCPL6ttzYrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VJsN+GwLzB1o/aocdkfe9uukB4vLCbbUgu8WeVfHMhA7ledCcsrJzIw/RKG0Q8c0r
         p2enaJwAn3AKNgdzMextUO/knmPPDWMEIdOz/47v1GGtj8mW67V8pSLsf4HCp11IpS
         1koV2MmWi4Cmy1oJqviP21B9cN4J0f+zf60DlBP7loUnYI7JtJ6oiHtz23LW7wUMm9
         1hTMReYwfvChFniNUnD1/0kNLo8g4KcO1aK1cwOKIA6I/mgWaIQufr0AcrX2YJEjOV
         f7Khyyto6R2BwBEN7MtOok8iaHn25/XoLtpbA/73fpxcbjNwMpgJmlgDzX35+veJiW
         9uBUVRlhFuAkg==
From:   SeongJae Park <sj@kernel.org>
To:     jgross@suse.com, roger.pau@citrix.com
Cc:     SeongJae Park <sj@kernel.org>, marmarek@invisiblethingslab.com,
        mheyne@amazon.de, xen-devel@lists.xenproject.org, axboe@kernel.dk,
        ptyadav@amazon.de, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v2 3/3] xen-blkfront: Cache feature_persistent value before advertisement
Date:   Wed, 31 Aug 2022 16:58:24 +0000
Message-Id: <20220831165824.94815-4-sj@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220831165824.94815-1-sj@kernel.org>
References: <20220831165824.94815-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Xen blkfront advertises its support of the persistent grants feature
when it first setting up and when resuming in 'talk_to_blkback()'.
Then, blkback reads the advertised value when it connects with blkfront
and decides if it will use the persistent grants feature or not, and
advertises its decision to blkfront.  Blkfront reads the blkback's
decision and it also makes the decision for the use of the feature.

Commit 402c43ea6b34 ("xen-blkfront: Apply 'feature_persistent' parameter
when connect"), however, made the blkfront's read of the parameter for
disabling the advertisement, namely 'feature_persistent', to be done
when it negotiate, not when advertise.  Therefore blkfront advertises
without reading the parameter.  As the field for caching the parameter
value is zero-initialized, it always advertises as the feature is
disabled, so that the persistent grants feature becomes always disabled.

This commit fixes the issue by making the blkfront does parmeter caching
just before the advertisement.

Fixes: 402c43ea6b34 ("xen-blkfront: Apply 'feature_persistent' parameter when connect")
Cc: <stable@vger.kernel.org> # 5.10.x
Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 drivers/block/xen-blkfront.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index dfae08115450..35b9bcad9db9 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1759,6 +1759,12 @@ static int write_per_ring_nodes(struct xenbus_transaction xbt,
 	return err;
 }
 
+/* Enable the persistent grants feature. */
+static bool feature_persistent = true;
+module_param(feature_persistent, bool, 0644);
+MODULE_PARM_DESC(feature_persistent,
+		"Enables the persistent grants feature");
+
 /* Common code used when first setting up, and when resuming. */
 static int talk_to_blkback(struct xenbus_device *dev,
 			   struct blkfront_info *info)
@@ -1850,6 +1856,7 @@ static int talk_to_blkback(struct xenbus_device *dev,
 		message = "writing protocol";
 		goto abort_transaction;
 	}
+	info->feature_persistent_parm = feature_persistent;
 	err = xenbus_printf(xbt, dev->nodename, "feature-persistent", "%u",
 			info->feature_persistent_parm);
 	if (err)
@@ -1919,12 +1926,6 @@ static int negotiate_mq(struct blkfront_info *info)
 	return 0;
 }
 
-/* Enable the persistent grants feature. */
-static bool feature_persistent = true;
-module_param(feature_persistent, bool, 0644);
-MODULE_PARM_DESC(feature_persistent,
-		"Enables the persistent grants feature");
-
 /*
  * Entry point to this code when a new device is created.  Allocate the basic
  * structures and the ring buffer for communication with the backend, and
@@ -2284,7 +2285,6 @@ static void blkfront_gather_backend_features(struct blkfront_info *info)
 	if (xenbus_read_unsigned(info->xbdev->otherend, "feature-discard", 0))
 		blkfront_setup_discard(info);
 
-	info->feature_persistent_parm = feature_persistent;
 	if (info->feature_persistent_parm)
 		info->feature_persistent =
 			!!xenbus_read_unsigned(info->xbdev->otherend,
-- 
2.25.1

