Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49BF85A83EA
	for <lists+stable@lfdr.de>; Wed, 31 Aug 2022 19:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232416AbiHaQ75 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Aug 2022 12:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232304AbiHaQ7k (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Aug 2022 12:59:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16D7EDC09B;
        Wed, 31 Aug 2022 09:58:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34F91B82208;
        Wed, 31 Aug 2022 16:58:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16ED3C433D6;
        Wed, 31 Aug 2022 16:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661965114;
        bh=dAXL0+XNvWx5LNwHQHyifRYahh/pbyejlx7Mrbu9GZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Unrckl/0xd5p4L0eslkX+ocOVnSTxmyJWLFH/U+QruZmKX8gJdrduY6/CKskFoEWd
         ISKZ9pHw2Q/FycQa5vEi4tVNKULPLkBLgmNwT1C2W/w8DAo8qh4Cy3auUpwCxehnB0
         8LstTa/XU6ZZ0YxZbVsssX+To30Ks8YUt+o9BArCX6fGGv2Vvq65I2nUKzK116hIA+
         MI27LA9tMdpy0d7c5dmH++0KKz2eefkDA0N57lPA4Vl5L5nGk1wsuhlV1WbZKvd3X3
         fUptPXshdHkX8Fuoq+D9EglqVBVXgoAzpgDhaRHDEr+f2EjjxQZpAPWWYg3zQSbnjv
         0/GI1hfVVorcQ==
From:   SeongJae Park <sj@kernel.org>
To:     jgross@suse.com, roger.pau@citrix.com
Cc:     SeongJae Park <sj@kernel.org>, marmarek@invisiblethingslab.com,
        mheyne@amazon.de, xen-devel@lists.xenproject.org, axboe@kernel.dk,
        ptyadav@amazon.de, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v2 2/3] xen-blkfront: Advertise feature-persistent as user requested
Date:   Wed, 31 Aug 2022 16:58:23 +0000
Message-Id: <20220831165824.94815-3-sj@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220831165824.94815-1-sj@kernel.org>
References: <20220831165824.94815-1-sj@kernel.org>
MIME-Version: 1.0
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

The advertisement of the persistent grants feature (writing
'feature-persistent' to xenbus) should mean not the decision for using
the feature but only the availability of the feature.  However, commit
74a852479c68 ("xen-blkfront: add a parameter for disabling of persistent
grants") made a field of blkfront, which was a place for saving only the
negotiation result, to be used for yet another purpose: caching of the
'feature_persistent' parameter value.  As a result, the advertisement,
which should follow only the parameter value, becomes inconsistent.

This commit fixes the misuse of the semantic by making blkfront saves
the parameter value in a separate place and advertises the support based
on only the saved value.

Fixes: 74a852479c68 ("xen-blkfront: add a parameter for disabling of persistent grants")
Cc: <stable@vger.kernel.org> # 5.10.x
Suggested-by: Juergen Gross <jgross@suse.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 drivers/block/xen-blkfront.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 8e56e69fb4c4..dfae08115450 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -213,6 +213,9 @@ struct blkfront_info
 	unsigned int feature_fua:1;
 	unsigned int feature_discard:1;
 	unsigned int feature_secdiscard:1;
+	/* Connect-time cached feature_persistent parameter */
+	unsigned int feature_persistent_parm:1;
+	/* Persistent grants feature negotiation result */
 	unsigned int feature_persistent:1;
 	unsigned int bounce:1;
 	unsigned int discard_granularity;
@@ -1848,7 +1851,7 @@ static int talk_to_blkback(struct xenbus_device *dev,
 		goto abort_transaction;
 	}
 	err = xenbus_printf(xbt, dev->nodename, "feature-persistent", "%u",
-			info->feature_persistent);
+			info->feature_persistent_parm);
 	if (err)
 		dev_warn(&dev->dev,
 			 "writing persistent grants feature to xenbus");
@@ -2281,7 +2284,8 @@ static void blkfront_gather_backend_features(struct blkfront_info *info)
 	if (xenbus_read_unsigned(info->xbdev->otherend, "feature-discard", 0))
 		blkfront_setup_discard(info);
 
-	if (feature_persistent)
+	info->feature_persistent_parm = feature_persistent;
+	if (info->feature_persistent_parm)
 		info->feature_persistent =
 			!!xenbus_read_unsigned(info->xbdev->otherend,
 					       "feature-persistent", 0);
-- 
2.25.1

