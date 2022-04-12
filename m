Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33AF14FD418
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233843AbiDLHMO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351514AbiDLHLR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:11:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB8C44A908;
        Mon, 11 Apr 2022 23:49:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4498BB81B4F;
        Tue, 12 Apr 2022 06:49:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A48DC385A8;
        Tue, 12 Apr 2022 06:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746196;
        bh=oL6pcHfoJFEn644SDRdroH9B87CSQDpU3mwqLp1o2DM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JgUpUWZaBiwKU4TFB7S42Pxu3us2FeWsdCshM0Rar7DmjzjRlHuN6eoSwdbQpAryX
         sc2PphgQmGFQqpEwA8fE3DAks5ADKMwBbbbF3yoA5RvLzizD2wMRIX6zuMFzm2SwSq
         //vDNC9AMFbyDFIZ7YuuuKxgfmtndAUUvfSDO5XQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 196/277] scsi: ufs: ufshpb: Fix a NULL check on list iterator
Date:   Tue, 12 Apr 2022 08:29:59 +0200
Message-Id: <20220412062947.710841093@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
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

From: Xiaomeng Tong <xiam0nd.tong@gmail.com>

[ Upstream commit bfb7789bcbd901caead43861461bc8f334c90d3b ]

The list iterator is always non-NULL so the check 'if (!rgn)' is always
false and the dev_err() is never called. Move the check outside the loop
and determine if 'victim_rgn' is NULL, to fix this bug.

Link: https://lore.kernel.org/r/20220320150733.21824-1-xiam0nd.tong@gmail.com
Fixes: 4b5f49079c52 ("scsi: ufs: ufshpb: L2P map management for HPB read")
Reviewed-by: Daejun Park <daejun7.park@samsung.com>
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshpb.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index a86d0cc50de2..f7eaf64293a4 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -870,12 +870,6 @@ static struct ufshpb_region *ufshpb_victim_lru_info(struct ufshpb_lu *hpb)
 	struct ufshpb_region *rgn, *victim_rgn = NULL;
 
 	list_for_each_entry(rgn, &lru_info->lh_lru_rgn, list_lru_rgn) {
-		if (!rgn) {
-			dev_err(&hpb->sdev_ufs_lu->sdev_dev,
-				"%s: no region allocated\n",
-				__func__);
-			return NULL;
-		}
 		if (ufshpb_check_srgns_issue_state(hpb, rgn))
 			continue;
 
@@ -891,6 +885,11 @@ static struct ufshpb_region *ufshpb_victim_lru_info(struct ufshpb_lu *hpb)
 		break;
 	}
 
+	if (!victim_rgn)
+		dev_err(&hpb->sdev_ufs_lu->sdev_dev,
+			"%s: no region allocated\n",
+			__func__);
+
 	return victim_rgn;
 }
 
-- 
2.35.1



