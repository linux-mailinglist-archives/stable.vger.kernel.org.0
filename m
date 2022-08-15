Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF66B594C1E
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350081AbiHPAdS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354298AbiHPAbf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:31:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D921D31ED3;
        Mon, 15 Aug 2022 13:36:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26CAB611FC;
        Mon, 15 Aug 2022 20:36:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14268C433C1;
        Mon, 15 Aug 2022 20:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595795;
        bh=gMt0TTa4Z8LWwPz7TuWcnuLI0xUXnFXP9Jz18Ps5+Jw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eDJZIvhkLygLNLLFTgETO271nLId/hG0HS98rLCxJGbMVZKHpn34LZd3xxPGAvNC4
         sB6pDHcj8Th1Peu2ZOgIOuY5dh5ZgQ7WJRYAoc91/cZwcCGK9HCLCwbKVPevwZKFXu
         lnuOkWmMKZd92n/5vt/yRyU8Gww+6CYKzdrJcU9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0878/1157] nbd: add missing definition of pr_fmt
Date:   Mon, 15 Aug 2022 20:03:54 +0200
Message-Id: <20220815180514.562444108@linuxfoundation.org>
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

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit bc9da6dd0630efd81b5c72ff6fa0169aa029a73f ]

commit 1243172d5894 ("nbd: use pr_err to output error message") tries
to define pr_fmt and use short pr_err() to output error message,
however, the definition is missed.

This patch also remove existing "nbd:" inside pr_err().

Fixes: 1243172d5894 ("nbd: use pr_err to output error message")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Link: https://lore.kernel.org/r/20220723082427.3890655-1-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/nbd.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 07f3c139a3d7..20e9c53eec53 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -11,6 +11,8 @@
  * (part of code stolen from loop.c)
  */
 
+#define pr_fmt(fmt) "nbd: " fmt
+
 #include <linux/major.h>
 
 #include <linux/blkdev.h>
@@ -1951,7 +1953,7 @@ static int nbd_genl_connect(struct sk_buff *skb, struct genl_info *info)
 			     test_bit(NBD_DISCONNECT_REQUESTED, &nbd->flags)) ||
 			    !refcount_inc_not_zero(&nbd->refs)) {
 				mutex_unlock(&nbd_index_mutex);
-				pr_err("nbd: device at index %d is going down\n",
+				pr_err("device at index %d is going down\n",
 					index);
 				return -EINVAL;
 			}
@@ -1962,7 +1964,7 @@ static int nbd_genl_connect(struct sk_buff *skb, struct genl_info *info)
 	if (!nbd) {
 		nbd = nbd_dev_add(index, 2);
 		if (IS_ERR(nbd)) {
-			pr_err("nbd: failed to add new device\n");
+			pr_err("failed to add new device\n");
 			return PTR_ERR(nbd);
 		}
 	}
-- 
2.35.1



