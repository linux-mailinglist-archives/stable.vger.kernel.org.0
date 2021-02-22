Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 441B13215FD
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbhBVMPo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:15:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:44932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230337AbhBVMPL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:15:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59F6464F13;
        Mon, 22 Feb 2021 12:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613996065;
        bh=AXRPNFRFsMVy5AkzagRtajrSyqb8LlOJOicep2zvSFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IZ2QxKLufRnDXGJ8R7DnrP4u/e7F6DzoMEAKMDB+V4rUSxj5eCJ2E5MiEkRIwTvDJ
         whoSFvaOu6GRKzJ/tVYCtv2EhXq2B6mcmW3qE5Rp+T6L1V2bkEUPvakHTZ7dOe6c6V
         G5L9pH7IzDovlFwP9nqZ1Rc5RF2Ysbdm4e9MhTVE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, wenxu <wenxu@ucloud.cn>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 09/29] net/sched: fix miss init the mru in qdisc_skb_cb
Date:   Mon, 22 Feb 2021 13:13:03 +0100
Message-Id: <20210222121021.654740545@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121019.444399883@linuxfoundation.org>
References: <20210222121019.444399883@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

[ Upstream commit aadaca9e7c392dbf877af8cefb156199f1a67bbe ]

The mru in the qdisc_skb_cb should be init as 0. Only defrag packets in the
act_ct will set the value.

Fixes: 038ebb1a713d ("net/sched: act_ct: fix miss set mru for ovs after defrag in act_ct")
Signed-off-by: wenxu <wenxu@ucloud.cn>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index da85cb9398693..210d0fce58e17 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3867,6 +3867,7 @@ sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
 		return skb;
 
 	/* qdisc_skb_cb(skb)->pkt_len was already set by the caller. */
+	qdisc_skb_cb(skb)->mru = 0;
 	mini_qdisc_bstats_cpu_update(miniq, skb);
 
 	switch (tcf_classify(skb, miniq->filter_list, &cl_res, false)) {
@@ -4950,6 +4951,7 @@ sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
 	}
 
 	qdisc_skb_cb(skb)->pkt_len = skb->len;
+	qdisc_skb_cb(skb)->mru = 0;
 	skb->tc_at_ingress = 1;
 	mini_qdisc_bstats_cpu_update(miniq, skb);
 
-- 
2.27.0



