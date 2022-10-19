Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96D3F603DB7
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbiJSJFt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232735AbiJSJFA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:05:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CFAC80BE7;
        Wed, 19 Oct 2022 01:58:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DDC461852;
        Wed, 19 Oct 2022 08:49:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81EDEC433D7;
        Wed, 19 Oct 2022 08:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169378;
        bh=cWq4xP8NGRkzIrU/H+Fa2QHaOV3Z04pSDgZ9XoUKCLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UKYvfa06Sjz5S6GBvBXckDcLfjfCIDwa3zbhFFofYvpfKOLoUX5a9bu5ILDvVg7kg
         qrGADoG8QkBjmioq8bP3nV4OzbB98iqhpZeFjGSIWtaNRqBSRhbnrmsNPWGSJbtv3k
         paB9al+SYAcqamZF2zofwIevrud9tccc1XHuupWw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hao Sun <sunhao.th@gmail.com>,
        Hou Tao <houtao1@huawei.com>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 254/862] bpf: Propagate error from htab_lock_bucket() to userspace
Date:   Wed, 19 Oct 2022 10:25:41 +0200
Message-Id: <20221019083301.276436592@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index ad09da139589..75f77df910dc 100644
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



