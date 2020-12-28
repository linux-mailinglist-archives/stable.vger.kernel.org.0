Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79C062E64DD
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390868AbgL1Nhx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:37:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:37858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390866AbgL1Nhx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:37:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3EA4120867;
        Mon, 28 Dec 2020 13:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162657;
        bh=p/BJ0o7UsJnvZ0g+1SPqi4lJ3O5AzAMNsR8petuvtI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bRCbo8iry8UDtHgWDrnJ04R1I+QOmtXIaGJJBtGqpljkIXPFXbx0MZbVHvMHfcls5
         VYObNLZwH+LVFMih08Xp9xtRPgl4JwCyQK5w+P909EsaX0VPLUqhBEdu+GvqdYlBKV
         sOU/TCWLeUXUFOxOJ3tIdNpqCh4tz8tF5dDX4N88=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Brett Mastbergen <brett.mastbergen@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 028/453] netfilter: nft_ct: Remove confirmation check for NFT_CT_ID
Date:   Mon, 28 Dec 2020 13:44:24 +0100
Message-Id: <20201228124938.612868959@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brett Mastbergen <brett.mastbergen@gmail.com>

[ Upstream commit 2d94b20b95b009eec1a267dcf026b01af627c0cd ]

Since commit 656c8e9cc1ba ("netfilter: conntrack: Use consistent ct id
hash calculation") the ct id will not change from initialization to
confirmation.  Removing the confirmation check allows for things like
adding an element to a 'typeof ct id' set in prerouting upon reception
of the first packet of a new connection, and then being able to
reference that set consistently both before and after the connection
is confirmed.

Fixes: 656c8e9cc1ba ("netfilter: conntrack: Use consistent ct id hash calculation")
Signed-off-by: Brett Mastbergen <brett.mastbergen@gmail.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_ct.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 46ca8bcca1bd5..2042c6f4629cc 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -177,8 +177,6 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
 	}
 #endif
 	case NFT_CT_ID:
-		if (!nf_ct_is_confirmed(ct))
-			goto err;
 		*dest = nf_ct_get_id(ct);
 		return;
 	default:
-- 
2.27.0



