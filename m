Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50D1830C968
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 19:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238247AbhBBSRP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 13:17:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:46996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233665AbhBBOGe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:06:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C52E364F8E;
        Tue,  2 Feb 2021 13:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273763;
        bh=lhdzq5PpdZBF9KqQ787moPSy/SUyn84t0ZPaOmVkGrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L7jKKnlnCeJaVeDlY4oo0ZZZn9ecaWwjRG/6Bv8hVksYxw5E2hET38ONTeHD4JqI+
         MzG+VEfTv3dTbP+VJqoqaOV81APNBohf7qwfFfYs+crBG4iJmAqmENelP+63Gb6JdE
         aZ8g8tehZV/1aGqFEzPvquaw1N7X66OVSLyObRyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.4 20/28] netfilter: nft_dynset: add timeout extension to template
Date:   Tue,  2 Feb 2021 14:38:40 +0100
Message-Id: <20210202132941.998209256@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132941.180062901@linuxfoundation.org>
References: <20210202132941.180062901@linuxfoundation.org>
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
@@ -189,8 +189,10 @@ static int nft_dynset_init(const struct
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


