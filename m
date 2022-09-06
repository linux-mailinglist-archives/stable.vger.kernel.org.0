Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDF5E5AEC02
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241516AbiIFOWg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241541AbiIFOUh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:20:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 509048E0D2;
        Tue,  6 Sep 2022 06:52:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 201CDB818B9;
        Tue,  6 Sep 2022 13:43:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75008C433B5;
        Tue,  6 Sep 2022 13:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471804;
        bh=qYj6QWQQFcsSmu0dE62oXSFsUmz/XNnl8T4thWZSX88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BL3SnSqD4kk//AWPj//O+8EogBCKlMHIVW+BteSsUWIeJl+7NUBNSRmG7irh7WUug
         yRhyLMX6OCrUqwGW8zsZymqXIDHHW5bhhZ8FTzK04sLdKfojchIOpGi+xJv3TdJovQ
         FV+qLu+48C7WrguoBcpcRXDFgbTDBg3Rvb/rm2DY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yongqing Li <liyongqing@bytedance.com>,
        Xin Yin <yinxin.x@bytedance.com>,
        David Howells <dhowells@redhat.com>,
        Jeffle Xu <jefflexu@linux.alibaba.com>,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 045/155] cachefiles: make on-demand request distribution fairer
Date:   Tue,  6 Sep 2022 15:29:53 +0200
Message-Id: <20220906132831.315405017@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
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

From: Xin Yin <yinxin.x@bytedance.com>

[ Upstream commit 1122f40072731525c06b1371cfa30112b9b54d27 ]

For now, enqueuing and dequeuing on-demand requests all start from
idx 0, this makes request distribution unfair. In the weighty
concurrent I/O scenario, the request stored in higher idx will starve.

Searching requests cyclically in cachefiles_ondemand_daemon_read,
makes distribution fairer.

Fixes: c8383054506c ("cachefiles: notify the user daemon when looking up cookie")
Reported-by: Yongqing Li <liyongqing@bytedance.com>
Signed-off-by: Xin Yin <yinxin.x@bytedance.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Jeffle Xu <jefflexu@linux.alibaba.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20220817065200.11543-1-yinxin.x@bytedance.com/ # v1
Link: https://lore.kernel.org/r/20220825020945.2293-1-yinxin.x@bytedance.com/ # v2
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cachefiles/internal.h |  1 +
 fs/cachefiles/ondemand.c | 12 +++++++++---
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/cachefiles/internal.h b/fs/cachefiles/internal.h
index 6cba2c6de2f96..2ad58c4652084 100644
--- a/fs/cachefiles/internal.h
+++ b/fs/cachefiles/internal.h
@@ -111,6 +111,7 @@ struct cachefiles_cache {
 	char				*tag;		/* cache binding tag */
 	refcount_t			unbind_pincount;/* refcount to do daemon unbind */
 	struct xarray			reqs;		/* xarray of pending on-demand requests */
+	unsigned long			req_id_next;
 	struct xarray			ondemand_ids;	/* xarray for ondemand_id allocation */
 	u32				ondemand_id_next;
 };
diff --git a/fs/cachefiles/ondemand.c b/fs/cachefiles/ondemand.c
index 7e1586bd5cf34..0254ed39f68ce 100644
--- a/fs/cachefiles/ondemand.c
+++ b/fs/cachefiles/ondemand.c
@@ -242,14 +242,19 @@ ssize_t cachefiles_ondemand_daemon_read(struct cachefiles_cache *cache,
 	unsigned long id = 0;
 	size_t n;
 	int ret = 0;
-	XA_STATE(xas, &cache->reqs, 0);
+	XA_STATE(xas, &cache->reqs, cache->req_id_next);
 
 	/*
-	 * Search for a request that has not ever been processed, to prevent
-	 * requests from being processed repeatedly.
+	 * Cyclically search for a request that has not ever been processed,
+	 * to prevent requests from being processed repeatedly, and make
+	 * request distribution fair.
 	 */
 	xa_lock(&cache->reqs);
 	req = xas_find_marked(&xas, UINT_MAX, CACHEFILES_REQ_NEW);
+	if (!req && cache->req_id_next > 0) {
+		xas_set(&xas, 0);
+		req = xas_find_marked(&xas, cache->req_id_next - 1, CACHEFILES_REQ_NEW);
+	}
 	if (!req) {
 		xa_unlock(&cache->reqs);
 		return 0;
@@ -264,6 +269,7 @@ ssize_t cachefiles_ondemand_daemon_read(struct cachefiles_cache *cache,
 	}
 
 	xas_clear_mark(&xas, CACHEFILES_REQ_NEW);
+	cache->req_id_next = xas.xa_index + 1;
 	xa_unlock(&cache->reqs);
 
 	id = xas.xa_index;
-- 
2.35.1



