Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 901B95937DE
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343839AbiHOTTB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:19:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344926AbiHOTRt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:17:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50EE4564C5;
        Mon, 15 Aug 2022 11:39:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 896F761120;
        Mon, 15 Aug 2022 18:39:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB05C433D6;
        Mon, 15 Aug 2022 18:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588745;
        bh=JKHcDBZsZRMwwOITBiCJ9ZA2CMg2W48vTA7rzjDmilU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JUzFYUBrIJVBaAXl0HhFe3+zPpZg9cKOhCHaKA2cazn/2u4ILfnn5qR5UzklQkNtb
         Htmd/N4JV8RDMSWX+ZpIu2uhrRnRPIUTtX7Joipr26ntXs7E2KRyt3+C8KdZ1da5Md
         7BxDLHYC63ksEjdV8wSHsuQIZm5vFjvEkaksaHnk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, jinpu.wang@ionos.com,
        Md Haris Iqbal <haris.iqbal@ionos.com>,
        Aleksei Marov <aleksei.marov@ionos.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 502/779] RDMA/rtrs-srv: Fix modinfo output for stringify
Date:   Mon, 15 Aug 2022 20:02:26 +0200
Message-Id: <20220815180358.721711054@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

From: Jack Wang <jinpu.wang@ionos.com>

[ Upstream commit ed6e53820ee4f68ed927de17e5675ff2a07a47e2 ]

stringify works with define, not enum.

Fixes: 91fddedd439c ("RDMA/rtrs: private headers with rtrs protocol structs and helpers")
Cc: jinpu.wang@ionos.com
Link: https://lore.kernel.org/r/20220712103113.617754-2-haris.iqbal@ionos.com
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Md Haris Iqbal <haris.iqbal@ionos.com>
Reviewed-by: Aleksei Marov <aleksei.marov@ionos.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-pri.h | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-pri.h b/drivers/infiniband/ulp/rtrs/rtrs-pri.h
index d12ddfa50747..e39267bccce8 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-pri.h
+++ b/drivers/infiniband/ulp/rtrs/rtrs-pri.h
@@ -23,6 +23,17 @@
 #define RTRS_PROTO_VER_STRING __stringify(RTRS_PROTO_VER_MAJOR) "." \
 			       __stringify(RTRS_PROTO_VER_MINOR)
 
+/*
+ * Max IB immediate data size is 2^28 (MAX_IMM_PAYL_BITS)
+ * and the minimum chunk size is 4096 (2^12).
+ * So the maximum sess_queue_depth is 65536 (2^16) in theory.
+ * But mempool_create, create_qp and ib_post_send fail with
+ * "cannot allocate memory" error if sess_queue_depth is too big.
+ * Therefore the pratical max value of sess_queue_depth is
+ * somewhere between 1 and 65534 and it depends on the system.
+ */
+#define MAX_SESS_QUEUE_DEPTH 65535
+
 enum rtrs_imm_const {
 	MAX_IMM_TYPE_BITS = 4,
 	MAX_IMM_TYPE_MASK = ((1 << MAX_IMM_TYPE_BITS) - 1),
@@ -46,16 +57,6 @@ enum {
 
 	MAX_PATHS_NUM = 128,
 
-	/*
-	 * Max IB immediate data size is 2^28 (MAX_IMM_PAYL_BITS)
-	 * and the minimum chunk size is 4096 (2^12).
-	 * So the maximum sess_queue_depth is 65536 (2^16) in theory.
-	 * But mempool_create, create_qp and ib_post_send fail with
-	 * "cannot allocate memory" error if sess_queue_depth is too big.
-	 * Therefore the pratical max value of sess_queue_depth is
-	 * somewhere between 1 and 65534 and it depends on the system.
-	 */
-	MAX_SESS_QUEUE_DEPTH = 65535,
 	MIN_CHUNK_SIZE = 8192,
 
 	RTRS_HB_INTERVAL_MS = 5000,
-- 
2.35.1



