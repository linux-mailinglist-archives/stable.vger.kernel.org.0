Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 775B4148094
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389998AbgAXLMa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:12:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:48838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387877AbgAXLMa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:12:30 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37F4120708;
        Fri, 24 Jan 2020 11:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864350;
        bh=79BzIEImy9GA1cgjPsnC4XGO1UI7iCCrXjwEuGO0WPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZM3Q9UwdkmoqWk+l76ibyhuTLEyITnNrNDPtK8uttd+zmD7S/uMt+iR9ZyZ0VHX+H
         tjKFnBKCjSNCcwu5Aikc52C+mxjqy5pZRMRXCg8UstUNzrEywYCwgSj0ckcnA5+JF+
         E2qnDndhgHsosJTZe/un441EfYMLfH6QfL2ZjhSs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 242/639] netfilter: nft_set_hash: bogus element self comparison from deactivation path
Date:   Fri, 24 Jan 2020 10:26:52 +0100
Message-Id: <20200124093117.120261624@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit a01cbae57ec29b161d42ee1caa4ffffda5d519c2 ]

Use the element from the loop iteration, not the same element we want to
deactivate otherwise this branch always evaluates true.

Fixes: 6c03ae210ce3 ("netfilter: nft_set_hash: add non-resizable hashtable implementation")
Reported-by: Florian Westphal <fw@strlen.de>
Tested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 8dde4bfe8b8a4..05118e03c3e48 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -555,7 +555,7 @@ static void *nft_hash_deactivate(const struct net *net,
 
 	hash = nft_jhash(set, priv, &this->ext);
 	hlist_for_each_entry(he, &priv->table[hash], node) {
-		if (!memcmp(nft_set_ext_key(&this->ext), &elem->key.val,
+		if (!memcmp(nft_set_ext_key(&he->ext), &elem->key.val,
 			    set->klen) &&
 		    nft_set_elem_active(&he->ext, genmask)) {
 			nft_set_elem_change_active(net, set, &he->ext);
-- 
2.20.1



