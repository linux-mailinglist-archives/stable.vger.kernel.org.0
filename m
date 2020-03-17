Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 666131880F7
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728102AbgCQLOx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:14:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:57604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729509AbgCQLNi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:13:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9011B205ED;
        Tue, 17 Mar 2020 11:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443618;
        bh=UM1jBLKFzCcE/cd3i8fg+UzlGgR3gLrxgTZisoqc0Rg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nFu/HfFKOpEbohHv4NcMXwghreJYZl9At9wrvJiU+RfBA5x4pzEuXoK5Eff0MQmGC
         XvpVH9392Z95kdb0AVPNpd2UOWsYWYcr1CnKNPdi3sCdHm0hYJUiWho/m+xsX+xNpo
         ulC8g/Grhaw9rsQ0YfGjBB1EKfuT6fBcyNxq6pX8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.5 144/151] netfilter: nf_tables: dump NFTA_CHAIN_FLAGS attribute
Date:   Tue, 17 Mar 2020 11:55:54 +0100
Message-Id: <20200317103336.890985032@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103326.593639086@linuxfoundation.org>
References: <20200317103326.593639086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit d78008de6103c708171baff9650a7862645d23b0 upstream.

Missing NFTA_CHAIN_FLAGS netlink attribute when dumping basechain
definitions.

Fixes: c9626a2cbdb2 ("netfilter: nf_tables: add hardware offload support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nf_tables_api.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1405,6 +1405,11 @@ static int nf_tables_fill_chain_info(str
 					      lockdep_commit_lock_is_held(net));
 		if (nft_dump_stats(skb, stats))
 			goto nla_put_failure;
+
+		if ((chain->flags & NFT_CHAIN_HW_OFFLOAD) &&
+		    nla_put_be32(skb, NFTA_CHAIN_FLAGS,
+				 htonl(NFT_CHAIN_HW_OFFLOAD)))
+			goto nla_put_failure;
 	}
 
 	if (nla_put_be32(skb, NFTA_CHAIN_USE, htonl(chain->use)))


