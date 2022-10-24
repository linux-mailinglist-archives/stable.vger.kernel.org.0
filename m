Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7F8860B244
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234492AbiJXQo2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234910AbiJXQoC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:44:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7635B88A0A;
        Mon, 24 Oct 2022 08:30:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26AE0B81263;
        Mon, 24 Oct 2022 12:08:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA6EC433D7;
        Mon, 24 Oct 2022 12:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613305;
        bh=j5N1rRaBQUoxQJhkXMaxZ4cTTEwSn03DWlIFc7ndmlI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A4TO2c5YJ27pFscnfWER9NfQEZ6Rg0zLWCekDuFn7QXEKzMyKnr2vmoFRCb0fKNmN
         ftXYm/gqB5vVd6H0IPdPso3rp5rbFG1a+socxb1I1vPj852gUP7Aa1nURuUtorDLEt
         C+j2MIoovl4uLpf+FAfQJloRTXbk3tLAlrCn4mGA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+5ea725c25d06fb9114c4@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 085/255] net/ieee802154: reject zero-sized raw_sendmsg()
Date:   Mon, 24 Oct 2022 13:29:55 +0200
Message-Id: <20221024113005.332271068@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
References: <20221024113002.471093005@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 3a4d061c699bd3eedc80dc97a4b2a2e1af83c6f5 ]

syzbot is hitting skb_assert_len() warning at raw_sendmsg() for ieee802154
socket. What commit dc633700f00f726e ("net/af_packet: check len when
min_header_len equals to 0") does also applies to ieee802154 socket.

Link: https://syzkaller.appspot.com/bug?extid=5ea725c25d06fb9114c4
Reported-by: syzbot <syzbot+5ea725c25d06fb9114c4@syzkaller.appspotmail.com>
Fixes: fd1894224407c484 ("bpf: Don't redirect packets with invalid pkt_len")
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/socket.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ieee802154/socket.c b/net/ieee802154/socket.c
index a92b11999e5f..72637d5994d8 100644
--- a/net/ieee802154/socket.c
+++ b/net/ieee802154/socket.c
@@ -252,6 +252,9 @@ static int raw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 		return -EOPNOTSUPP;
 	}
 
+	if (!size)
+		return -EINVAL;
+
 	lock_sock(sk);
 	if (!sk->sk_bound_dev_if)
 		dev = dev_getfirstbyhwtype(sock_net(sk), ARPHRD_IEEE802154);
-- 
2.35.1



