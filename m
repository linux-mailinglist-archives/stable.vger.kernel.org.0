Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC353D2A62
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234897AbhGVQLG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:11:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:43910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235383AbhGVQJO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:09:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C111061DD3;
        Thu, 22 Jul 2021 16:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972552;
        bh=8xLDXjQ/xNoMru2tZozrN8rqgrCS60aSCI41WcSiZfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HwwRqGDvJBZ4OWXKrujRO3kIW3AAigOlJ1DXdiZO6b55qZ5CACKjL2/aTGJQ118BB
         hwnd30eia3fqrXdHdSaC0208Kk7c5C5KOFH6Jd2KQu8pYDN0Rs8ygNh3/7L+14X+Ty
         UuUzNd9jtWfDZksHCFlBb+Vc4Ptw4rqp8lIjtSTw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.13 118/156] netfilter: nf_tables: Fix dereference of null pointer flow
Date:   Thu, 22 Jul 2021 18:31:33 +0200
Message-Id: <20210722155632.183087632@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

commit 4ca041f919f13783b0b03894783deee00dbca19a upstream.

In the case where chain->flags & NFT_CHAIN_HW_OFFLOAD is false then
nft_flow_rule_create is not called and flow is NULL. The subsequent
error handling execution via label err_destroy_flow_rule will lead
to a null pointer dereference on flow when calling nft_flow_rule_destroy.
Since the error path to err_destroy_flow_rule has to cater for null
and non-null flows, only call nft_flow_rule_destroy if flow is non-null
to fix this issue.

Addresses-Coverity: ("Explicity null dereference")
Fixes: 3c5e44622011 ("netfilter: nf_tables: memleak in hw offload abort path")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3453,7 +3453,8 @@ static int nf_tables_newrule(struct sk_b
 	return 0;
 
 err_destroy_flow_rule:
-	nft_flow_rule_destroy(flow);
+	if (flow)
+		nft_flow_rule_destroy(flow);
 err_release_rule:
 	nf_tables_rule_release(&ctx, rule);
 err_release_expr:


