Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26F8E4C74E8
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238479AbiB1Rsn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:48:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239070AbiB1RsD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:48:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAA3EA0BFB;
        Mon, 28 Feb 2022 09:38:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30229614CC;
        Mon, 28 Feb 2022 17:38:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3991EC340F1;
        Mon, 28 Feb 2022 17:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069910;
        bh=0G/Ws/alzh86P7Z9GzSFEwyIbKhatD+PgBcy3MZ24Sg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hB/sBnX7z++4vTOCRysEqw5w6y1sd8OPCLd3Lt9SeCsv93ImFx4W5KmoSpN2t8jMr
         k2Y30q1Xht4ePiUI+oHTYALq/NUaZvza+Wg5I+u1rRPhcvGCnYykBnHkwtzVIIGNlp
         IY5tq/YtdhfQ6nHlwzGUkzMtBOcYy0+QSNdtTceI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Daniel Wagner <dwagner@suse.de>
Subject: [PATCH 5.15 057/139] nvme: also mark passthrough-only namespaces ready in nvme_update_ns_info
Date:   Mon, 28 Feb 2022 18:23:51 +0100
Message-Id: <20220228172353.699891192@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
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
@@ -1914,7 +1914,7 @@ static int nvme_update_ns_info(struct nv
 	if (blk_queue_is_zoned(ns->queue)) {
 		ret = nvme_revalidate_zones(ns);
 		if (ret && !nvme_first_scan(ns->disk))
-			goto out;
+			return ret;
 	}
 
 	if (nvme_ns_head_multipath(ns->head)) {
@@ -1929,16 +1929,16 @@ static int nvme_update_ns_info(struct nv
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
 


