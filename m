Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B511145010
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:43:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387454AbgAVJnd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:43:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:36028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387883AbgAVJn3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:43:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D222424680;
        Wed, 22 Jan 2020 09:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579686209;
        bh=Dp6VtfTwcqViQmhEqLkrbqaVJBMMsF+zh6srQidMBpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RNoMlp7+dserQTbGs1DJHAcIKn9+9AQGCwgLltGVDUjlFsVzcgoRrD5aBJDuh6sZc
         qrWDtxpaa9cljieT6y06ThQTythKzEmoVkRKNH3fO56DNlmZtrfz2UP0KUVYceEF4H
         dl0pDZWNfJmF3pMb5nwC4VP1sS9g0MRWaAULepkQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+76d0b80493ac881ff77b@syzkaller.appspotmail.com,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.19 061/103] netfilter: nft_tunnel: fix null-attribute check
Date:   Wed, 22 Jan 2020 10:29:17 +0100
Message-Id: <20200122092813.029931693@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092803.587683021@linuxfoundation.org>
References: <20200122092803.587683021@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

commit 1c702bf902bd37349f6d91cd7f4b372b1e46d0ed upstream.

else we get null deref when one of the attributes is missing, both
must be non-null.

Reported-by: syzbot+76d0b80493ac881ff77b@syzkaller.appspotmail.com
Fixes: aaecfdb5c5dd8ba ("netfilter: nf_tables: match on tunnel metadata")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nft_tunnel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -56,7 +56,7 @@ static int nft_tunnel_get_init(const str
 	struct nft_tunnel *priv = nft_expr_priv(expr);
 	u32 len;
 
-	if (!tb[NFTA_TUNNEL_KEY] &&
+	if (!tb[NFTA_TUNNEL_KEY] ||
 	    !tb[NFTA_TUNNEL_DREG])
 		return -EINVAL;
 


