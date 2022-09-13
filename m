Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6F775B74C4
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235966AbiIMP3q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236496AbiIMP2w (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:28:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16CAC7E02E;
        Tue, 13 Sep 2022 07:39:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 047D4B8101C;
        Tue, 13 Sep 2022 14:37:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B154C433C1;
        Tue, 13 Sep 2022 14:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079853;
        bh=euhJ2/TXn6UNvyYTMzYZxk1kZI9hiKpv+HLAgyL+0lg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R2M3HDyI4aH2vxucO0PtViyxfsCTOFsDVRnYKiz6E6czfSufd1Cfr+FY9Z90n2tkj
         DeEm4hH4Aao1pMTBYN2qn9Q9uNk2XyQaJMczSe324TSi04MVNeDWkOO+k9Dk+D7edm
         P8cszJHIk+ioEUu/RautAH+Ngc2At1E4UQZIfpeg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Cong Wang <cong.wang@bytedance.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 39/42] sch_sfb: Also store skb len before calling child enqueue
Date:   Tue, 13 Sep 2022 16:08:10 +0200
Message-Id: <20220913140344.361017922@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140342.228397194@linuxfoundation.org>
References: <20220913140342.228397194@linuxfoundation.org>
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

From: Toke Høiland-Jørgensen <toke@toke.dk>

[ Upstream commit 2f09707d0c972120bf794cfe0f0c67e2c2ddb252 ]

Cong Wang noticed that the previous fix for sch_sfb accessing the queued
skb after enqueueing it to a child qdisc was incomplete: the SFB enqueue
function was also calling qdisc_qstats_backlog_inc() after enqueue, which
reads the pkt len from the skb cb field. Fix this by also storing the skb
len, and using the stored value to increment the backlog after enqueueing.

Fixes: 9efd23297cca ("sch_sfb: Don't assume the skb is still around after enqueueing to child")
Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
Acked-by: Cong Wang <cong.wang@bytedance.com>
Link: https://lore.kernel.org/r/20220905192137.965549-1-toke@toke.dk
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_sfb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_sfb.c b/net/sched/sch_sfb.c
index 592189427a09f..2973d82fb21cc 100644
--- a/net/sched/sch_sfb.c
+++ b/net/sched/sch_sfb.c
@@ -281,6 +281,7 @@ static int sfb_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 {
 
 	struct sfb_sched_data *q = qdisc_priv(sch);
+	unsigned int len = qdisc_pkt_len(skb);
 	struct Qdisc *child = q->qdisc;
 	struct tcf_proto *fl;
 	struct sfb_skb_cb cb;
@@ -403,7 +404,7 @@ static int sfb_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	memcpy(&cb, sfb_skb_cb(skb), sizeof(cb));
 	ret = qdisc_enqueue(skb, child, to_free);
 	if (likely(ret == NET_XMIT_SUCCESS)) {
-		qdisc_qstats_backlog_inc(sch, skb);
+		sch->qstats.backlog += len;
 		sch->q.qlen++;
 		increment_qlen(&cb, q);
 	} else if (net_xmit_drop_count(ret)) {
-- 
2.35.1



