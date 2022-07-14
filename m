Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF1E55757CA
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 00:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240653AbiGNWoT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 18:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiGNWoS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 18:44:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8CAC66AF6;
        Thu, 14 Jul 2022 15:44:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E333B829DF;
        Thu, 14 Jul 2022 22:44:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDE5DC34114;
        Thu, 14 Jul 2022 22:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657838654;
        bh=ZTNaD7TTclpn13DZH9gmDu/kVHAK0vU6nq05MFNP/OI=;
        h=From:To:Cc:Subject:Date:From;
        b=OeQS1awqXop0peSKh0A2dyghSIgn/D6oI+ww24QPmvMecatn8NjCA7FnNbTxEA1a/
         jFfq/8eoAnF4reSH3Zx5kRBPZtq+YrIOM8HKBzJObtP2Ce3WAxlCRQiGY63uEN5Hen
         DXyg1enx4YljQAw7SN2WDuLqa7+SvA0Tirs62KT5LpVuYOAhBNesaRbael/3jB9R3e
         Ipu0Z9Ok3f1qtPoAtUizrTvfyKyZgfT1XWtlp8dlj7SLkFReNxP74nx3isQPvw2C6h
         h0ATw8BT5o2FV9ZpvVEjQMzburXRmJx+x+EICrJ/Hog1ZVlmG8L60Q+0d9vLU8VYyC
         PbhWXmyYeRo0w==
From:   SeongJae Park <sj@kernel.org>
To:     roger.pau@citrix.com
Cc:     axboe@kernel.dk, boris.ostrovsky@oracle.com, jgross@suse.com,
        mheyne@amazon.de, xen-devel@lists.xenproject.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        SeongJae Park <sj@kernel.org>, stable@vger.kernel.org
Subject: [PATCH v2] xen-blkback: fix persistent grants negotiation
Date:   Thu, 14 Jul 2022 22:44:10 +0000
Message-Id: <20220714224410.51147-1-sj@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Persistent grants feature can be used only when both backend and the
frontend supports the feature.  The feature was always supported by
'blkback', but commit aac8a70db24b ("xen-blkback: add a parameter for
disabling of persistent grants") has introduced a parameter for
disabling it runtime.

To avoid the parameter be updated while being used by 'blkback', the
commit caches the parameter into 'vbd->feature_gnt_persistent' in
'xen_vbd_create()', and then check if the guest also supports the
feature and finally updates the field in 'connect_ring()'.

However, 'connect_ring()' could be called before 'xen_vbd_create()', so
later execution of 'xen_vbd_create()' can wrongly overwrite 'true' to
'vbd->feature_gnt_persistent'.  As a result, 'blkback' could try to use
'persistent grants' feature even if the guest doesn't support the
feature.

This commit fixes the issue by moving the parameter value caching to
'xen_blkif_alloc()', which allocates the 'blkif'.  Because the struct
embeds 'vbd' object, which will be used by 'connect_ring()' later, this
should be called before 'connect_ring()' and therefore this should be
the right and safe place to do the caching.

Fixes: aac8a70db24b ("xen-blkback: add a parameter for disabling of persistent grants")
Cc: <stable@vger.kernel.org> # 5.10.x
Signed-off-by: Maximilian Heyne <mheyne@amazon.de>
Signed-off-by: SeongJae Park <sj@kernel.org>
---

Changes from v1[1]
- Avoid the behavioral change[2]
- Rebase on latest xen/tip/linux-next
- Re-work by SeongJae Park <sj@kernel.org>
- Cc stable@

[1] https://lore.kernel.org/xen-devel/20220106091013.126076-1-mheyne@amazon.de/
[2] https://lore.kernel.org/xen-devel/20220121102309.27802-1-sj@kernel.org/

 drivers/block/xen-blkback/xenbus.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index 97de13b14175..16c6785d260c 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -157,6 +157,11 @@ static int xen_blkif_alloc_rings(struct xen_blkif *blkif)
 	return 0;
 }
 
+/* Enable the persistent grants feature. */
+static bool feature_persistent = true;
+module_param(feature_persistent, bool, 0644);
+MODULE_PARM_DESC(feature_persistent, "Enables the persistent grants feature");
+
 static struct xen_blkif *xen_blkif_alloc(domid_t domid)
 {
 	struct xen_blkif *blkif;
@@ -181,6 +186,8 @@ static struct xen_blkif *xen_blkif_alloc(domid_t domid)
 	__module_get(THIS_MODULE);
 	INIT_WORK(&blkif->free_work, xen_blkif_deferred_free);
 
+	blkif->vbd.feature_gnt_persistent = feature_persistent;
+
 	return blkif;
 }
 
@@ -472,12 +479,6 @@ static void xen_vbd_free(struct xen_vbd *vbd)
 	vbd->bdev = NULL;
 }
 
-/* Enable the persistent grants feature. */
-static bool feature_persistent = true;
-module_param(feature_persistent, bool, 0644);
-MODULE_PARM_DESC(feature_persistent,
-		"Enables the persistent grants feature");
-
 static int xen_vbd_create(struct xen_blkif *blkif, blkif_vdev_t handle,
 			  unsigned major, unsigned minor, int readonly,
 			  int cdrom)
@@ -520,8 +521,6 @@ static int xen_vbd_create(struct xen_blkif *blkif, blkif_vdev_t handle,
 	if (bdev_max_secure_erase_sectors(bdev))
 		vbd->discard_secure = true;
 
-	vbd->feature_gnt_persistent = feature_persistent;
-
 	pr_debug("Successful creation of handle=%04x (dom=%u)\n",
 		handle, blkif->domid);
 	return 0;
-- 
2.25.1

