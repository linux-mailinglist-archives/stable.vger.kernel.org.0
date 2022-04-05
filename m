Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7784F2BA6
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241896AbiDEIf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239166AbiDEITx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:19:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D857891F;
        Tue,  5 Apr 2022 01:10:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12E6B609AD;
        Tue,  5 Apr 2022 08:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2100AC385A0;
        Tue,  5 Apr 2022 08:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146219;
        bh=ODLmb/qEa/+AEJJLUYZtqVO2J3cyrwlSn6sNYOX+hEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AmU48dx1lt4xhU3CF4m0n73MxYBHCrytZ1RhEszsgGlMiRPDS87j7fbghg0GeCg5v
         6lHi42/1gDepTMq0+fhx4Lk7XUughomWM3BrPpZqFSLFMF7znpV9Y5cL+TytyijPPO
         ps7qXjrCd1sWbOb5V2EupL6wqgs1zO9+yAiTfRBU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0686/1126] RDMA/nldev: Prevent underflow in nldev_stat_set_counter_dynamic_doit()
Date:   Tue,  5 Apr 2022 09:23:53 +0200
Message-Id: <20220405070427.752366418@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 87e0eacb176f9500c2063d140c0a1d7fa51ab8a5 ]

This code checks "index" for an upper bound but it does not check for
negatives.  Change the type to unsigned to prevent underflows.

Fixes: 3c3c1f141639 ("RDMA/nldev: Allow optional-counter status configuration through RDMA netlink")
Link: https://lore.kernel.org/r/20220316083948.GC30941@kili
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/nldev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index f5aacaf7fb8e..ca24ce34da76 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -1951,9 +1951,10 @@ static int nldev_stat_set_counter_dynamic_doit(struct nlattr *tb[],
 					       u32 port)
 {
 	struct rdma_hw_stats *stats;
-	int rem, i, index, ret = 0;
 	struct nlattr *entry_attr;
 	unsigned long *target;
+	int rem, i, ret = 0;
+	u32 index;
 
 	stats = ib_get_hw_stats_port(device, port);
 	if (!stats)
-- 
2.34.1



