Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C66E03A025C
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236647AbhFHTDQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:03:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:34178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237698AbhFHTBM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:01:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 022566191F;
        Tue,  8 Jun 2021 18:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177884;
        bh=rLlInfPeeEe9cY3zBXq42wFZc4XI1ewRkI8Jpy+8Xr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZaEakzOEPA1htk47fXk9Dcl9NikB5/ojprQn6A4RuVzwIvu36N5TZOUgc+2e4kHL5
         hpmvGO8ZcWuXqjTfnkDNlATB2HyE29E/lNx8AHQLGmPXj7hT8PonKfVucCfVRVM0ih
         kLlIMmY/VDio0dNrFgbK9ucjSV9gs1fhXwUUuO9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.10 135/137] netfilter: nf_tables: missing error reporting for not selected expressions
Date:   Tue,  8 Jun 2021 20:27:55 +0200
Message-Id: <20210608175946.943525991@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
References: <20210608175942.377073879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit c781471d67a56d7d4c113669a11ede0463b5c719 upstream.

Sometimes users forget to turn on nftables extensions from Kconfig that
they need. In such case, the error reporting from userspace is
misleading:

 $ sudo nft add rule x y counter
 Error: Could not process rule: No such file or directory
 add rule x y counter
 ^^^^^^^^^^^^^^^^^^^^

Add missing NL_SET_BAD_ATTR() to provide a hint:

 $ nft add rule x y counter
 Error: Could not process rule: No such file or directory
 add rule x y counter
              ^^^^^^^

Fixes: 83d9dcba06c5 ("netfilter: nf_tables: extended netlink error reporting for expressions")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3263,8 +3263,10 @@ static int nf_tables_newrule(struct net
 			if (n == NFT_RULE_MAXEXPRS)
 				goto err1;
 			err = nf_tables_expr_parse(&ctx, tmp, &info[n]);
-			if (err < 0)
+			if (err < 0) {
+				NL_SET_BAD_ATTR(extack, tmp);
 				goto err1;
+			}
 			size += info[n].ops->size;
 			n++;
 		}


