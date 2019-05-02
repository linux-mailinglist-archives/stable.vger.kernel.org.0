Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4961611EBD
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbfEBPkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:40:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:47190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728414AbfEBP3Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:29:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71C5320B7C;
        Thu,  2 May 2019 15:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556810963;
        bh=NDvVz4P9ETnzeV1AMycWhc1GB4KZgJcAaZTW4I65oug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zPs87VcmCIzl+kLtW3XC8VsOOiokBxP+yejs7TOHWKGC2Yri9HJ69ZJ+++18vZMNu
         bbcKbylAaOjf+zxW8wnyFeOO4euNALhuEONtnfsqokTr2miWMjAdV4MMidE6jRjszB
         3m75qDAAWt6IuT/HTbwG42wZRSW8Aef2GpZIoyW4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?V=C3=A1clav=20Zindulka?= <vaclav.zindulka@tlapnet.cz>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 023/101] netfilter: nft_set_rbtree: check for inactive element after flag mismatch
Date:   Thu,  2 May 2019 17:20:25 +0200
Message-Id: <20190502143341.384720385@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143339.434882399@linuxfoundation.org>
References: <20190502143339.434882399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 05b7639da55f5555b9866a1f4b7e8995232a6323 ]

Otherwise, we hit bogus ENOENT when removing elements.

Fixes: e701001e7cbe ("netfilter: nft_rbtree: allow adjacent intervals with dynamic updates")
Reported-by: Václav Zindulka <vaclav.zindulka@tlapnet.cz>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 net/netfilter/nft_set_rbtree.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index fa61208371f8..321a0036fdf5 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -308,10 +308,6 @@ static void *nft_rbtree_deactivate(const struct net *net,
 		else if (d > 0)
 			parent = parent->rb_right;
 		else {
-			if (!nft_set_elem_active(&rbe->ext, genmask)) {
-				parent = parent->rb_left;
-				continue;
-			}
 			if (nft_rbtree_interval_end(rbe) &&
 			    !nft_rbtree_interval_end(this)) {
 				parent = parent->rb_left;
@@ -320,6 +316,9 @@ static void *nft_rbtree_deactivate(const struct net *net,
 				   nft_rbtree_interval_end(this)) {
 				parent = parent->rb_right;
 				continue;
+			} else if (!nft_set_elem_active(&rbe->ext, genmask)) {
+				parent = parent->rb_left;
+				continue;
 			}
 			nft_rbtree_flush(net, set, rbe);
 			return rbe;
-- 
2.19.1



