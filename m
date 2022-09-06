Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E90255AEBFD
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239658AbiIFN5g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239433AbiIFNx1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:53:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C94C07D1F8;
        Tue,  6 Sep 2022 06:40:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19A57B8162F;
        Tue,  6 Sep 2022 13:40:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A57C433B5;
        Tue,  6 Sep 2022 13:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471630;
        bh=YfcFm3eVu8wW0562HxmnYE6vq6k/cHa/5LU/tO0rNJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tor3iWc9s1igOaf1dBbxiNarql38WbZCq2F3c72QPMeBH6TeOoPEXIkolDu6VfQvL
         MYoEwhcn9+xwoQk9/D5oOcDgaII3Q/mxzaPdwblnNIVBZdp0SzWhzQQmiMMaUEVMzL
         KjyA63vC3oxyfcpgb8E+IP85+heqMjrR72+ObyaQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        SeongJae Park <sj@kernel.org>,
        =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>
Subject: [PATCH 5.15 065/107] xen-blkfront: Advertise feature-persistent as user requested
Date:   Tue,  6 Sep 2022 15:30:46 +0200
Message-Id: <20220906132824.587924590@linuxfoundation.org>
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

commit 9f5e0fe5d05f7e8de7f39b2b10089834eb0ff787 upstream.

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
Tested-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/20220831165824.94815-3-sj@kernel.org
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/xen-blkfront.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -212,6 +212,9 @@ struct blkfront_info
 	unsigned int feature_fua:1;
 	unsigned int feature_discard:1;
 	unsigned int feature_secdiscard:1;
+	/* Connect-time cached feature_persistent parameter */
+	unsigned int feature_persistent_parm:1;
+	/* Persistent grants feature negotiation result */
 	unsigned int feature_persistent:1;
 	unsigned int bounce:1;
 	unsigned int discard_granularity;
@@ -1874,7 +1877,7 @@ again:
 		goto abort_transaction;
 	}
 	err = xenbus_printf(xbt, dev->nodename, "feature-persistent", "%u",
-			info->feature_persistent);
+			info->feature_persistent_parm);
 	if (err)
 		dev_warn(&dev->dev,
 			 "writing persistent grants feature to xenbus");
@@ -2307,7 +2310,8 @@ static void blkfront_gather_backend_feat
 	if (xenbus_read_unsigned(info->xbdev->otherend, "feature-discard", 0))
 		blkfront_setup_discard(info);
 
-	if (feature_persistent)
+	info->feature_persistent_parm = feature_persistent;
+	if (info->feature_persistent_parm)
 		info->feature_persistent =
 			!!xenbus_read_unsigned(info->xbdev->otherend,
 					       "feature-persistent", 0);


