Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5916D4AC3
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234212AbjDCOuO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234225AbjDCOt6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:49:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1BDE28EAB
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:49:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D2E4B81D72
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:48:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA46BC4339E;
        Mon,  3 Apr 2023 14:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533331;
        bh=StEsn3dk1QY88RqxVzwXk0GuyPKH/bC1cwTvloS4JQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kCHALHfGWNqxPcGoSrmBr+c++dfIlEqpsJ5zhbskd2Yc0dDKWDMlAm8PD6bl1Qj39
         +upzWbg6gIZvAJocF84LyjLYvHcrmD1Gf8Emokn7ECtZFbGaIRGqNaL7HBWJoQ47Lm
         S7vkxEBARs0zxhER6iAOmN29llzmPt9B5zTvVeAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.2 142/187] io_uring: fix poll/netmsg alloc caches
Date:   Mon,  3 Apr 2023 16:09:47 +0200
Message-Id: <20230403140420.680737304@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
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
 io_uring/alloc_cache.h |    1 +
 1 file changed, 1 insertion(+)

--- a/io_uring/alloc_cache.h
+++ b/io_uring/alloc_cache.h
@@ -27,6 +27,7 @@ static inline struct io_cache_entry *io_
 		struct hlist_node *node = cache->list.first;
 
 		hlist_del(node);
+		cache->nr_cached--;
 		return container_of(node, struct io_cache_entry, node);
 	}
 


