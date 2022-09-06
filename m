Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5C65AE9DB
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240706AbiIFNfn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240583AbiIFNfD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:35:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3935077E96;
        Tue,  6 Sep 2022 06:33:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0967261545;
        Tue,  6 Sep 2022 13:33:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EB49C433D6;
        Tue,  6 Sep 2022 13:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471215;
        bh=IPO4OEvyDdy3tHPDOwpp9sjfmLaGbzGcfmwWeJ72ChE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zmDHK96mjkr8qS2Z5yNskGLPnWJYCNKK678gZhDglw82DYbdfola3ea+XMvX07iL/
         7Y7uT/sd0C1vu+2NXAbujmVsauj+s7NH8kkzsti/StoEo2EyVc+L72xOoyXopO8vFC
         RencoAAIF0pGEvwadjPLPM3sTvhl6xdLx+8ZG3wQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 19/80] Revert "sch_cake: Return __NET_XMIT_STOLEN when consuming enqueued skb"
Date:   Tue,  6 Sep 2022 15:30:16 +0200
Message-Id: <20220906132817.754899160@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132816.936069583@linuxfoundation.org>
References: <20220906132816.936069583@linuxfoundation.org>
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
index 4e380534dbc92..c580139fcedec 100644
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



