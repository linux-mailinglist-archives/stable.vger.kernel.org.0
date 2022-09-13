Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B36625B716D
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234208AbiIMOlf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234441AbiIMOkp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:40:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE2B36D57E;
        Tue, 13 Sep 2022 07:21:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15CF06149A;
        Tue, 13 Sep 2022 14:20:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C1EAC433D6;
        Tue, 13 Sep 2022 14:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078837;
        bh=dowIBB/GIP3oLAHFW8IvKxJycSBw8huMxMSJIGACm/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NkdjCjFHNRy+7+sj+ci7Cv5Uem44EXHQ4yT8g7Vt8aSxAB6WF7e7JTnxlC6JJmzf1
         sZQZvG4T8N1pGxpxmoJow3jIeo25t6H92zqcClMPI4LUnOf714QKca4ik+4ds9NFjc
         asK7jtVnPEo40sk8rXhYd8Nsnnzfw056BiuSdcQo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>,
        Dennis Maisenbacher <dennis.maisenbacher@wdc.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 094/121] nvmet: fix mar and mor off-by-one errors
Date:   Tue, 13 Sep 2022 16:04:45 +0200
Message-Id: <20220913140401.398486262@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140357.323297659@linuxfoundation.org>
References: <20220913140357.323297659@linuxfoundation.org>
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

From: Dennis Maisenbacher <dennis.maisenbacher@wdc.com>

[ Upstream commit b7e97872a65e1d57b4451769610554c131f37a0a ]

Maximum Active Resources (MAR) and Maximum Open Resources (MOR) are 0's
based vales where a value of 0xffffffff indicates that there is no limit.

Decrement the values that are returned by bdev_max_open_zones and
bdev_max_active_zones as the block layer helpers are not 0's based.
A 0 returned by the block layer helpers indicates no limit, thus convert
it to 0xffffffff (U32_MAX).

Fixes: aaf2e048af27 ("nvmet: add ZBD over ZNS backend support")
Suggested-by: Niklas Cassel <niklas.cassel@wdc.com>
Signed-off-by: Dennis Maisenbacher <dennis.maisenbacher@wdc.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/zns.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/zns.c b/drivers/nvme/target/zns.c
index 235553337fb2d..1466698751c55 100644
--- a/drivers/nvme/target/zns.c
+++ b/drivers/nvme/target/zns.c
@@ -100,6 +100,7 @@ void nvmet_execute_identify_cns_cs_ns(struct nvmet_req *req)
 	struct nvme_id_ns_zns *id_zns;
 	u64 zsze;
 	u16 status;
+	u32 mar, mor;
 
 	if (le32_to_cpu(req->cmd->identify.nsid) == NVME_NSID_ALL) {
 		req->error_loc = offsetof(struct nvme_identify, nsid);
@@ -126,8 +127,20 @@ void nvmet_execute_identify_cns_cs_ns(struct nvmet_req *req)
 	zsze = (bdev_zone_sectors(req->ns->bdev) << 9) >>
 					req->ns->blksize_shift;
 	id_zns->lbafe[0].zsze = cpu_to_le64(zsze);
-	id_zns->mor = cpu_to_le32(bdev_max_open_zones(req->ns->bdev));
-	id_zns->mar = cpu_to_le32(bdev_max_active_zones(req->ns->bdev));
+
+	mor = bdev_max_open_zones(req->ns->bdev);
+	if (!mor)
+		mor = U32_MAX;
+	else
+		mor--;
+	id_zns->mor = cpu_to_le32(mor);
+
+	mar = bdev_max_active_zones(req->ns->bdev);
+	if (!mar)
+		mar = U32_MAX;
+	else
+		mar--;
+	id_zns->mar = cpu_to_le32(mar);
 
 done:
 	status = nvmet_copy_to_sgl(req, 0, id_zns, sizeof(*id_zns));
-- 
2.35.1



