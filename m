Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 218E54A4166
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358360AbiAaLDo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:03:44 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35926 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358435AbiAaLCV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:02:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09D3060B28;
        Mon, 31 Jan 2022 11:02:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C27B3C340E8;
        Mon, 31 Jan 2022 11:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643626940;
        bh=FdwPPk2gvLjIFkl3+JgjvyKrpdqDALAn+JhXfZlZT9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uVOqhDUTD67ga+CnNODF1ce83f/l0G+77SxIOx/nUWYwNWt0lyJn52Bx5/wK86VEp
         bdXGdSjPCFh3G/j31q0toSmRQH30nda6H86JxA1mnjLO2OE6Jm7U+eFM2X2MlkkEVo
         LHoYv5wme+azyrNhKtnsKo0+wtozw1I30qb/s/Rk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Steffen Weinreich <steve@weinreich.org>
Subject: [PATCH 5.10 023/100] netfilter: nft_payload: do not update layer 4 checksum when mangling fragments
Date:   Mon, 31 Jan 2022 11:55:44 +0100
Message-Id: <20220131105221.236589643@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105220.424085452@linuxfoundation.org>
References: <20220131105220.424085452@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 4e1860a3863707e8177329c006d10f9e37e097a8 upstream.

IP fragments do not come with the transport header, hence skip bogus
layer 4 checksum updates.

Fixes: 1814096980bb ("netfilter: nft_payload: layer 4 checksum adjustment for pseudoheader fields")
Reported-and-tested-by: Steffen Weinreich <steve@weinreich.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_payload.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -502,6 +502,9 @@ static int nft_payload_l4csum_offset(con
 				     struct sk_buff *skb,
 				     unsigned int *l4csum_offset)
 {
+	if (pkt->xt.fragoff)
+		return -1;
+
 	switch (pkt->tprot) {
 	case IPPROTO_TCP:
 		*l4csum_offset = offsetof(struct tcphdr, check);


