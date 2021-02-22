Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C266532163B
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbhBVMTv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:19:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:45330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230467AbhBVMQz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:16:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FC4F64F02;
        Mon, 22 Feb 2021 12:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613996190;
        bh=cMl5WW+fx0wsyVjr5ALt3IWST3sUbg5i4u6+TD+SagY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xhRHknEt9Ftfa0Ww1uiw4VGjwEVsMCEoWEFEpaW8MACQQnvWktGPyVjIEL3uARw6C
         ArISF4eZrvG2HHK+T8gPokhDKnQ2kCOKGYo9Rf/7AX0rFhuXOwNtPl5gdP4plgW+Be
         8RmrEjYdhBVSDtoUsYBxYgrF3XQ0McmjzHq7a7Q4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 22/50] netfilter: conntrack: skip identical origin tuple in same zone only
Date:   Mon, 22 Feb 2021 13:13:13 +0100
Message-Id: <20210222121024.266130513@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121019.925481519@linuxfoundation.org>
References: <20210222121019.925481519@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 07998281c268592963e1cd623fe6ab0270b65ae4 ]

The origin skip check needs to re-test the zone. Else, we might skip
a colliding tuple in the reply direction.

This only occurs when using 'directional zones' where origin tuples
reside in different zones but the reply tuples share the same zone.

This causes the new conntrack entry to be dropped at confirmation time
because NAT clash resolution was elided.

Fixes: 4e35c1cb9460240 ("netfilter: nf_nat: skip nat clash resolution for same-origin entries")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index ad1da6b2fb607..1dceda3c0e759 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1063,7 +1063,8 @@ nf_conntrack_tuple_taken(const struct nf_conntrack_tuple *tuple,
 			 * Let nf_ct_resolve_clash() deal with this later.
 			 */
 			if (nf_ct_tuple_equal(&ignored_conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
-					      &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple))
+					      &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple) &&
+					      nf_ct_zone_equal(ct, zone, IP_CT_DIR_ORIGINAL))
 				continue;
 
 			NF_CT_STAT_INC_ATOMIC(net, found);
-- 
2.27.0



