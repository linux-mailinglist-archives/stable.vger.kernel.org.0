Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5DDC6D49B9
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233790AbjDCOkp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233787AbjDCOkp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:40:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D27017AD2
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:40:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A37D561ECF
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:40:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4219C433D2;
        Mon,  3 Apr 2023 14:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532842;
        bh=vHcwWKY9sH4v3yCk8cIyeu5kmJFd+Yo66wMSja2becM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ipS3Rkp0AiwC75oueW6LKAOex2SN6UJpGkYfkEEbSKJPMtzlLwjMEWikpAOWc5XAX
         PhbmiEZJ0khnZbfSyu/OWOTiIUFmv+Y+7tGwvVJ26DIRi1KjGr9hMZkQ58e49mlzy3
         YyNEO6RnYzP03bfiCCGhbYCHDkQiCPLlFsdnciHM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 137/181] io_uring: fix poll/netmsg alloc caches
Date:   Mon,  3 Apr 2023 16:09:32 +0200
Message-Id: <20230403140419.520573862@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit fd30d1cdcc4ff405fc54765edf2e11b03f2ed4f3 upstream.

We increase cache->nr_cached when we free into the cache but don't
decrease when we take from it, so in some time we'll get an empty
cache with cache->nr_cached larger than IO_ALLOC_CACHE_MAX, that fails
io_alloc_cache_put() and effectively disables caching.

Fixes: 9b797a37c4bd8 ("io_uring: add abstraction around apoll cache")
Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/alloc_cache.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/alloc_cache.h b/io_uring/alloc_cache.h
index 729793ae9712..c2cde88aeed5 100644
--- a/io_uring/alloc_cache.h
+++ b/io_uring/alloc_cache.h
@@ -27,6 +27,7 @@ static inline struct io_cache_entry *io_alloc_cache_get(struct io_alloc_cache *c
 		struct hlist_node *node = cache->list.first;
 
 		hlist_del(node);
+		cache->nr_cached--;
 		return container_of(node, struct io_cache_entry, node);
 	}
 
-- 
2.40.0



