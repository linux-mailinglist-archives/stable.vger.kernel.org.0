Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1F15AEA97
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238738AbiIFNup (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239686AbiIFNtr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:49:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 749B02A737;
        Tue,  6 Sep 2022 06:40:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4215961548;
        Tue,  6 Sep 2022 13:39:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D949C433D6;
        Tue,  6 Sep 2022 13:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471598;
        bh=15MwJgeHSfXwo35UCPM9zI6FArWH9SUDs8GxNfRMjvQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W4lY0clMPrQCjSVGHTXjixJbfa7KTrux3e/vRdexW6iJQONmHphKmUiXbaph/n3Gd
         o75MUKbftcRoen/BhJzrZAFyAAimixfxr9MTNb0viS83s7vGQuf7ghRQOgZ+ju8eF4
         g9XcPd75lx2O5Z3eMQUZbTq7WoPO0s0q2LP/KLbQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        SeongJae Park <sj@kernel.org>,
        =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>
Subject: [PATCH 5.15 064/107] xen-blkback: Advertise feature-persistent as user requested
Date:   Tue,  6 Sep 2022 15:30:45 +0200
Message-Id: <20220906132824.540502433@linuxfoundation.org>
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

commit 06ba5d2e943e97bb66e75c152e87f1d2c7027a67 upstream.

The advertisement of the persistent grants feature (writing
'feature-persistent' to xenbus) should mean not the decision for using
the feature but only the availability of the feature.  However, commit
aac8a70db24b ("xen-blkback: add a parameter for disabling of persistent
grants") made a field of blkback, which was a place for saving only the
negotiation result, to be used for yet another purpose: caching of the
'feature_persistent' parameter value.  As a result, the advertisement,
which should follow only the parameter value, becomes inconsistent.

This commit fixes the misuse of the semantic by making blkback saves the
parameter value in a separate place and advertises the support based on
only the saved value.

Fixes: aac8a70db24b ("xen-blkback: add a parameter for disabling of persistent grants")
Cc: <stable@vger.kernel.org> # 5.10.x
Suggested-by: Juergen Gross <jgross@suse.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
Tested-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/20220831165824.94815-2-sj@kernel.org
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/xen-blkback/common.h |    3 +++
 drivers/block/xen-blkback/xenbus.c |    6 ++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/block/xen-blkback/common.h
+++ b/drivers/block/xen-blkback/common.h
@@ -226,6 +226,9 @@ struct xen_vbd {
 	sector_t		size;
 	unsigned int		flush_support:1;
 	unsigned int		discard_secure:1;
+	/* Connect-time cached feature_persistent parameter value */
+	unsigned int		feature_gnt_persistent_parm:1;
+	/* Persistent grants feature negotiation result */
 	unsigned int		feature_gnt_persistent:1;
 	unsigned int		overflow_max_grants:1;
 };
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -910,7 +910,7 @@ again:
 	xen_blkbk_barrier(xbt, be, be->blkif->vbd.flush_support);
 
 	err = xenbus_printf(xbt, dev->nodename, "feature-persistent", "%u",
-			be->blkif->vbd.feature_gnt_persistent);
+			be->blkif->vbd.feature_gnt_persistent_parm);
 	if (err) {
 		xenbus_dev_fatal(dev, err, "writing %s/feature-persistent",
 				 dev->nodename);
@@ -1088,7 +1088,9 @@ static int connect_ring(struct backend_i
 		return -ENOSYS;
 	}
 
-	blkif->vbd.feature_gnt_persistent = feature_persistent &&
+	blkif->vbd.feature_gnt_persistent_parm = feature_persistent;
+	blkif->vbd.feature_gnt_persistent =
+		blkif->vbd.feature_gnt_persistent_parm &&
 		xenbus_read_unsigned(dev->otherend, "feature-persistent", 0);
 
 	blkif->vbd.overflow_max_grants = 0;


