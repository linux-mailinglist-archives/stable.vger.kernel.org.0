Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9285F60B23B
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234669AbiJXQns (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234682AbiJXQnX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:43:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB6494E857;
        Mon, 24 Oct 2022 08:29:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A572B81977;
        Mon, 24 Oct 2022 12:41:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55869C433D7;
        Mon, 24 Oct 2022 12:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615316;
        bh=rGbOW2KA5RNMBsAhBoGg/Eu+vDYfU83Edy8YwCl2VV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QMS7f0fUjhKCkXqwvpKnU0x+sL8ZrsiTtYJnng6hS5XQiwnYaPJ+LgY66QeXlNj/x
         GuKOAINo6sxwp+nT4YYzwVjVF6nsIUxBeTCIcXalmcL//ktg1s/kxF0pZ4k5jtv+6c
         udzpiAZPJCF5cHLpxM0WCJUTVm1m0dmiHKJXCba8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+5ea725c25d06fb9114c4@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 205/530] net/ieee802154: reject zero-sized raw_sendmsg()
Date:   Mon, 24 Oct 2022 13:29:09 +0200
Message-Id: <20221024113054.341441619@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
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
index fd5862f9e26a..f160cfc3e8f0 100644
--- a/net/ieee802154/socket.c
+++ b/net/ieee802154/socket.c
@@ -251,6 +251,9 @@ static int raw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
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



