Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9C063835B7
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234804AbhEQPYG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:24:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:57498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244526AbhEQPVO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:21:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 935E361C83;
        Mon, 17 May 2021 14:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262070;
        bh=ZFAuTJO59UT5twKnCexyk2VzbleOLvEsm/3HKj7R0A8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qSRNmLx9tKYwJqv0Ewckrg6rUggF4Al+VE2mEpVyNkty7Opd2Yhub/WA0obNnMNuW
         f1x/MAs8FhfMqODEzifmumrb9RtEh7dSUKpDKmiLczN2GLnqTfv0rSyHNds/fzSwzv
         HkICuHAE0gU/R4vDBqu3pHNz7fxTJTBw6nsC+U7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 211/329] netfilter: nfnetlink_osf: Fix a missing skb_header_pointer() NULL check
Date:   Mon, 17 May 2021 16:02:02 +0200
Message-Id: <20210517140309.279284219@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 5e024c325406470d1165a09c6feaf8ec897936be ]

Do not assume that the tcph->doff field is correct when parsing for TCP
options, skb_header_pointer() might fail to fetch these bits.

Fixes: 11eeef41d5f6 ("netfilter: passive OS fingerprint xtables match")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nfnetlink_osf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
index 916a3c7f9eaf..79fbf37291f3 100644
--- a/net/netfilter/nfnetlink_osf.c
+++ b/net/netfilter/nfnetlink_osf.c
@@ -186,6 +186,8 @@ static const struct tcphdr *nf_osf_hdr_ctx_init(struct nf_osf_hdr_ctx *ctx,
 
 		ctx->optp = skb_header_pointer(skb, ip_hdrlen(skb) +
 				sizeof(struct tcphdr), ctx->optsize, opts);
+		if (!ctx->optp)
+			return NULL;
 	}
 
 	return tcp;
-- 
2.30.2



