Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F110383493
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241332AbhEQPKm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:10:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:47748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241833AbhEQPG4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:06:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63EB361C25;
        Mon, 17 May 2021 14:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261756;
        bh=ZFAuTJO59UT5twKnCexyk2VzbleOLvEsm/3HKj7R0A8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UPDEJ7pC68gMwUta+UKkqxjXqKUULEzpbUqtQMLEK3Q6cZ48jJ5NUD3IuAEU3qILV
         wGbBe9eBGEIO34SbY/BbAwxxK8Zq47dYUuHM4aTHgUyB0CEX6f+qukJEsoCzfq4ib3
         +wjlNxwmLa47KzDIuMHNjrSIx9I+MsGTTcmOvID4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 086/141] netfilter: nfnetlink_osf: Fix a missing skb_header_pointer() NULL check
Date:   Mon, 17 May 2021 16:02:18 +0200
Message-Id: <20210517140245.677516898@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140242.729269392@linuxfoundation.org>
References: <20210517140242.729269392@linuxfoundation.org>
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



