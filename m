Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99DFF59440B
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345235AbiHOWiH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350971AbiHOWhY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:37:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3EB438B5;
        Mon, 15 Aug 2022 12:50:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D397161206;
        Mon, 15 Aug 2022 19:50:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7410CC433D6;
        Mon, 15 Aug 2022 19:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593040;
        bh=cxXucUSZz/3hhprAB3D1nyqJ+G2drWUuZmqO81cbMuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bQcBh2d5E5j73MXWSdQxBcsQz3ErB/glsor7/7OdrnCeYedtVSrA68TILX8MiMgxy
         bZV2X//8TrwTINh2+yU8p7LMYJEKMqPX47p6Nhspx99OivAdOyAZKcHsqlE7gcs29I
         nNVPemlCPg1fvCUAvokW9gv/J5zCmIWawoPD3nIU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0883/1095] 9p: Drop kref usage
Date:   Mon, 15 Aug 2022 20:04:42 +0200
Message-Id: <20220815180505.870121290@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Kent Overstreet <kent.overstreet@gmail.com>

[ Upstream commit 6cda12864cb0f99810a5809e11e3ee5b102c9a47 ]

An upcoming patch is going to require passing the client through
p9_req_put() -> p9_req_free(), but that's awkward with the kref
indirection - so this patch switches to using refcount_t directly.

Link: https://lkml.kernel.org/r/20220704014243.153050-1-kent.overstreet@gmail.com
Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/9p/client.h |  6 +++---
 net/9p/client.c         | 19 ++++++++-----------
 2 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/include/net/9p/client.h b/include/net/9p/client.h
index ec1d1706f43c..c038c2d73dae 100644
--- a/include/net/9p/client.h
+++ b/include/net/9p/client.h
@@ -76,7 +76,7 @@ enum p9_req_status_t {
 struct p9_req_t {
 	int status;
 	int t_err;
-	struct kref refcount;
+	refcount_t refcount;
 	wait_queue_head_t wq;
 	struct p9_fcall tc;
 	struct p9_fcall rc;
@@ -227,12 +227,12 @@ struct p9_req_t *p9_tag_lookup(struct p9_client *c, u16 tag);
 
 static inline void p9_req_get(struct p9_req_t *r)
 {
-	kref_get(&r->refcount);
+	refcount_inc(&r->refcount);
 }
 
 static inline int p9_req_try_get(struct p9_req_t *r)
 {
-	return kref_get_unless_zero(&r->refcount);
+	return refcount_inc_not_zero(&r->refcount);
 }
 
 int p9_req_put(struct p9_req_t *r);
diff --git a/net/9p/client.c b/net/9p/client.c
index 8bba0d9cf975..0ee48e8b7220 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -305,7 +305,7 @@ p9_tag_alloc(struct p9_client *c, int8_t type, unsigned int max_size)
 	 * callback), so p9_client_cb eats the second ref there
 	 * as the pointer is duplicated directly by virtqueue_add_sgs()
 	 */
-	refcount_set(&req->refcount.refcount, 2);
+	refcount_set(&req->refcount, 2);
 
 	return req;
 
@@ -370,18 +370,15 @@ static int p9_tag_remove(struct p9_client *c, struct p9_req_t *r)
 	return p9_req_put(r);
 }
 
-static void p9_req_free(struct kref *ref)
-{
-	struct p9_req_t *r = container_of(ref, struct p9_req_t, refcount);
-
-	p9_fcall_fini(&r->tc);
-	p9_fcall_fini(&r->rc);
-	kmem_cache_free(p9_req_cache, r);
-}
-
 int p9_req_put(struct p9_req_t *r)
 {
-	return kref_put(&r->refcount, p9_req_free);
+	if (refcount_dec_and_test(&r->refcount)) {
+		p9_fcall_fini(&r->tc);
+		p9_fcall_fini(&r->rc);
+		kmem_cache_free(p9_req_cache, r);
+		return 1;
+	}
+	return 0;
 }
 EXPORT_SYMBOL(p9_req_put);
 
-- 
2.35.1



