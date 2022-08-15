Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CFF5593C7B
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240866AbiHOT5h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345975AbiHOT4r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:56:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 719D57697E;
        Mon, 15 Aug 2022 11:52:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D89C7B810A1;
        Mon, 15 Aug 2022 18:52:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD67C433C1;
        Mon, 15 Aug 2022 18:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589559;
        bh=J49d4DEptKMWjWx4b8cin41uCtkezrgo6ZY79QE+qhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XVge0nTwV7rBPzYflRo9xPNfPMtZpNoeAwUIw/+NuLk71VBO8froQTopdyRJvhUW5
         GhiaUoh1bCLsXjMHGwh0Okr1L3vz/lnHuTjV9YrQP/p4ZC9NzL0bIUn3r8VsYb6xmk
         p2lWNURIThBWr4SibMgStP9qKSzptlRCCA4LRBx8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maximilian Heyne <mheyne@amazon.de>,
        SeongJae Park <sj@kernel.org>, Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.15 756/779] xen-blkback: fix persistent grants negotiation
Date:   Mon, 15 Aug 2022 20:06:40 +0200
Message-Id: <20220815180409.784025415@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: SeongJae Park <sj@kernel.org>

commit fc9be616bb8f3ed9cf560308f86904f5c06be205 upstream.

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
Reviewed-by: Maximilian Heyne <mheyne@amazon.de>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/20220715225108.193398-2-sj@kernel.org
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/xen-blkback/xenbus.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -156,6 +156,11 @@ static int xen_blkif_alloc_rings(struct
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
@@ -180,6 +185,8 @@ static struct xen_blkif *xen_blkif_alloc
 	__module_get(THIS_MODULE);
 	INIT_WORK(&blkif->free_work, xen_blkif_deferred_free);
 
+	blkif->vbd.feature_gnt_persistent = feature_persistent;
+
 	return blkif;
 }
 
@@ -471,12 +478,6 @@ static void xen_vbd_free(struct xen_vbd
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
@@ -522,8 +523,6 @@ static int xen_vbd_create(struct xen_blk
 	if (q && blk_queue_secure_erase(q))
 		vbd->discard_secure = true;
 
-	vbd->feature_gnt_persistent = feature_persistent;
-
 	pr_debug("Successful creation of handle=%04x (dom=%u)\n",
 		handle, blkif->domid);
 	return 0;


