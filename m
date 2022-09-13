Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A02F5B703C
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232782AbiIMOYY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233139AbiIMOXb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:23:31 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E433861701;
        Tue, 13 Sep 2022 07:15:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C9484CE1275;
        Tue, 13 Sep 2022 14:13:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C41AAC433D6;
        Tue, 13 Sep 2022 14:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078436;
        bh=1ME5e66fVDTdP1+yLfK6JdLvd1xQYZ9E8X3oa+BdnZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=quVTk97uTwh2aVJVL+hFdDfj3ONfzbhk7A/5mymve3x/l72yYqGLo57FvpQk2fc9d
         YciTroujvjGnhPGcAkFb8oQ8tErCnC+FeRH9ebnlSCZM+Ifc86E7EBVeQhmoUzVUMI
         25UpJjvhDIDsahh81zKX6kYx/Rxx86Jg8BacDsz0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>,
        Dennis Maisenbacher <dennis.maisenbacher@wdc.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 139/192] nvmet: fix mar and mor off-by-one errors
Date:   Tue, 13 Sep 2022 16:04:05 +0200
Message-Id: <20220913140416.942610283@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
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
index 82b61acf7a72b..1956be87ac5ff 100644
--- a/drivers/nvme/target/zns.c
+++ b/drivers/nvme/target/zns.c
@@ -100,6 +100,7 @@ void nvmet_execute_identify_cns_cs_ns(struct nvmet_req *req)
 	struct nvme_id_ns_zns *id_zns;
 	u64 zsze;
 	u16 status;
+	u32 mar, mor;
 
 	if (le32_to_cpu(req->cmd->identify.nsid) == NVME_NSID_ALL) {
 		req->error_loc = offsetof(struct nvme_identify, nsid);
@@ -130,8 +131,20 @@ void nvmet_execute_identify_cns_cs_ns(struct nvmet_req *req)
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



