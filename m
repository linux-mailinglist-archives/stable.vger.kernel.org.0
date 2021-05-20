Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 415DB38A4EA
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235222AbhETKKp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:10:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:42254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235812AbhETKJZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:09:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2666F6143D;
        Thu, 20 May 2021 09:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503740;
        bh=bIpcaK3P6O0ixzV5ghQ2/4F0iAIThjp71apwk6nJL28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LOYkgP5k7ILEEgSWZ+oVWwaqP89AE52uXabPBZDSkuAtts2zWfyeZSkHPotdE4zYn
         fSNRBYklXevzQ75LMlhEwL3TkIFhrEH+blcVhhUTQoXOeRvWvfbxr09k+oiv7xVW9r
         5CRFTvfpZ/6kbdroBZ3koxHckNYPeclPd2m0zh/Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 357/425] netfilter: nfnetlink_osf: Fix a missing skb_header_pointer() NULL check
Date:   Thu, 20 May 2021 11:22:06 +0200
Message-Id: <20210520092143.142249257@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
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
index 131f9f8c0b09..917f06110c82 100644
--- a/net/netfilter/nfnetlink_osf.c
+++ b/net/netfilter/nfnetlink_osf.c
@@ -191,6 +191,8 @@ static const struct tcphdr *nf_osf_hdr_ctx_init(struct nf_osf_hdr_ctx *ctx,
 
 		ctx->optp = skb_header_pointer(skb, ip_hdrlen(skb) +
 				sizeof(struct tcphdr), ctx->optsize, opts);
+		if (!ctx->optp)
+			return NULL;
 	}
 
 	return tcp;
-- 
2.30.2



