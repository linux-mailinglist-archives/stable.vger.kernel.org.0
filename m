Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B892345C51C
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:52:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352537AbhKXNzC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:55:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:42104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354769AbhKXNxA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:53:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1EC15613B3;
        Wed, 24 Nov 2021 13:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759125;
        bh=ee/oxOG10r60OQVE/MVsKaIcAHlITCdIz3QlzjqV2sE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ubHhDJZzPrmGxCFJTnzE5mZUruo9cfaoU2Y7UaQig/S1lASaZfkY6skepu3py7xE1
         tVfPdKTnqEUiOPMupoTTakVWGtK5o96c8Xe8GtqiIZYIt/zZY3sQnaMyBsTP/rAJtk
         pcnhiat7CzXrjp8lDGBBDf8XHaHHJSChsZs7NNp4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 140/279] udp: Validate checksum in udp_read_sock()
Date:   Wed, 24 Nov 2021 12:57:07 +0100
Message-Id: <20211124115723.620795552@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

[ Upstream commit 099f896f498a2b26d84f4ddae039b2c542c18b48 ]

It turns out the skb's in sock receive queue could have bad checksums, as
both ->poll() and ->recvmsg() validate checksums. We have to do the same
for ->read_sock() path too before they are redirected in sockmap.

Fixes: d7f571188ecf ("udp: Implement ->read_sock() for sockmap")
Reported-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20211115044006.26068-1-xiyou.wangcong@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 2fffcf2b54f3f..2ce3fca545d37 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1808,6 +1808,17 @@ int udp_read_sock(struct sock *sk, read_descriptor_t *desc,
 		skb = skb_recv_udp(sk, 0, 1, &err);
 		if (!skb)
 			return err;
+
+		if (udp_lib_checksum_complete(skb)) {
+			__UDP_INC_STATS(sock_net(sk), UDP_MIB_CSUMERRORS,
+					IS_UDPLITE(sk));
+			__UDP_INC_STATS(sock_net(sk), UDP_MIB_INERRORS,
+					IS_UDPLITE(sk));
+			atomic_inc(&sk->sk_drops);
+			kfree_skb(skb);
+			continue;
+		}
+
 		used = recv_actor(desc, skb, 0, skb->len);
 		if (used <= 0) {
 			if (!copied)
-- 
2.33.0



