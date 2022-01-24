Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0F38499B15
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:59:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1453934AbiAXVtd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:49:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1456648AbiAXVjm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:39:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EBFFC0612B2;
        Mon, 24 Jan 2022 12:25:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6D70B81218;
        Mon, 24 Jan 2022 20:25:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E40B4C340E5;
        Mon, 24 Jan 2022 20:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055933;
        bh=BC1+ohOdjdL/J3gRyFgi1xGqVWIQJqSuhzaq4JqVPig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NER9Q1pA/Dp2sLiVc7l/uz1+SaC69xOpvqCDJ3tD4MGYd5ORkh09lPxDCJ4Tyi5Tr
         /yOcBwIO+ao+UGDrDuOBDYUHZdSfukFxDEa/OLokSRlVvy16BbREC56R/KeAFA/bdM
         1yysM6yPtx+CWUU6yDFxYNpHvIqyJZF6WAFSy1BM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        Steffen Weinreich <steve@weinreich.org>
Subject: [PATCH 5.15 314/846] netfilter: nft_payload: do not update layer 4 checksum when mangling fragments
Date:   Mon, 24 Jan 2022 19:37:11 +0100
Message-Id: <20220124184111.745474124@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 4e1860a3863707e8177329c006d10f9e37e097a8 ]

IP fragments do not come with the transport header, hence skip bogus
layer 4 checksum updates.

Fixes: 1814096980bb ("netfilter: nft_payload: layer 4 checksum adjustment for pseudoheader fields")
Reported-and-tested-by: Steffen Weinreich <steve@weinreich.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_payload.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index a44b14f6c0dc0..132875cd7fff2 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -502,6 +502,9 @@ static int nft_payload_l4csum_offset(const struct nft_pktinfo *pkt,
 				     struct sk_buff *skb,
 				     unsigned int *l4csum_offset)
 {
+	if (pkt->fragoff)
+		return -1;
+
 	switch (pkt->tprot) {
 	case IPPROTO_TCP:
 		*l4csum_offset = offsetof(struct tcphdr, check);
-- 
2.34.1



