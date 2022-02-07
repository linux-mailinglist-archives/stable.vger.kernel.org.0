Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62E644ABB22
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241550AbiBGLZJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:25:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377062AbiBGLPU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:15:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E51B0C0401DA;
        Mon,  7 Feb 2022 03:14:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2635E61314;
        Mon,  7 Feb 2022 11:14:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3702C340EB;
        Mon,  7 Feb 2022 11:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232494;
        bh=rVzw4I1cQMNBrWV6J20Z9Clp0NL/SBYy8ZU4O+vPCvo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=knBu6+A1HOedYEsS4JD5ukPO6E7EjQ0reLWyahQeQ7Z2Y0mbyacPhQCrto/BIciMC
         qP35V3+imRVfQVEsbUgkTIikO3TjnP7NyUTtPHEI1T2svE+qqhCp26+jjasCExrZf7
         hCZ44jQinWbgpE/2gCzJM1EYpXLLY8/h9kKpj57s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Steffen Weinreich <steve@weinreich.org>
Subject: [PATCH 4.19 08/86] netfilter: nft_payload: do not update layer 4 checksum when mangling fragments
Date:   Mon,  7 Feb 2022 12:05:31 +0100
Message-Id: <20220207103757.830383880@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103757.550973048@linuxfoundation.org>
References: <20220207103757.550973048@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
@@ -194,6 +194,9 @@ static int nft_payload_l4csum_offset(con
 				     struct sk_buff *skb,
 				     unsigned int *l4csum_offset)
 {
+	if (pkt->xt.fragoff)
+		return -1;
+
 	switch (pkt->tprot) {
 	case IPPROTO_TCP:
 		*l4csum_offset = offsetof(struct tcphdr, check);


