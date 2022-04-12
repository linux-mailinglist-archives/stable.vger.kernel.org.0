Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4DB34FD7AD
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353615AbiDLHeA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353705AbiDLHZw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:25:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C35F2610F;
        Tue, 12 Apr 2022 00:03:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EAB2860B2B;
        Tue, 12 Apr 2022 07:03:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F259EC385A1;
        Tue, 12 Apr 2022 07:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747033;
        bh=d99ktAmACl+jsTaV4QjDI+M78GFyfOHnTePoKIlYgB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QKjfjtsyHBX444m/ki5ioFlubnKoFfaL1O3fMTExUztCKs6kWzY7q1+BD9TZ9q5jP
         pvavxb5Zx1BPcRULnAw9I/mKV+mAtpC8H6cxtzy2MpbDufPwAQ7Oaccdtlijyij4kx
         LtJRx/TNLmQTHZ+FpmH0w/lQM0Nt9IFVelQCew8E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 202/285] scsi: ufs: ufshpb: Fix a NULL check on list iterator
Date:   Tue, 12 Apr 2022 08:30:59 +0200
Message-Id: <20220412062949.490739902@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
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
index ded5ba9b1466..54c3b8f34c0a 100644
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



