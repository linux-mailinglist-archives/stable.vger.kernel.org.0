Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA114C7417
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238316AbiB1RlD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:41:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238391AbiB1RkO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:40:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBFB2939BA;
        Mon, 28 Feb 2022 09:34:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73028614BB;
        Mon, 28 Feb 2022 17:34:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89CDFC340E7;
        Mon, 28 Feb 2022 17:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069668;
        bh=IiacSrL8ob66hiYq0YoGi1dM+cEsZe0gKs70eha+nJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=guf2BuAg3XgR2ilCjvZJ5XUmAip69nvMQvgzX7LoE/hVAKXI7SpRrs/6SfuUzPibY
         /fgylctLpT/mRAHpAOp2W6B5CSHX0p4U1rXOL7UL7m7D2K8ObP4zzuU93wwQianlE0
         jTGQFM0VWY62LUOhftzqbx+U0+x1KrxBBvmeM+lE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Md Haris Iqbal <haris.iqbal@cloud.ionos.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 48/80] RDMA/rtrs-clt: Kill wait_for_inflight_permits
Date:   Mon, 28 Feb 2022 18:24:29 +0100
Message-Id: <20220228172317.471329041@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172311.789892158@linuxfoundation.org>
References: <20220228172311.789892158@linuxfoundation.org>
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

From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>

[ Upstream commit 25a033f5a75873cfdd36eca3c702363b682afb42 ]

Let's wait the inflight permits before free it.

Link: https://lore.kernel.org/r/20201217141915.56989-10-jinpu.wang@cloud.ionos.com
Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Reviewed-by: Md Haris Iqbal <haris.iqbal@cloud.ionos.com>
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index 8937530a42d3d..5a3c11b0b3102 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -1328,6 +1328,12 @@ static int alloc_permits(struct rtrs_clt *clt)
 
 static void free_permits(struct rtrs_clt *clt)
 {
+	if (clt->permits_map) {
+		size_t sz = clt->queue_depth;
+
+		wait_event(clt->permits_wait,
+			   find_first_bit(clt->permits_map, sz) >= sz);
+	}
 	kfree(clt->permits_map);
 	clt->permits_map = NULL;
 	kfree(clt->permits);
@@ -2630,19 +2636,8 @@ static struct rtrs_clt *alloc_clt(const char *sessname, size_t paths_num,
 	return ERR_PTR(err);
 }
 
-static void wait_for_inflight_permits(struct rtrs_clt *clt)
-{
-	if (clt->permits_map) {
-		size_t sz = clt->queue_depth;
-
-		wait_event(clt->permits_wait,
-			   find_first_bit(clt->permits_map, sz) >= sz);
-	}
-}
-
 static void free_clt(struct rtrs_clt *clt)
 {
-	wait_for_inflight_permits(clt);
 	free_permits(clt);
 	free_percpu(clt->pcpu_path);
 
-- 
2.34.1



