Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFA05948AB
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240974AbiHOXmb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353901AbiHOXjV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:39:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB2F153D19;
        Mon, 15 Aug 2022 13:10:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 432C660DDC;
        Mon, 15 Aug 2022 20:10:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51A82C433D6;
        Mon, 15 Aug 2022 20:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594206;
        bh=nDA1+g2NaubviFa1DOmu3ipBe0bol/bx3Ni3Zx8vy+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UcfCvveoIHZRDZ6adTt/MnSEcNQFuoXb7CPGDzgKKE3IHgzSoq1Odmfp6vhjWF91M
         wb7uMLPGDacHRLblEkV5Mpx4igy46X3TWkOMdEnjRy4cTOfznKed6G2RqfNiPgnt9g
         8kmPH2SnbZr53+21WqC1lnae+mvCnZ55BebBAlQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, SeongJae Park <sj@kernel.org>,
        Maximilian Heyne <mheyne@amazon.de>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.18 1072/1095] xen-blkfront: Apply feature_persistent parameter when connect
Date:   Mon, 15 Aug 2022 20:07:51 +0200
Message-Id: <20220815180513.394355050@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

commit 402c43ea6b34a1b371ffeed9adf907402569eaf5 upstream.

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

Similar behavioral change has made on 'blkfront' by commit 74a852479c68
("xen-blkfront: add a parameter for disabling of persistent grants").
This commit changes the behavior of the parameter to make effect for
every connect, so that the previous behavior of 'blkfront' can be
restored.

[1] https://lore.kernel.org/xen-devel/CAJwUmVB6H3iTs-C+U=v-pwJB7-_ZRHPxHzKRJZ22xEPW7z8a=g@mail.gmail.com/

Fixes: 74a852479c68 ("xen-blkfront: add a parameter for disabling of persistent grants")
Cc: <stable@vger.kernel.org> # 5.10.x
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Maximilian Heyne <mheyne@amazon.de>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/20220715225108.193398-4-sj@kernel.org
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/ABI/testing/sysfs-driver-xen-blkfront |    2 +-
 drivers/block/xen-blkfront.c                        |    4 +---
 2 files changed, 2 insertions(+), 4 deletions(-)

--- a/Documentation/ABI/testing/sysfs-driver-xen-blkfront
+++ b/Documentation/ABI/testing/sysfs-driver-xen-blkfront
@@ -15,5 +15,5 @@ KernelVersion:  5.10
 Contact:        SeongJae Park <sj@kernel.org>
 Description:
                 Whether to enable the persistent grants feature or not.  Note
-                that this option only takes effect on newly created frontends.
+                that this option only takes effect on newly connected frontends.
                 The default is Y (enable).
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -2011,8 +2011,6 @@ static int blkfront_probe(struct xenbus_
 	info->vdevice = vdevice;
 	info->connected = BLKIF_STATE_DISCONNECTED;
 
-	info->feature_persistent = feature_persistent;
-
 	/* Front end dir is a number, which is used as the id. */
 	info->handle = simple_strtoul(strrchr(dev->nodename, '/')+1, NULL, 0);
 	dev_set_drvdata(&dev->dev, info);
@@ -2306,7 +2304,7 @@ static void blkfront_gather_backend_feat
 	if (xenbus_read_unsigned(info->xbdev->otherend, "feature-discard", 0))
 		blkfront_setup_discard(info);
 
-	if (info->feature_persistent)
+	if (feature_persistent)
 		info->feature_persistent =
 			!!xenbus_read_unsigned(info->xbdev->otherend,
 					       "feature-persistent", 0);


