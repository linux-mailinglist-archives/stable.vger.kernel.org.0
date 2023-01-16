Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B027C66C950
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233615AbjAPQsA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:48:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233449AbjAPQr3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:47:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 818F325E17
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:35:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F7826106E
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:35:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34317C433D2;
        Mon, 16 Jan 2023 16:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886915;
        bh=o7mhS70DUD+YAEQKk58mifQ3NUsCMi6QC8OdIpNHWxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LDeRahRDfAKQDVgUgcwPzeSyzxIJlLjpbM2/2u4UcMO6yBJ5MJxVvIBi6MNCjvjGw
         YLU4iXQIFIjrC0jZlZFhnmraMfsfKSKjEOnwCx9D4SwDRxsHSkuVm/n/oPi0ljbwwR
         9wA5KuWQQ/AjGfRyyym1KXRAKnMMeUKD8FN1Nx1w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 580/658] net: sched: atm: dont intepret cls results when asked to drop
Date:   Mon, 16 Jan 2023 16:51:08 +0100
Message-Id: <20230116154936.028960039@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit a2965c7be0522eaa18808684b7b82b248515511b ]

If asked to drop a packet via TC_ACT_SHOT it is unsafe to assume
res.class contains a valid pointer
Fixes: b0188d4dbe5f ("[NET_SCHED]: sch_atm: Lindent")

Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_atm.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_atm.c b/net/sched/sch_atm.c
index 6385995dc700..34dd0434d99d 100644
--- a/net/sched/sch_atm.c
+++ b/net/sched/sch_atm.c
@@ -396,10 +396,13 @@ static int atm_tc_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 				result = tcf_classify(skb, fl, &res, true);
 				if (result < 0)
 					continue;
+				if (result == TC_ACT_SHOT)
+					goto done;
+
 				flow = (struct atm_flow_data *)res.class;
 				if (!flow)
 					flow = lookup_flow(sch, res.classid);
-				goto done;
+				goto drop;
 			}
 		}
 		flow = NULL;
-- 
2.35.1



