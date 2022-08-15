Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D521594C10
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346569AbiHPAYs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347551AbiHPAWt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:22:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D20617DA9F;
        Mon, 15 Aug 2022 13:34:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB9C8B811A6;
        Mon, 15 Aug 2022 20:33:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E60BDC433C1;
        Mon, 15 Aug 2022 20:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595631;
        bh=oIG0N6TGam1xomSkR9/ABfpyVGoHtQG7EBDiWWMcOQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PYOGqx9zXs6pKXuN3sZI277t+55IRBLiRz8VqNxMwX4Fxl4oewcpK5bcF2grUOEUI
         jgyiqPkgVH8GSCLVqD9oQlDZ6Mqhq7Xli6FIai46eqIykBiiTjZ6VeqqujSfDd499e
         8SYoj1bigUPeSgexQ8lcC2o3v79tAGfJqfHB00sw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, jinpu.wang@ionos.com,
        Md Haris Iqbal <haris.iqbal@ionos.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0824/1157] RDMA/rtrs-clt: Replace list_next_or_null_rr_rcu with an inline function
Date:   Mon, 15 Aug 2022 20:03:00 +0200
Message-Id: <20220815180512.447842601@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Md Haris Iqbal <haris.iqbal@ionos.com>

[ Upstream commit c14adff285ad1bb8eefc5d8fc202ceb1f7e3a2f1 ]

removes list_next_or_null_rr_rcu macro to fix below warnings.
That macro is used only twice.
CHECK:MACRO_ARG_REUSE: Macro argument reuse 'head' - possible side-effects?
CHECK:MACRO_ARG_REUSE: Macro argument reuse 'ptr' - possible side-effects?
CHECK:MACRO_ARG_REUSE: Macro argument reuse 'memb' - possible side-effects?

Replaces that macro with an inline function.

Fixes: 6a98d71daea1 ("RDMA/rtrs: client: main functionality")
Cc: jinpu.wang@ionos.com
Link: https://lore.kernel.org/r/20220712103113.617754-5-haris.iqbal@ionos.com
Signed-off-by: Md Haris Iqbal <haris.iqbal@ionos.com>
Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 35 ++++++++++++--------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index 9809c3883979..525f083fcaeb 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -740,25 +740,25 @@ struct path_it {
 	struct rtrs_clt_path *(*next_path)(struct path_it *it);
 };
 
-/**
- * list_next_or_null_rr_rcu - get next list element in round-robin fashion.
+/*
+ * rtrs_clt_get_next_path_or_null - get clt path from the list or return NULL
  * @head:	the head for the list.
- * @ptr:        the list head to take the next element from.
- * @type:       the type of the struct this is embedded in.
- * @memb:       the name of the list_head within the struct.
+ * @clt_path:	The element to take the next clt_path from.
  *
- * Next element returned in round-robin fashion, i.e. head will be skipped,
+ * Next clt path returned in round-robin fashion, i.e. head will be skipped,
  * but if list is observed as empty, NULL will be returned.
  *
- * This primitive may safely run concurrently with the _rcu list-mutation
+ * This function may safely run concurrently with the _rcu list-mutation
  * primitives such as list_add_rcu() as long as it's guarded by rcu_read_lock().
  */
-#define list_next_or_null_rr_rcu(head, ptr, type, memb) \
-({ \
-	list_next_or_null_rcu(head, ptr, type, memb) ?: \
-		list_next_or_null_rcu(head, READ_ONCE((ptr)->next), \
-				      type, memb); \
-})
+static inline struct rtrs_clt_path *
+rtrs_clt_get_next_path_or_null(struct list_head *head, struct rtrs_clt_path *clt_path)
+{
+	return list_next_or_null_rcu(head, &clt_path->s.entry, typeof(*clt_path), s.entry) ?:
+				     list_next_or_null_rcu(head,
+							   READ_ONCE((&clt_path->s.entry)->next),
+							   typeof(*clt_path), s.entry);
+}
 
 /**
  * get_next_path_rr() - Returns path in round-robin fashion.
@@ -789,10 +789,8 @@ static struct rtrs_clt_path *get_next_path_rr(struct path_it *it)
 		path = list_first_or_null_rcu(&clt->paths_list,
 					      typeof(*path), s.entry);
 	else
-		path = list_next_or_null_rr_rcu(&clt->paths_list,
-						&path->s.entry,
-						typeof(*path),
-						s.entry);
+		path = rtrs_clt_get_next_path_or_null(&clt->paths_list, path);
+
 	rcu_assign_pointer(*ppcpu_path, path);
 
 	return path;
@@ -2277,8 +2275,7 @@ static void rtrs_clt_remove_path_from_arr(struct rtrs_clt_path *clt_path)
 	 * removed.  If @sess is the last element, then @next is NULL.
 	 */
 	rcu_read_lock();
-	next = list_next_or_null_rr_rcu(&clt->paths_list, &clt_path->s.entry,
-					typeof(*next), s.entry);
+	next = rtrs_clt_get_next_path_or_null(&clt->paths_list, clt_path);
 	rcu_read_unlock();
 
 	/*
-- 
2.35.1



