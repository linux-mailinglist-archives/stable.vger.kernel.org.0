Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6704055CBB2
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbiF1Itk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 04:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbiF1Itk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 04:49:40 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC2352EA39
        for <stable@vger.kernel.org>; Tue, 28 Jun 2022 01:49:38 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 865DA21EBF;
        Tue, 28 Jun 2022 08:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1656406177; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pF69XwnbpK4VE++CiM8R7VAVLHOJvjlbT55UMvt5v0o=;
        b=MHkMbgHr6Tg/p+GbqetCd/OoWZMinZlA3UXg286t5zw7tcZVWK6J48fSTw6o8fhgcO+gao
        IBH1dL/wV3RlVQ/czLrw94gwkFOi3mnnmg+Ot9t+DvWL/sMfHZEzEH8GDttzCtVr5r37gQ
        tu4P05fhASWlpNyv+MfEuhf1dT/WWBk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1656406177;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pF69XwnbpK4VE++CiM8R7VAVLHOJvjlbT55UMvt5v0o=;
        b=kyV35rF0bGwPGbaAZRGYq5nfgqIhRu4eyPOVRq0hk7rc+Jy7IxKlcrOTAIAKUl7BJA0Oh1
        GpLKFU7cOb3ZNNCg==
Received: from localhost.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 81D962C141;
        Tue, 28 Jun 2022 08:49:36 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org
Subject: [PATCH 1/1] bcache: memset on stack variables in bch_btree_check() and bch_sectors_dirty_init()
Date:   Tue, 28 Jun 2022 16:49:33 +0800
Message-Id: <20220628084933.8713-2-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220628084933.8713-1-colyli@suse.de>
References: <20220628084933.8713-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The local variables check_state (in bch_btree_check()) and state (in
bch_sectors_dirty_init()) should be fully filled by 0, because before
allocating them on stack, they were dynamically allocated by kzalloc().

Signed-off-by: Coly Li <colyli@suse.de>
Link: https://lore.kernel.org/r/20220527152818.27545-2-colyli@suse.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 drivers/md/bcache/btree.c     | 1 +
 drivers/md/bcache/writeback.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 2362bb8ef6d1..e136d6edc1ed 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -2017,6 +2017,7 @@ int bch_btree_check(struct cache_set *c)
 	if (c->root->level == 0)
 		return 0;
 
+	memset(&check_state, 0, sizeof(struct btree_check_state));
 	check_state.c = c;
 	check_state.total_threads = bch_btree_chkthread_nr();
 	check_state.key_idx = 0;
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 75b71199800d..d138a2d73240 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -950,6 +950,7 @@ void bch_sectors_dirty_init(struct bcache_device *d)
 		return;
 	}
 
+	memset(&state, 0, sizeof(struct bch_dirty_init_state));
 	state.c = c;
 	state.d = d;
 	state.total_threads = bch_btre_dirty_init_thread_nr();
-- 
2.35.3

