Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A28AA561D1B
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 16:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236970AbiF3OMR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 10:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236903AbiF3OLF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 10:11:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55CE95A46B;
        Thu, 30 Jun 2022 06:55:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8379A6204B;
        Thu, 30 Jun 2022 13:55:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B8DC3411E;
        Thu, 30 Jun 2022 13:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656597352;
        bh=8TLd2Le8ME8tL6hO7wkEtHxu0MyfnSARvmpEGWLGYeg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f9k+ZejMff9EOiwisEaQYNpY3OQQJyp/eRjktj1bp7nZvKlLDt/EEOYbhXZur9+5c
         BNF2sqpjcR3pYfxdcS09+eEEWsDqVRnNRU5cReolDEh4nMgNobUd5v8vLH9NpnpaZt
         e2ylUBCBx433AeyDGJSLe9D85/ohh9iyUgtnIxBY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Coly Li <colyli@suse.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.18 3/6] bcache: memset on stack variables in bch_btree_check() and bch_sectors_dirty_init()
Date:   Thu, 30 Jun 2022 15:47:29 +0200
Message-Id: <20220630133230.342925455@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133230.239507521@linuxfoundation.org>
References: <20220630133230.239507521@linuxfoundation.org>
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

From: Coly Li <colyli@suse.de>

commit 7d6b902ea0e02b2a25c480edf471cbaa4ebe6b3c upstream.

The local variables check_state (in bch_btree_check()) and state (in
bch_sectors_dirty_init()) should be fully filled by 0, because before
allocating them on stack, they were dynamically allocated by kzalloc().

Signed-off-by: Coly Li <colyli@suse.de>
Link: https://lore.kernel.org/r/20220527152818.27545-2-colyli@suse.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/bcache/btree.c     |    1 +
 drivers/md/bcache/writeback.c |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -2017,6 +2017,7 @@ int bch_btree_check(struct cache_set *c)
 	if (c->root->level == 0)
 		return 0;
 
+	memset(&check_state, 0, sizeof(struct btree_check_state));
 	check_state.c = c;
 	check_state.total_threads = bch_btree_chkthread_nr();
 	check_state.key_idx = 0;
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -950,6 +950,7 @@ void bch_sectors_dirty_init(struct bcach
 		return;
 	}
 
+	memset(&state, 0, sizeof(struct bch_dirty_init_state));
 	state.c = c;
 	state.d = d;
 	state.total_threads = bch_btre_dirty_init_thread_nr();


