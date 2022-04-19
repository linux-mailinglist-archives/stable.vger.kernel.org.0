Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E07D50787C
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 20:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356786AbiDSSUl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 14:20:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356789AbiDSSTt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 14:19:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B731E3FBEE;
        Tue, 19 Apr 2022 11:13:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0336260A75;
        Tue, 19 Apr 2022 18:13:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69469C385A7;
        Tue, 19 Apr 2022 18:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650392029;
        bh=pLJV1qtoBgUejyTtl1bi9Y8qfqHAmqzfVAIQozwD2d8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pNfQLgnZU2zD5O9rppNAcQl5K4tYB3DScEv+nkAIre9cPFuDqRoBJ6MyUjbcDdbBX
         9oj81dvDk10Y+JULnqA6bXca3gNZdGNXK6v6MbMdaq8x7W338FC3fzq2eXSUCDMpRd
         fsE1jHqQ1ax1Ger9KMxrVettE9jYAvGnxw6bfT+TTjKp+2Ygp67tvRDY2AfXUeP5Pz
         uQooxx+J+4OVXJBK7oymCcaDcH14DKPAoZBPoPotV6+txZw6ScWjgbinrdoFN+MXi3
         UOM1bKdsU8b+L8Gd/8r4P8V8WB7G/RRkZsvXhVsZ1HbPWmDyY78iJQ9DJh90dvQTha
         N6pWkvWIZqimg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, axboe@fb.com,
        linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 25/27] nvme: add a quirk to disable namespace identifiers
Date:   Tue, 19 Apr 2022 14:12:40 -0400
Message-Id: <20220419181242.485308-25-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220419181242.485308-1-sashal@kernel.org>
References: <20220419181242.485308-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 00ff400e6deee00f7b15e200205b2708b63b8cf6 ]

Add a quirk to disable using and exporting namespace identifiers for
controllers where they are broken beyond repair.

The most directly visible problem with non-unique namespace identifiers
is that they break the /dev/disk/by-id/ links, with the link for a
supposedly unique identifier now pointing to one of multiple possible
namespaces that share the same ID, and a somewhat random selection of
which one actually shows up.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 24 ++++++++++++++++++------
 drivers/nvme/host/nvme.h |  5 +++++
 2 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 4c35e9acf8ee..f2bb57615762 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1354,6 +1354,8 @@ static int nvme_process_ns_desc(struct nvme_ctrl *ctrl, struct nvme_ns_ids *ids,
 				 warn_str, cur->nidl);
 			return -1;
 		}
+		if (ctrl->quirks & NVME_QUIRK_BOGUS_NID)
+			return NVME_NIDT_EUI64_LEN;
 		memcpy(ids->eui64, data + sizeof(*cur), NVME_NIDT_EUI64_LEN);
 		return NVME_NIDT_EUI64_LEN;
 	case NVME_NIDT_NGUID:
@@ -1362,6 +1364,8 @@ static int nvme_process_ns_desc(struct nvme_ctrl *ctrl, struct nvme_ns_ids *ids,
 				 warn_str, cur->nidl);
 			return -1;
 		}
+		if (ctrl->quirks & NVME_QUIRK_BOGUS_NID)
+			return NVME_NIDT_NGUID_LEN;
 		memcpy(ids->nguid, data + sizeof(*cur), NVME_NIDT_NGUID_LEN);
 		return NVME_NIDT_NGUID_LEN;
 	case NVME_NIDT_UUID:
@@ -1370,6 +1374,8 @@ static int nvme_process_ns_desc(struct nvme_ctrl *ctrl, struct nvme_ns_ids *ids,
 				 warn_str, cur->nidl);
 			return -1;
 		}
+		if (ctrl->quirks & NVME_QUIRK_BOGUS_NID)
+			return NVME_NIDT_UUID_LEN;
 		uuid_copy(&ids->uuid, data + sizeof(*cur));
 		return NVME_NIDT_UUID_LEN;
 	case NVME_NIDT_CSI:
@@ -1466,12 +1472,18 @@ static int nvme_identify_ns(struct nvme_ctrl *ctrl, unsigned nsid,
 	if ((*id)->ncap == 0) /* namespace not allocated or attached */
 		goto out_free_id;
 
-	if (ctrl->vs >= NVME_VS(1, 1, 0) &&
-	    !memchr_inv(ids->eui64, 0, sizeof(ids->eui64)))
-		memcpy(ids->eui64, (*id)->eui64, sizeof(ids->eui64));
-	if (ctrl->vs >= NVME_VS(1, 2, 0) &&
-	    !memchr_inv(ids->nguid, 0, sizeof(ids->nguid)))
-		memcpy(ids->nguid, (*id)->nguid, sizeof(ids->nguid));
+
+	if (ctrl->quirks & NVME_QUIRK_BOGUS_NID) {
+		dev_info(ctrl->device,
+			 "Ignoring bogus Namespace Identifiers\n");
+	} else {
+		if (ctrl->vs >= NVME_VS(1, 1, 0) &&
+		    !memchr_inv(ids->eui64, 0, sizeof(ids->eui64)))
+			memcpy(ids->eui64, (*id)->eui64, sizeof(ids->eui64));
+		if (ctrl->vs >= NVME_VS(1, 2, 0) &&
+		    !memchr_inv(ids->nguid, 0, sizeof(ids->nguid)))
+			memcpy(ids->nguid, (*id)->nguid, sizeof(ids->nguid));
+	}
 
 	return 0;
 
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 0628e2d802e7..f1e5c7564cae 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -144,6 +144,11 @@ enum nvme_quirks {
 	 * encoding the generation sequence number.
 	 */
 	NVME_QUIRK_SKIP_CID_GEN			= (1 << 17),
+
+	/*
+	 * Reports garbage in the namespace identifiers (eui64, nguid, uuid).
+	 */
+	NVME_QUIRK_BOGUS_NID			= (1 << 18),
 };
 
 /*
-- 
2.35.1

