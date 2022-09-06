Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3D35AECD2
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233245AbiIFOHH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239618AbiIFOFT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:05:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6ED6844D5;
        Tue,  6 Sep 2022 06:45:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D675B818CB;
        Tue,  6 Sep 2022 13:43:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6C47C433C1;
        Tue,  6 Sep 2022 13:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471819;
        bh=jFqC3NCS7H3Pju3ftB1g7imV8vsTqyDWLuDnUeSRCrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h7yjQWuWcJU9hVC2pVkJigeHm85hL/t5YB1NS8L6F2/9nCwz6dtG94/4RHvgj6FI6
         lv/PDtZPXeNvzg4tr5qoovhvkB+bVu1SmW5DkhDy7jP942Zl36avNjDr/pEa2uLDlI
         lGIMMcogZnSTjVaPn64/rc94O+33woldEn51Cq6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 050/155] Revert "sch_cake: Return __NET_XMIT_STOLEN when consuming enqueued skb"
Date:   Tue,  6 Sep 2022 15:29:58 +0200
Message-Id: <20220906132831.536075762@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 0b4f688d53fdc2a731b9d9cdf0c96255bc024ea6 ]

This reverts commit 90fabae8a2c225c4e4936723c38857887edde5cc.

Patch was applied hastily, revert and let the v2 be reviewed.

Fixes: 90fabae8a2c2 ("sch_cake: Return __NET_XMIT_STOLEN when consuming enqueued skb")
Link: https://lore.kernel.org/all/87wnao2ha3.fsf@toke.dk/
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_cake.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index a04928082e4ab..a43a58a73d096 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1713,7 +1713,6 @@ static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	}
 	idx--;
 	flow = &b->flows[idx];
-	ret = NET_XMIT_SUCCESS;
 
 	/* ensure shaper state isn't stale */
 	if (!b->tin_backlog) {
@@ -1772,7 +1771,6 @@ static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 
 		qdisc_tree_reduce_backlog(sch, 1-numsegs, len-slen);
 		consume_skb(skb);
-		ret |= __NET_XMIT_STOLEN;
 	} else {
 		/* not splitting */
 		cobalt_set_enqueue_time(skb, now);
@@ -1906,7 +1904,7 @@ static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		}
 		b->drop_overlimit += dropped;
 	}
-	return ret;
+	return NET_XMIT_SUCCESS;
 }
 
 static struct sk_buff *cake_dequeue_one(struct Qdisc *sch)
-- 
2.35.1



