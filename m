Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9CD14F25B8
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232531AbiDEHvT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233597AbiDEHsH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:48:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24FEA2AC;
        Tue,  5 Apr 2022 00:46:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B42EB616BF;
        Tue,  5 Apr 2022 07:46:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4F7EC340EE;
        Tue,  5 Apr 2022 07:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144768;
        bh=FUcnqxzjXH5u3vbw4nDqrygn9TouK/7YERh2EEo0v3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eDuzgrhlNeklkZzJdNsL+RRPXrVCFmpVD0vpiONQz65KGU2gLUyV+TA3KITRTq4Kh
         v8pMdfoojP1gJg+Yd47V5tRaKNkTKgO/ytcSYoEfff5a3cer1HK0+P2lERJ3BegWWk
         3u4EBi7GEeL/bQL4uTQeheynNLpWYoxxws106m3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mingzhe Zou <mingzhe.zou@easystack.cn>,
        Coly Li <colyli@suse.de>
Subject: [PATCH 5.17 0164/1126] bcache: fixup multiple threads crash
Date:   Tue,  5 Apr 2022 09:15:11 +0200
Message-Id: <20220405070412.409301981@linuxfoundation.org>
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

From: Mingzhe Zou <mingzhe.zou@easystack.cn>

commit 887554ab96588de2917b6c8c73e552da082e5368 upstream.

When multiple threads to check btree nodes in parallel, the main
thread wait for all threads to stop or CACHE_SET_IO_DISABLE flag:

wait_event_interruptible(check_state->wait,
                         atomic_read(&check_state->started) == 0 ||
                         test_bit(CACHE_SET_IO_DISABLE, &c->flags));

However, the bch_btree_node_read and bch_btree_node_read_done
maybe call bch_cache_set_error, then the CACHE_SET_IO_DISABLE
will be set. If the flag already set, the main thread return
error. At the same time, maybe some threads still running and
read NULL pointer, the kernel will crash.

This patch change the event wait condition, the main thread must
wait for all threads to stop.

Fixes: 8e7102273f597 ("bcache: make bch_btree_check() to be multithreaded")
Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
Cc: stable@vger.kernel.org # v5.7+
Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/bcache/btree.c     |    6 ++++--
 drivers/md/bcache/writeback.c |    6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -2060,9 +2060,11 @@ int bch_btree_check(struct cache_set *c)
 		}
 	}
 
+	/*
+	 * Must wait for all threads to stop.
+	 */
 	wait_event_interruptible(check_state->wait,
-				 atomic_read(&check_state->started) == 0 ||
-				  test_bit(CACHE_SET_IO_DISABLE, &c->flags));
+				 atomic_read(&check_state->started) == 0);
 
 	for (i = 0; i < check_state->total_threads; i++) {
 		if (check_state->infos[i].result) {
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -998,9 +998,11 @@ void bch_sectors_dirty_init(struct bcach
 		}
 	}
 
+	/*
+	 * Must wait for all threads to stop.
+	 */
 	wait_event_interruptible(state->wait,
-		 atomic_read(&state->started) == 0 ||
-		 test_bit(CACHE_SET_IO_DISABLE, &c->flags));
+		 atomic_read(&state->started) == 0);
 
 out:
 	kfree(state);


