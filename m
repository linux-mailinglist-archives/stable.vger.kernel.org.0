Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 927D848B10E
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 16:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239603AbiAKPky (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 10:40:54 -0500
Received: from esa2.mentor.iphmx.com ([68.232.141.98]:47528 "EHLO
        esa2.mentor.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232584AbiAKPky (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 10:40:54 -0500
IronPort-SDR: M30igW4lVFSQkS6o9fzcwgGWSalZQHq8al7q93yp5EVxSDzljH/nzIFXv9kdbHg8u8rSpWz2u+
 ZC0kFr2NW+MQCQzfjqJbFDYrteKi4rLmzAeG138hipgvOnPg0UeNfsAz0H6/kAjvr0vfYaJrFD
 BXrUTU25KjUnKhUY6eVHoGyuWM+UAGqhzaF0tDqf2R98b4fNmw61VzbbXUv0khUfZua3W2rxDq
 RA7c6lZiI03Lsg+7qce36obh9Ch+vWcAVA8sBQUB2ksCF3pfcvA2FNvzs1isbdA1d8sfMkkI/z
 Dq4WJfJNeU3rMcpBvxGgMftV
X-IronPort-AV: E=Sophos;i="5.88,279,1635235200"; 
   d="scan'208,223";a="70626095"
Received: from orw-gwy-02-in.mentorg.com ([192.94.38.167])
  by esa2.mentor.iphmx.com with ESMTP; 11 Jan 2022 07:40:53 -0800
IronPort-SDR: bTxCIAiq98RYDrTnN5dKh0Ny9tNZZA6acCeqNzhV7CJ6DzqiHx0jH6UhA8gYKGWvf5OXqPibRg
 ekn65zyPD581fpm4DD5k71N6HI/26AfV8IJytU5Y/bGcT7u9AU/hVMCfHptZguVRGY4zEdCLAK
 Zhx6oxiFJiRMrGsWUwdpVcld0vR7cx9rMyzpfQpQZpRuggZVXGdRm6shLhip5Swe2BWKiTLrML
 fBn1VnXBnLIac+Q08uFZkhOYkbfuXLmET7QkU/3t38HjIRYxLt44PRVfMSyOhECeCAymRhCdvZ
 vtQ=
Date:   Tue, 11 Jan 2022 10:40:48 -0500
From:   Amy Fong <Amy_Fong@mentor.com>
To:     <stable@vger.kernel.org>
CC:     <davem@davemloft.net>
Subject: Re: [PATCH 4.19 stable 2/5] Backport netfilter: nf_tables: autoload
 modules from the abort path
Message-ID: <Yd2lAJv4ym9jXD05@cat>
References: <Yd2kKZEWm6AdBYDE@cat>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Yd2kKZEWm6AdBYDE@cat>
X-ClientProxiedBy: svr-orw-mbx-10.mgc.mentorg.com (147.34.90.210) To
 svr-orw-mbx-04.mgc.mentorg.com (147.34.90.204)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From 185a61df95c18e5111df5ba439b0e60a8a6e40cb Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Fri, 5 Jul 2019 23:38:46 +0200
Subject: [PATCH 2/5] netfilter: nf_tables: add nft_expr_type_request_module()

This helper function makes sure the family specific extension is loaded.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
(cherry picked from commit b9c04ae7907f09c5e873e7c9a8feea2ce41e15b3)
---
 net/netfilter/nf_tables_api.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 02e577e8fb8a..8ec38de1f7a1 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2009,6 +2009,19 @@ static const struct nft_expr_type *__nft_expr_type_get(u8 family,
 	return NULL;
 }
 
+#ifdef CONFIG_MODULES
+static int nft_expr_type_request_module(struct net *net, u8 family,
+					struct nlattr *nla)
+{
+	nft_request_module(net, "nft-expr-%u-%.*s", family,
+			   nla_len(nla), (char *)nla_data(nla));
+	if (__nft_expr_type_get(family, nla))
+		return -EAGAIN;
+
+	return 0;
+}
+#endif
+
 static const struct nft_expr_type *nft_expr_type_get(struct net *net,
 						     u8 family,
 						     struct nlattr *nla)
@@ -2025,9 +2038,7 @@ static const struct nft_expr_type *nft_expr_type_get(struct net *net,
 	lockdep_nfnl_nft_mutex_not_held();
 #ifdef CONFIG_MODULES
 	if (type == NULL) {
-		nft_request_module(net, "nft-expr-%u-%.*s", family,
-				   nla_len(nla), (char *)nla_data(nla));
-		if (__nft_expr_type_get(family, nla))
+		if (nft_expr_type_request_module(net, family, nla) == -EAGAIN)
 			return ERR_PTR(-EAGAIN);
 
 		nft_request_module(net, "nft-expr-%.*s",
-- 
2.34.1

