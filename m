Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3C11604131
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232191AbiJSKkT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbiJSKj1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:39:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD7F15627F;
        Wed, 19 Oct 2022 03:18:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B89DB823C8;
        Wed, 19 Oct 2022 08:55:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98EB4C433D6;
        Wed, 19 Oct 2022 08:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169703;
        bh=4skOxrJgX4AfIkPHOIg87BN7DK+WMUVYiGNtnr5td+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=093RJ8ktsEQMpHiblS+LnEmpjvMXUc2QOaZ4OJ6G3IvjWvrocnaQJC7EmmapVvHPX
         +Fl81fWxUiRslFpOIMv2+NItddXdxH3D3QOR4LmP9k36QfYAWgW0L+56I0tjSNasqc
         WhSXxUrHiiNJ65DXGlMB0h3q8QDnYnQrNF8ySN2o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+5ea725c25d06fb9114c4@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 343/862] net/ieee802154: reject zero-sized raw_sendmsg()
Date:   Wed, 19 Oct 2022 10:27:10 +0200
Message-Id: <20221019083305.219389595@linuxfoundation.org>
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
index 7889e1ef7fad..cbd0e2ac4ffe 100644
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



