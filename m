Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7835A167B
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 18:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242964AbiHYQPb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 12:15:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242959AbiHYQP3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 12:15:29 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 561E7192AF;
        Thu, 25 Aug 2022 09:15:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A5AD3CE27B1;
        Thu, 25 Aug 2022 16:15:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66BC6C433C1;
        Thu, 25 Aug 2022 16:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661444124;
        bh=MyefAg5QMtTe9G45OGJvSLHtJDZ6Nxt+B/36e/BGodU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cGocOxtCF6njlitkxhkDCLXDSTKPiSMqazH+G1pz6yicN6AahRiMXMtEEEItK9Qps
         uvEEG/uCqhiG/RwFdvrNko811/8cLvyGfmpy1ojf+3AXVPH2hpliJyoO7iOxClLoBk
         K6O74IL6AwOcRc0FvC+xt/E9jl47eJxh+RcCeLEIN8KpOoup7KuTLNbKlHQxgsQxb8
         iF3PzTnEfbM+yyKWhqi8QHd258xLUYf0ewS8f7eOBhaEzcd8fSr2AGMBvk/zP3HBWO
         JEJNoOAziB0la4PaewpTu4OZy6jMHBUl/q9GzmgZj9BbpKC8upnBJRDlyJHD/MOrLt
         5nNKZoV2FGXrQ==
From:   SeongJae Park <sj@kernel.org>
To:     jgross@suse.com, roger.pau@citrix.com
Cc:     marmarek@invisiblethingslab.com, mheyne@amazon.de,
        xen-devel@lists.xenproject.org, axboe@kernel.dk,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        SeongJae Park <sj@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 2/2] xen-blkfront: Advertise feature-persistent as user requested
Date:   Thu, 25 Aug 2022 16:15:11 +0000
Message-Id: <20220825161511.94922-3-sj@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220825161511.94922-1-sj@kernel.org>
References: <20220825161511.94922-1-sj@kernel.org>
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

Commit e94c6101e151 ("xen-blkback: Apply 'feature_persistent' parameter
when connect") made blkback to advertise its support of the persistent
grants feature only if the user sets the 'feature_persistent' parameter
of the driver and the frontend advertised its support of the feature.
However, following commit 402c43ea6b34 ("xen-blkfront: Apply
'feature_persistent' parameter when connect") made the blkfront to work
in the same way.  That is, blkfront also advertises its support of the
persistent grants feature only if the user sets the 'feature_persistent'
parameter of the driver and the backend advertised its support of the
feature.

Hence blkback and blkfront will never advertise their support of the
feature but wait until the other advertises the support, even though
users set the 'feature_persistent' parameters of the drivers.  As a
result, the persistent grants feature is disabled always regardless of
the 'feature_persistent' values[1].

The problem comes from the misuse of the semantic of the advertisement
of the feature.  The advertisement of the feature should means only
availability of the feature not the decision for using the feature.
However, current behavior is working in the wrong way.

This commit fixes the issue by making the blkfront advertises its
support of the feature as user requested via 'feature_persistent'
parameter regardless of the otherend's support of the feature.

[1] https://lore.kernel.org/xen-devel/bd818aba-4857-bc07-dc8a-e9b2f8c5f7cd@suse.com/

Fixes: 402c43ea6b34 ("xen-blkfront: Apply 'feature_persistent' parameter when connect")
Cc: <stable@vger.kernel.org> # 5.10.x
Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
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

