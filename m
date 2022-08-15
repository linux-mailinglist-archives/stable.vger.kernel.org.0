Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4674E593B9D
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240358AbiHOT5j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346018AbiHOT4z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:56:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1455A78209;
        Mon, 15 Aug 2022 11:52:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60D82B8105D;
        Mon, 15 Aug 2022 18:52:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B2F0C433D6;
        Mon, 15 Aug 2022 18:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589566;
        bh=unY1VYk0+hldZ4DhLs3vctXkk1Ytvke2vPTh8XgIwj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xbqIpywIczTc66V9ID0gkd/cxkwXelvbEcovPO18gKOu9QpmWI5EnlcqbaMPAUVNA
         rkfJ+5zxj1XzRZ9Y5jewOSG6TSErIZobyeYTuoCocw6Ih17TEN+9sKY5wk8O4e4Kox
         1zSRqtKeY+og1/GtJWPf53fLJy4gqpUkZ5xpUjlg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andrii Chepurnyi <andrii.chepurnyi82@gmail.com>,
        Maximilian Heyne <mheyne@amazon.de>,
        SeongJae Park <sj@kernel.org>, Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.15 757/779] xen-blkback: Apply feature_persistent parameter when connect
Date:   Mon, 15 Aug 2022 20:06:41 +0200
Message-Id: <20220815180409.816622620@linuxfoundation.org>
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

From: Maximilian Heyne <mheyne@amazon.de>

commit e94c6101e151b019b8babc518ac2a6ada644a5a1 upstream.

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
Reviewed-by: Maximilian Heyne <mheyne@amazon.de>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/20220715225108.193398-3-sj@kernel.org
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/ABI/testing/sysfs-driver-xen-blkback |    2 +-
 drivers/block/xen-blkback/xenbus.c                 |    9 +++------
 2 files changed, 4 insertions(+), 7 deletions(-)

--- a/Documentation/ABI/testing/sysfs-driver-xen-blkback
+++ b/Documentation/ABI/testing/sysfs-driver-xen-blkback
@@ -42,5 +42,5 @@ KernelVersion:  5.10
 Contact:        SeongJae Park <sjpark@amazon.de>
 Description:
                 Whether to enable the persistent grants feature or not.  Note
-                that this option only takes effect on newly created backends.
+                that this option only takes effect on newly connected backends.
                 The default is Y (enable).
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -185,8 +185,6 @@ static struct xen_blkif *xen_blkif_alloc
 	__module_get(THIS_MODULE);
 	INIT_WORK(&blkif->free_work, xen_blkif_deferred_free);
 
-	blkif->vbd.feature_gnt_persistent = feature_persistent;
-
 	return blkif;
 }
 
@@ -1089,10 +1087,9 @@ static int connect_ring(struct backend_i
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
 


