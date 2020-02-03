Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC096150C86
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731308AbgBCQhR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:37:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:52796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731303AbgBCQhP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:37:15 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81B4220721;
        Mon,  3 Feb 2020 16:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747835;
        bh=IPrmHewk90z2bfjgSVjIpJD4+5qHS7fePA67uDfcOFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sl7KnGFB+eCIQtszti7s6S+byoex4LgWc0+dVZxGBaX+kFsHduGb06XmkTF0n1Mof
         kT8e15wSrhDC65M2R7bSkAKLwKFV8FPT5fiYY/ESiFOpQpmdpPZkBrD4hA3EsxosSl
         7RAwkKHD+y2eDHEXOkzBEhrLxJu4IARPK6fqjfCc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, wenxu <wenxu@ucloud.cn>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 89/90] netfilter: nf_tables_offload: fix check the chain offload flag
Date:   Mon,  3 Feb 2020 16:20:32 +0000
Message-Id: <20200203161927.827669434@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161917.612554987@linuxfoundation.org>
References: <20200203161917.612554987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

[ Upstream commit c83de17dd6308fb74696923e5245de0e3c427206 ]

In the nft_indr_block_cb the chain should check the flag with
NFT_CHAIN_HW_OFFLOAD.

Fixes: 9a32669fecfb ("netfilter: nf_tables_offload: support indr block call")
Signed-off-by: wenxu <wenxu@ucloud.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 96a64e7594a51..914cd0618d5a6 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -437,7 +437,7 @@ static void nft_indr_block_cb(struct net_device *dev,
 
 	mutex_lock(&net->nft.commit_mutex);
 	chain = __nft_offload_get_chain(dev);
-	if (chain) {
+	if (chain && chain->flags & NFT_CHAIN_HW_OFFLOAD) {
 		struct nft_base_chain *basechain;
 
 		basechain = nft_base_chain(chain);
-- 
2.20.1



