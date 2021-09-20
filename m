Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01CFE412445
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348680AbhITSdF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:33:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:48138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1379870AbhITSbA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:31:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6867D632F8;
        Mon, 20 Sep 2021 17:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158849;
        bh=O3JhsPU8xl1j9uzXPpoUyD3GXC0aVI2el2Vd4alECis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xyu7/+bj1KPP4xUHdx+C9502T/y4TiCfpwh9iH7R1HkG8UMPA71ozNLYrGjLUyBpt
         SGyZf3NMseKF1uggEB/XWuk6s4m+b4UNVCjmjMHLEx/l1/Y1zKDthQmputBIf1HzCe
         gUe64WCOXNGZCmZKxNP8KC/wOLvyla62Np0YXGsw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 084/122] netfilter: Fix fall-through warnings for Clang
Date:   Mon, 20 Sep 2021 18:44:16 +0200
Message-Id: <20210920163918.544849776@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
References: <20210920163915.757887582@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gustavo A. R. Silva <gustavoars@kernel.org>

[ Upstream commit c2168e6bd7ec50cedb69b3be1ba6146e28893c69 ]

In preparation to enable -Wimplicit-fallthrough for Clang, fix multiple
warnings by explicitly adding multiple break statements instead of just
letting the code fall through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_proto_dccp.c | 1 +
 net/netfilter/nf_tables_api.c           | 1 +
 net/netfilter/nft_ct.c                  | 1 +
 3 files changed, 3 insertions(+)

diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index b3f4a334f9d7..94001eb51ffe 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -397,6 +397,7 @@ dccp_new(struct nf_conn *ct, const struct sk_buff *skb,
 			msg = "not picking up existing connection ";
 			goto out_invalid;
 		}
+		break;
 	case CT_DCCP_REQUEST:
 		break;
 	case CT_DCCP_INVALID:
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2b5f97e1d40b..c605a3e713e7 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8394,6 +8394,7 @@ static int nf_tables_check_loops(const struct nft_ctx *ctx,
 							data->verdict.chain);
 				if (err < 0)
 					return err;
+				break;
 			default:
 				break;
 			}
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 70d46e0bbf06..7af822a02ce9 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -528,6 +528,7 @@ static void __nft_ct_set_destroy(const struct nft_ctx *ctx, struct nft_ct *priv)
 	case NFT_CT_ZONE:
 		if (--nft_ct_pcpu_template_refcnt == 0)
 			nft_ct_tmpl_put_pcpu();
+		break;
 #endif
 	default:
 		break;
-- 
2.30.2



