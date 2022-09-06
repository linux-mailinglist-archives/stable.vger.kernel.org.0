Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A33CD5AE4F8
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 12:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233235AbiIFKCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 06:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239468AbiIFKBm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 06:01:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F32371BFA
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 03:01:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A30061486
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 10:01:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37F51C433C1;
        Tue,  6 Sep 2022 10:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662458488;
        bh=fla6j7Q+9ytxx7l/cJZdZSvHFfd5NAlwscg5tOFIk2Q=;
        h=Subject:To:Cc:From:Date:From;
        b=RFQ0AWhZcwoUl3HXGQKSWsxbX8kNIXCfIj4VQFEtQAhhk8bWYvh8tlBKP66nk8put
         PuJ9w82Z0TiAjwybIgyrZ5L1XP4e2G8JhI3DQbqHokaiAhh5NFww7wZEJtbE68uxXm
         N4X5b9QzN2qETd1Tkfo51XpOZhlBROKr/sbRu9E0=
Subject: FAILED: patch "[PATCH] xen-blkfront: Cache feature_persistent value before" failed to apply to 5.10-stable tree
To:     sj@kernel.org, jgross@suse.com, marmarek@invisiblethingslab.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 06 Sep 2022 12:01:25 +0200
Message-ID: <166245848519156@kroah.com>
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From fe8f65b018effbf473f53af3538d0c1878b8b329 Mon Sep 17 00:00:00 2001
From: SeongJae Park <sj@kernel.org>
Date: Wed, 31 Aug 2022 16:58:24 +0000
Subject: [PATCH] xen-blkfront: Cache feature_persistent value before
 advertisement
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
Tested-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/20220831165824.94815-4-sj@kernel.org
Signed-off-by: Juergen Gross <jgross@suse.com>

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 276b2ee2a155..1f85750f981e 100644
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

