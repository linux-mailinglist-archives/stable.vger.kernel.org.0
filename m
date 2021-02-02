Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E93EE30C262
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 15:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231787AbhBBOtO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 09:49:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:51120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234331AbhBBORl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:17:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E479565067;
        Tue,  2 Feb 2021 13:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612274081;
        bh=pFP5tV2rdcax46dv3psF73UyTrW4ah+yRHZzeaCEGFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jLXS+ixZQSPwAac8sYByXo4VsMY0k22k1wclaREazmKCyKBuH9iaTWeOazYq82rLo
         +zn5feQPmJjkva+mPbHA/4ZdE60P7Ly7Ve1TArrwO8pwnTEV7YSXwQ8iUnCP93MLx6
         wvi72e5yj5BXwCITTd5QjU/uVi4KLHPWNsuU6rXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.19 21/37] netfilter: nft_dynset: add timeout extension to template
Date:   Tue,  2 Feb 2021 14:39:04 +0100
Message-Id: <20210202132943.788941845@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132942.915040339@linuxfoundation.org>
References: <20210202132942.915040339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 0c5b7a501e7400869ee905b4f7af3d6717802bcb upstream.

Otherwise, the newly create element shows no timeout when listing the
ruleset. If the set definition does not specify a default timeout, then
the set element only shows the expiration time, but not the timeout.
This is a problem when restoring a stateful ruleset listing since it
skips the timeout policy entirely.

Fixes: 22fe54d5fefc ("netfilter: nf_tables: add support for dynamic set updates")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nft_dynset.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -213,8 +213,10 @@ static int nft_dynset_init(const struct
 		nft_set_ext_add_length(&priv->tmpl, NFT_SET_EXT_EXPR,
 				       priv->expr->ops->size);
 	if (set->flags & NFT_SET_TIMEOUT) {
-		if (timeout || set->timeout)
+		if (timeout || set->timeout) {
+			nft_set_ext_add(&priv->tmpl, NFT_SET_EXT_TIMEOUT);
 			nft_set_ext_add(&priv->tmpl, NFT_SET_EXT_EXPIRATION);
+		}
 	}
 
 	priv->timeout = timeout;


