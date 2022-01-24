Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAC4C4997CD
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358061AbiAXVQb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:16:31 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35284 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1448046AbiAXVLz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:11:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3ADD861451;
        Mon, 24 Jan 2022 21:11:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 132CDC340E5;
        Mon, 24 Jan 2022 21:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058714;
        bh=tZoRqKshpb0jYNvvz3638yINcJjRi1Ic87BJvrzDhSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZK5JmYtm34pamy+HKlwb9Bep+hRqSn46QRoQ3cSy0sYQUit3PnLQ1sS99egt1n4Yw
         Fz/v5NY4QMUctYMJ8fLy5TFfPMbjBfO6Vse3TVvldECtXNYC4FgpmY7FW/IEf5JRTP
         8SJJW1xGYjV+qFU1/qPTzpiWnv9AmawboRiOqXoE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        Steffen Weinreich <steve@weinreich.org>
Subject: [PATCH 5.16 0379/1039] netfilter: nft_payload: do not update layer 4 checksum when mangling fragments
Date:   Mon, 24 Jan 2022 19:36:08 +0100
Message-Id: <20220124184138.051803190@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
index bd689938a2e0c..58e96a0fe0b4c 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -546,6 +546,9 @@ static int nft_payload_l4csum_offset(const struct nft_pktinfo *pkt,
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



