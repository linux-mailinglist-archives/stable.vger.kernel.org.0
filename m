Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 160272F14E7
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732225AbhAKNPE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:15:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:33546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732220AbhAKNPD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:15:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F17212250F;
        Mon, 11 Jan 2021 13:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370862;
        bh=V0YfpRdskoi1wo05n6BbXjnKr81nb/SjTlpJSVCI8tE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GQfm0IJF3Oyn7+rPG+INCPc7IN/Zoak0I5mATVz9czKgHLI1WPKge+gUHvGw/O/9p
         rdUvJ52f1vvz4G6Vy18dJBNIU2gD3M397KQpqgSK75z06iiCaYziODP0SF65UxgpQI
         WydcYHH8tJkLbi6W73u9m+/biDHWXIbYId1I1lXg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+f583ce3d4ddf9836b27a@syzkaller.appspotmail.com,
        William Tu <u9012063@gmail.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Cong Wang <cong.wang@bytedance.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 037/145] erspan: fix version 1 check in gre_parse_header()
Date:   Mon, 11 Jan 2021 14:01:01 +0100
Message-Id: <20210111130050.303429522@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

[ Upstream commit 085c7c4e1c0e50d90b7d90f61a12e12b317a91e2 ]

Both version 0 and version 1 use ETH_P_ERSPAN, but version 0 does not
have an erspan header. So the check in gre_parse_header() is wrong,
we have to distinguish version 1 from version 0.

We can just check the gre header length like is_erspan_type1().

Fixes: cb73ee40b1b3 ("net: ip_gre: use erspan key field for tunnel lookup")
Reported-by: syzbot+f583ce3d4ddf9836b27a@syzkaller.appspotmail.com
Cc: William Tu <u9012063@gmail.com>
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/gre_demux.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/gre_demux.c
+++ b/net/ipv4/gre_demux.c
@@ -128,7 +128,7 @@ int gre_parse_header(struct sk_buff *skb
 	 * to 0 and sets the configured key in the
 	 * inner erspan header field
 	 */
-	if (greh->protocol == htons(ETH_P_ERSPAN) ||
+	if ((greh->protocol == htons(ETH_P_ERSPAN) && hdr_len != 4) ||
 	    greh->protocol == htons(ETH_P_ERSPAN2)) {
 		struct erspan_base_hdr *ershdr;
 


