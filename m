Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 014C227C75A
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730290AbgI2LxY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:53:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:47470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730881AbgI2LrA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:47:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E956B206F7;
        Tue, 29 Sep 2020 11:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601380020;
        bh=YyTHnaHcQzf24/k/Rb3DPJ5xGybphhRFbp5wDu/aL44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k/UYDPgON9gHTHffAvkXscyqxazNKJupgGmcMG89YLlB7qAaUQEspPDyA/e83xikK
         CLHGxdiFhhlwTxmBWAVhEcMtdVY6KwxlFtU4e4xZObJGqaLJOgQaKlOzlLGh43ookN
         pWNOjekbE92nn53sai00kdTFgZyunf+SRtMVMe/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 32/99] netfilter: nft_meta: use socket user_ns to retrieve skuid and skgid
Date:   Tue, 29 Sep 2020 13:01:15 +0200
Message-Id: <20200929105931.310039891@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
References: <20200929105929.719230296@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 0c92411bb81de9bc516d6924f50289d8d5f880e5 ]

... instead of using init_user_ns.

Fixes: 96518518cc41 ("netfilter: add nftables")
Tested-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_meta.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 7bc6537f3ccb5..b37bd02448d8c 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -147,11 +147,11 @@ nft_meta_get_eval_skugid(enum nft_meta_keys key,
 
 	switch (key) {
 	case NFT_META_SKUID:
-		*dest = from_kuid_munged(&init_user_ns,
+		*dest = from_kuid_munged(sock_net(sk)->user_ns,
 					 sock->file->f_cred->fsuid);
 		break;
 	case NFT_META_SKGID:
-		*dest =	from_kgid_munged(&init_user_ns,
+		*dest =	from_kgid_munged(sock_net(sk)->user_ns,
 					 sock->file->f_cred->fsgid);
 		break;
 	default:
-- 
2.25.1



