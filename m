Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22CB660868E
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231538AbiJVHuz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:50:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231800AbiJVHtK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:49:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B869263B6E;
        Sat, 22 Oct 2022 00:46:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 076A1B82E0A;
        Sat, 22 Oct 2022 07:43:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C927C433D6;
        Sat, 22 Oct 2022 07:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424635;
        bh=tT3anD75WlhdKhqutw+l0nDcDEE3SDZgAaFmH8y3fag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P1YRs7C1/pXV7rzP35otxYKrd7Yh2GKOz8rhFyJ3ikJwKzfYtkZQLUdRQymRqLYRG
         j0utn4lc2ziQdiVJGJV0/MSROQPKuhfunQkfgh1FDjqnmONctTMjkSYgcM7qrrEO4J
         lefCFDMKIqofZSrW24cpMjI0c8CuD8oKvP8gM5NA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hao Sun <sunhao.th@gmail.com>,
        Hou Tao <houtao1@huawei.com>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 219/717] bpf: Propagate error from htab_lock_bucket() to userspace
Date:   Sat, 22 Oct 2022 09:21:38 +0200
Message-Id: <20221022072453.934425338@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit 66a7a92e4d0d091e79148a4c6ec15d1da65f4280 ]

In __htab_map_lookup_and_delete_batch() if htab_lock_bucket() returns
-EBUSY, it will go to next bucket. Going to next bucket may not only
skip the elements in current bucket silently, but also incur
out-of-bound memory access or expose kernel memory to userspace if
current bucket_cnt is greater than bucket_size or zero.

Fixing it by stopping batch operation and returning -EBUSY when
htab_lock_bucket() fails, and the application can retry or skip the busy
batch as needed.

Fixes: 20b6cc34ea74 ("bpf: Avoid hashtab deadlock with map_locked")
Reported-by: Hao Sun <sunhao.th@gmail.com>
Signed-off-by: Hou Tao <houtao1@huawei.com>
Link: https://lore.kernel.org/r/20220831042629.130006-3-houtao@huaweicloud.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/hashtab.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 717f85973443..e20f3d0e3fc7 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -1704,8 +1704,11 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
 	/* do not grab the lock unless need it (bucket_cnt > 0). */
 	if (locked) {
 		ret = htab_lock_bucket(htab, b, batch, &flags);
-		if (ret)
-			goto next_batch;
+		if (ret) {
+			rcu_read_unlock();
+			bpf_enable_instrumentation();
+			goto after_loop;
+		}
 	}
 
 	bucket_cnt = 0;
-- 
2.35.1



