Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28F434A41F1
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358986AbiAaLHX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:07:23 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38682 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358994AbiAaLFV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:05:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1207360B98;
        Mon, 31 Jan 2022 11:05:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0558BC340EF;
        Mon, 31 Jan 2022 11:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627120;
        bh=hRGw969o3xfx3kaJXxvceU8n0eam0mIvnot3klzJX4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YkZSV1x0U2qugzhKdw2ieREP3/qwmM4D5ggY8m//DZdbjNcUecLBEbov9uzIY2Yc/
         HTnA9RgoqgCyue1AP8/RmAS1rTH7RtVYsh+8zaFzNn8cT2MgAj6NBJ/81Bv42eUSaN
         DuYh8Yqs2pZnpGynlu8q26Cf7Znwue4QGTCKBoVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Yajun Deng <yajun.deng@linux.dev>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 081/100] net: ipv4: Fix the warning for dereference
Date:   Mon, 31 Jan 2022 11:56:42 +0100
Message-Id: <20220131105223.166114763@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105220.424085452@linuxfoundation.org>
References: <20220131105220.424085452@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yajun Deng <yajun.deng@linux.dev>

[ Upstream commit 1b9fbe813016b08e08b22ddba4ddbf9cb1b04b00 ]

Add a if statements to avoid the warning.

Dan Carpenter report:
The patch faf482ca196a: "net: ipv4: Move ip_options_fragment() out of
loop" from Aug 23, 2021, leads to the following Smatch complaint:

    net/ipv4/ip_output.c:833 ip_do_fragment()
    warn: variable dereferenced before check 'iter.frag' (see line 828)

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: faf482ca196a ("net: ipv4: Move ip_options_fragment() out of loop")
Link: https://lore.kernel.org/netdev/20210830073802.GR7722@kadam/T/#t
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_output.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index fb91a466b2d34..e77afaecc9818 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -833,7 +833,9 @@ int ip_do_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 
 		/* Everything is OK. Generate! */
 		ip_fraglist_init(skb, iph, hlen, &iter);
-		ip_options_fragment(iter.frag);
+
+		if (iter.frag)
+			ip_options_fragment(iter.frag);
 
 		for (;;) {
 			/* Prepare header of the next frame,
-- 
2.34.1



