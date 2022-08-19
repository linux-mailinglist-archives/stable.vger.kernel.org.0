Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E04C59A07A
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352407AbiHSQW2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352479AbiHSQVG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:21:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC25AA18C;
        Fri, 19 Aug 2022 09:02:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B66E614DA;
        Fri, 19 Aug 2022 16:02:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B1DC433D6;
        Fri, 19 Aug 2022 16:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924944;
        bh=3rE75/9xyZ7cw2tec2PKWCjR7BHjg9/lJTJxgkppOC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b21UDkGDVjAw+wxCuLINvpXF3I9H4fDbkz0jfOCEAhNrILhJDiblwx/mgU+3ejmD2
         oBQCN3cQlwIi5TvM0/jQ5oQW3JPn1dn1Bm2qcVoI6ZQLdA/K7n8v1eI0150+Y/sU8q
         w3FMn6HPdu3CvnQ3vDvzJ7zqdAWs6ELXEhYvwhok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gioh Kim <gi-oh.kim@ionos.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 332/545] RDMA/rtrs: Define MIN_CHUNK_SIZE
Date:   Fri, 19 Aug 2022 17:41:42 +0200
Message-Id: <20220819153844.240357527@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

From: Gioh Kim <gi-oh.kim@cloud.ionos.com>

[ Upstream commit 3f3d0eabc14b6ea1fcbe85a60ee9d44e2b930b8a ]

Define MIN_CHUNK_SIZE to replace the hard-coding number.
We need 4k for metadata, so MIN_CHUNK_SIZE should be at least 8k.

Link: https://lore.kernel.org/r/20210528113018.52290-7-jinpu.wang@ionos.com
Signed-off-by: Gioh Kim <gi-oh.kim@ionos.com>
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-pri.h | 1 +
 drivers/infiniband/ulp/rtrs/rtrs-srv.c | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-pri.h b/drivers/infiniband/ulp/rtrs/rtrs-pri.h
index 51c60f542876..333de9d52172 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-pri.h
+++ b/drivers/infiniband/ulp/rtrs/rtrs-pri.h
@@ -56,6 +56,7 @@ enum {
 	 * somewhere between 1 and 65536 and it depends on the system.
 	 */
 	MAX_SESS_QUEUE_DEPTH = 65536,
+	MIN_CHUNK_SIZE = 8192,
 
 	RTRS_HB_INTERVAL_MS = 5000,
 	RTRS_HB_MISSED_MAX = 5,
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index b033bfa9f383..b152a742cd3c 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -2193,9 +2193,9 @@ static int check_module_params(void)
 		       sess_queue_depth, 1, MAX_SESS_QUEUE_DEPTH);
 		return -EINVAL;
 	}
-	if (max_chunk_size < 4096 || !is_power_of_2(max_chunk_size)) {
+	if (max_chunk_size < MIN_CHUNK_SIZE || !is_power_of_2(max_chunk_size)) {
 		pr_err("Invalid max_chunk_size value %d, has to be >= %d and should be power of two.\n",
-		       max_chunk_size, 4096);
+		       max_chunk_size, MIN_CHUNK_SIZE);
 		return -EINVAL;
 	}
 
-- 
2.35.1



