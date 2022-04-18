Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA4675050A1
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238774AbiDRM0w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:26:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238773AbiDRM0N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:26:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E50CBC35;
        Mon, 18 Apr 2022 05:20:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A48B60F01;
        Mon, 18 Apr 2022 12:20:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23EE0C385A7;
        Mon, 18 Apr 2022 12:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284402;
        bh=EawFOWZdFf7a32J8RZPjASL5p+3DXEbvcgrIUmEARdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UsTZti9y0QlFTG+Dp9CLr0ZUSTvqim0JX1aLgH5nzaQgnaQrlPGTljWqqRtCbh4b4
         eHDcKk64y2tLzSQ4M/trTvv5mUPS89DO2WEPIVKrW0C03kCh7npIwt8+IDzW2J5YJm
         cPVUUxDvbespssBYaMVFDR7hpgfhjGpyutHSKfns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Benedikt Spranger <b.spranger@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 086/219] net/sched: taprio: Check if socket flags are valid
Date:   Mon, 18 Apr 2022 14:10:55 +0200
Message-Id: <20220418121208.859257415@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benedikt Spranger <b.spranger@linutronix.de>

[ Upstream commit e8a64bbaaad1f6548cec5508297bc6d45e8ab69e ]

A user may set the SO_TXTIME socket option to ensure a packet is send
at a given time. The taprio scheduler has to confirm, that it is allowed
to send a packet at that given time, by a check against the packet time
schedule. The scheduler drop the packet, if the gates are closed at the
given send time.

The check, if SO_TXTIME is set, may fail since sk_flags are part of an
union and the union is used otherwise. This happen, if a socket is not
a full socket, like a request socket for example.

Add a check to verify, if the union is used for sk_flags.

Fixes: 4cfd5779bd6e ("taprio: Add support for txtime-assist mode")
Signed-off-by: Benedikt Spranger <b.spranger@linutronix.de>
Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_taprio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 377f896bdedc..b9c71a304d39 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -417,7 +417,8 @@ static int taprio_enqueue_one(struct sk_buff *skb, struct Qdisc *sch,
 {
 	struct taprio_sched *q = qdisc_priv(sch);
 
-	if (skb->sk && sock_flag(skb->sk, SOCK_TXTIME)) {
+	/* sk_flags are only safe to use on full sockets. */
+	if (skb->sk && sk_fullsock(skb->sk) && sock_flag(skb->sk, SOCK_TXTIME)) {
 		if (!is_valid_interval(skb, sch))
 			return qdisc_drop(skb, sch, to_free);
 	} else if (TXTIME_ASSIST_IS_ENABLED(q->flags)) {
-- 
2.35.1



