Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F98434CAB9
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234756AbhC2Ijn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:39:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:54978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234559AbhC2IgP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:36:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BD7761A0A;
        Mon, 29 Mar 2021 08:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006952;
        bh=Jvs8TPoftQgiAHSGIQRTNmP/+YFUSdSAJ0TJq4mD6Ec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N0fVZ4yWanetQBmnfp4O9b6OfgIo6oGP43VYqJ/mAM5OhnkjdIwkH4hPkpALVglSW
         wgRAzvbD+sbj2RmD/AX/Zn7VS+6ldUt8EXoB9wTjNtiJo+0O8vx0mj3RX+waxEohdv
         KmkBFSzTBNVfvHh2ilWF0G42J7stA/qznDmnVs6I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 166/254] netfilter: nftables: report EOPNOTSUPP on unsupported flowtable flags
Date:   Mon, 29 Mar 2021 09:58:02 +0200
Message-Id: <20210329075638.630914350@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 7e6136f1b7272b2202817cff37ada355eb5e6784 ]

Error was not set accordingly.

Fixes: 8bb69f3b2918 ("netfilter: nf_tables: add flowtable offload control plane")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8ee9f40cc0ea..2aae0df0d70d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6929,8 +6929,10 @@ static int nf_tables_newflowtable(struct net *net, struct sock *nlsk,
 	if (nla[NFTA_FLOWTABLE_FLAGS]) {
 		flowtable->data.flags =
 			ntohl(nla_get_be32(nla[NFTA_FLOWTABLE_FLAGS]));
-		if (flowtable->data.flags & ~NFT_FLOWTABLE_MASK)
+		if (flowtable->data.flags & ~NFT_FLOWTABLE_MASK) {
+			err = -EOPNOTSUPP;
 			goto err3;
+		}
 	}
 
 	write_pnet(&flowtable->data.net, net);
-- 
2.30.1



