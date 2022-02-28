Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2048A4C7689
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 19:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236491AbiB1SFB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 13:05:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240568AbiB1SDk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 13:03:40 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7E2E91;
        Mon, 28 Feb 2022 09:47:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BA90DCE17C5;
        Mon, 28 Feb 2022 17:47:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA47AC340F0;
        Mon, 28 Feb 2022 17:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070421;
        bh=khOm+X9hpc0wLWcS9Gw7/RGcNpaafm0XrXj87EHoR2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KcMBLepVT1PGfaoFBWPOouL5b+9zkvbV/ZInuia/ds/xwgY+zZpRq7ZCKE9yFcBpJ
         Q2G3rjuxgDDkX2CPCcf8GEq9vOHbHxOIDxSbIfRHRgsSqxL6zzYhGBsNgTXC7LJrf2
         eTN2sDzevaB0t2eeYK1UqX6qUX/VPUg96778pbuE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Daniel Wagner <dwagner@suse.de>
Subject: [PATCH 5.16 063/164] nvme: also mark passthrough-only namespaces ready in nvme_update_ns_info
Date:   Mon, 28 Feb 2022 18:23:45 +0100
Message-Id: <20220228172405.905509293@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 602e57c9799c19f27e440639deed3ec45cfe1651 upstream.

Commit e7d65803e2bb ("nvme-multipath: revalidate paths during rescan")
introduced the NVME_NS_READY flag, which nvme_path_is_disabled() uses
to check if a path can be used or not.  We also need to set this flag
for devices that fail the ZNS feature validation and which are available
through passthrough devices only to that they can be used in multipathing
setups.

Fixes: e7d65803e2bb ("nvme-multipath: revalidate paths during rescan")
Reported-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Tested-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1936,7 +1936,7 @@ static int nvme_update_ns_info(struct nv
 	if (blk_queue_is_zoned(ns->queue)) {
 		ret = nvme_revalidate_zones(ns);
 		if (ret && !nvme_first_scan(ns->disk))
-			goto out;
+			return ret;
 	}
 
 	if (nvme_ns_head_multipath(ns->head)) {
@@ -1951,16 +1951,16 @@ static int nvme_update_ns_info(struct nv
 	return 0;
 
 out_unfreeze:
-	blk_mq_unfreeze_queue(ns->disk->queue);
-out:
 	/*
 	 * If probing fails due an unsupported feature, hide the block device,
 	 * but still allow other access.
 	 */
 	if (ret == -ENODEV) {
 		ns->disk->flags |= GENHD_FL_HIDDEN;
+		set_bit(NVME_NS_READY, &ns->flags);
 		ret = 0;
 	}
+	blk_mq_unfreeze_queue(ns->disk->queue);
 	return ret;
 }
 


