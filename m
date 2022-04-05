Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4A414F2D4A
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245293AbiDEIym (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240974AbiDEIcl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 940899E9E0;
        Tue,  5 Apr 2022 01:25:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F419C60FFC;
        Tue,  5 Apr 2022 08:25:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2E8C385A1;
        Tue,  5 Apr 2022 08:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147135;
        bh=tRO1PGn12jKvQfnysJtLy8P3zLYsaGSIXrfzfDWlxbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y42tajtVDqNnaK1E2mDiELwH972laRUbytG50nDeZuQzi6N4drrr0FeGATGgmedPE
         xqhtlZ77+PuPNCLrkXGfLRL0ZpJza2KlzfbddTNR0wfPrXE0oaANl3amOV2WHURmue
         7vlo5mewUdLCpmvFhoPBNdguJUbxl0Zd7dVKnKlA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pankaj Raghav <p.raghav@samsung.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.17 1015/1126] nvme: fix the read-only state for zoned namespaces with unsupposed features
Date:   Tue,  5 Apr 2022 09:29:22 +0200
Message-Id: <20220405070437.280317264@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Pankaj Raghav <p.raghav@samsung.com>

commit 726be2c72efc0a64c206e854b8996ad3ab9c7507 upstream.

commit 2f4c9ba23b88 ("nvme: export zoned namespaces without Zone Append
support read-only") marks zoned namespaces without append support
read-only.  It does iso by setting NVME_NS_FORCE_RO in ns->flags in
nvme_update_zone_info and checking for that flag later in
nvme_update_disk_info to mark the disk as read-only.

But commit 73d90386b559 ("nvme: cleanup zone information initialization")
rearranged nvme_update_disk_info to be called before
nvme_update_zone_info and thus not marking the disk as read-only.
The call order cannot be just reverted because nvme_update_zone_info sets
certain queue parameters such as zone_write_granularity that depend on the
prior call to nvme_update_disk_info.

Remove the call to set_disk_ro in nvme_update_disk_info. and call
set_disk_ro after nvme_update_zone_info and nvme_update_disk_info to set
the permission for ZNS drives correctly. The same applies to the
multipath disk path.

Fixes: 73d90386b559 ("nvme: cleanup zone information initialization")
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/core.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1857,9 +1857,6 @@ static void nvme_update_disk_info(struct
 	nvme_config_discard(disk, ns);
 	blk_queue_max_write_zeroes_sectors(disk->queue,
 					   ns->ctrl->max_zeroes_sectors);
-
-	set_disk_ro(disk, (id->nsattr & NVME_NS_ATTR_RO) ||
-		test_bit(NVME_NS_FORCE_RO, &ns->flags));
 }
 
 static inline bool nvme_first_scan(struct gendisk *disk)
@@ -1918,6 +1915,8 @@ static int nvme_update_ns_info(struct nv
 			goto out_unfreeze;
 	}
 
+	set_disk_ro(ns->disk, (id->nsattr & NVME_NS_ATTR_RO) ||
+		test_bit(NVME_NS_FORCE_RO, &ns->flags));
 	set_bit(NVME_NS_READY, &ns->flags);
 	blk_mq_unfreeze_queue(ns->disk->queue);
 
@@ -1930,6 +1929,9 @@ static int nvme_update_ns_info(struct nv
 	if (nvme_ns_head_multipath(ns->head)) {
 		blk_mq_freeze_queue(ns->head->disk->queue);
 		nvme_update_disk_info(ns->head->disk, ns, id);
+		set_disk_ro(ns->head->disk,
+			    (id->nsattr & NVME_NS_ATTR_RO) ||
+				    test_bit(NVME_NS_FORCE_RO, &ns->flags));
 		nvme_mpath_revalidate_paths(ns);
 		blk_stack_limits(&ns->head->disk->queue->limits,
 				 &ns->queue->limits, 0);


