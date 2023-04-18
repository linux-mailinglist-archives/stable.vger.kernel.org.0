Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9B76E6401
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231993AbjDRMpX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:45:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231992AbjDRMpL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:45:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B7414F45
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:45:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C31863386
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:45:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32760C4339B;
        Tue, 18 Apr 2023 12:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821907;
        bh=pTbkjzfaeQU930DZLs1p45w9v8u6hrQ4ZonOodWyQnE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pXAuRKlzpI4OdHdqMjaRnvcgPxoUnLPpuewQ0A/lKlwPjAWs/MJw+H84jwmApFuK5
         83NPNHor0NJZWfjY8WK1WCPOY75XWZTHs9j53E4p7HWM0qbUw9D4Xw+/22mCRhjRRB
         TDEaL5/Lf64TAuBJPJCeGcNlyOOponAW/UzUtIuA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Martin George <marting@netapp.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 087/134] nvme: send Identify with CNS 06h only to I/O controllers
Date:   Tue, 18 Apr 2023 14:22:23 +0200
Message-Id: <20230418120316.174276818@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin George <martinus.gpy@gmail.com>

[ Upstream commit def84ab600b71ea3fcc422a876d5d0d0daa7d4f3 ]

Identify CNS 06h (I/O Command Set Specific Identify Controller data
structure) is supported only on i/o controllers.

But nvme_init_non_mdts_limits() currently invokes this on all
controllers.  Correct this by ensuring this is sent to I/O
controllers only.

Signed-off-by: Martin George <marting@netapp.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index cb71ce3413c2d..c54c6ffba0bcd 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3074,7 +3074,8 @@ static int nvme_init_non_mdts_limits(struct nvme_ctrl *ctrl)
 	else
 		ctrl->max_zeroes_sectors = 0;
 
-	if (nvme_ctrl_limited_cns(ctrl))
+	if (ctrl->subsys->subtype != NVME_NQN_NVME ||
+	    nvme_ctrl_limited_cns(ctrl))
 		return 0;
 
 	id = kzalloc(sizeof(*id), GFP_KERNEL);
-- 
2.39.2



