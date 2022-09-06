Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1B2B5AEB0F
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239578AbiIFNzk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:55:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239573AbiIFNyA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:54:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C98118052D;
        Tue,  6 Sep 2022 06:40:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4F9F6154A;
        Tue,  6 Sep 2022 13:40:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04CA7C433D6;
        Tue,  6 Sep 2022 13:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471642;
        bh=YbXUbVwmPBeZ3e18p5I/sCwBu3AG/FCQQge9vtCE1jc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FsIRGVDhuoVhm38S8ZTA2pnVd39PUbEvnMr4jWQd2UEgNFpR3Sn4s1oZKP3bVX8Cp
         WE+5D/ux8XR5ccIls0YNQq5dCcRzY/aD+iTZXSk9NEQUZiq+rQdSinQZW9E/UsZF2a
         6kVtoNPNnl9SOZhug2lO8lIl+yIqybxuCqP4o/eg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>, SeongJae Park <sj@kernel.org>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.15 066/107] xen-blkfront: Cache feature_persistent value before advertisement
Date:   Tue,  6 Sep 2022 15:30:47 +0200
Message-Id: <20220906132824.618387010@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132821.713989422@linuxfoundation.org>
References: <20220906132821.713989422@linuxfoundation.org>
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

commit fe8f65b018effbf473f53af3538d0c1878b8b329 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/xen-blkfront.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1785,6 +1785,12 @@ abort_transaction:
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
@@ -1876,6 +1882,7 @@ again:
 		message = "writing protocol";
 		goto abort_transaction;
 	}
+	info->feature_persistent_parm = feature_persistent;
 	err = xenbus_printf(xbt, dev->nodename, "feature-persistent", "%u",
 			info->feature_persistent_parm);
 	if (err)
@@ -1945,12 +1952,6 @@ static int negotiate_mq(struct blkfront_
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
@@ -2310,7 +2311,6 @@ static void blkfront_gather_backend_feat
 	if (xenbus_read_unsigned(info->xbdev->otherend, "feature-discard", 0))
 		blkfront_setup_discard(info);
 
-	info->feature_persistent_parm = feature_persistent;
 	if (info->feature_persistent_parm)
 		info->feature_persistent =
 			!!xenbus_read_unsigned(info->xbdev->otherend,


