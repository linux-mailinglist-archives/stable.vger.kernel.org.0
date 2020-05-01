Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EFAE1C1643
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730710AbgEANms (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:42:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:43522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731193AbgEANmq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:42:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4968216FD;
        Fri,  1 May 2020 13:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340566;
        bh=lcWydKBWqQV/ZXC2wD/mYqXm6d863aZJxCKMdQZ+MX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tOV9hPcRxHBERVb0ROKFDR7F9YB+ZxB48m7MhG6jp4xaXsmXkOIcGSiM6oRlKzHj1
         yoza/yU/cY1CjMI+tVYNDUSX7zI9XYb5Jy+LqmcU+bxHT4Tvy3Spk1STg/yLcgMpv+
         KAdU1zG/paz/ZnfAKgl0974ikeZLhsNengxrkMik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefano Brivio <sbrivio@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.6 034/106] netfilter: nf_tables: reintroduce the NFT_SET_CONCAT flag
Date:   Fri,  1 May 2020 15:23:07 +0200
Message-Id: <20200501131548.040560317@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131543.421333643@linuxfoundation.org>
References: <20200501131543.421333643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit ef516e8625ddea90b3a0313f3a0b0baa83db7ac2 upstream.

Stefano originally proposed to introduce this flag, users hit EOPNOTSUPP
in new binaries with old kernels when defining a set with ranges in
a concatenation.

Fixes: f3a2181e16f1 ("netfilter: nf_tables: Support for sets with multiple ranged fields")
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/uapi/linux/netfilter/nf_tables.h |    2 ++
 net/netfilter/nf_tables_api.c            |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -276,6 +276,7 @@ enum nft_rule_compat_attributes {
  * @NFT_SET_TIMEOUT: set uses timeouts
  * @NFT_SET_EVAL: set can be updated from the evaluation path
  * @NFT_SET_OBJECT: set contains stateful objects
+ * @NFT_SET_CONCAT: set contains a concatenation
  */
 enum nft_set_flags {
 	NFT_SET_ANONYMOUS		= 0x1,
@@ -285,6 +286,7 @@ enum nft_set_flags {
 	NFT_SET_TIMEOUT			= 0x10,
 	NFT_SET_EVAL			= 0x20,
 	NFT_SET_OBJECT			= 0x40,
+	NFT_SET_CONCAT			= 0x80,
 };
 
 /**
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3949,7 +3949,7 @@ static int nf_tables_newset(struct net *
 		if (flags & ~(NFT_SET_ANONYMOUS | NFT_SET_CONSTANT |
 			      NFT_SET_INTERVAL | NFT_SET_TIMEOUT |
 			      NFT_SET_MAP | NFT_SET_EVAL |
-			      NFT_SET_OBJECT))
+			      NFT_SET_OBJECT | NFT_SET_CONCAT))
 			return -EOPNOTSUPP;
 		/* Only one of these operations is supported */
 		if ((flags & (NFT_SET_MAP | NFT_SET_OBJECT)) ==


