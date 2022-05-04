Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D69F51A7C8
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355307AbiEDRGX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356058AbiEDREv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:04:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D00250072;
        Wed,  4 May 2022 09:53:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0439BB827A1;
        Wed,  4 May 2022 16:53:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0326C385AA;
        Wed,  4 May 2022 16:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683220;
        bh=1PxZCugPr4DxiBBU19KWct2wANpsU0yR63LGAuaYykk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rdQmuL4s92SZQew0SsoBI8hhW5cSf74djk1zYC3PJtbOiRUyY8ytdeT6z2w7YV6kS
         xI3khVrJXbwDq1uZdMnGBQ8zU2E3nJFVN1e8327XzlcRPJHsQsz15j4FngK2JM4ar4
         22c8MhoGrNW69Tl1aTQzdciFqtoGAi6eSNpvekGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pengcheng Yang <yangpc@wangsu.com>,
        Julian Anastasov <ja@ssi.bg>,
        Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 073/177] ipvs: correctly print the memory size of ip_vs_conn_tab
Date:   Wed,  4 May 2022 18:44:26 +0200
Message-Id: <20220504153059.611149812@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153053.873100034@linuxfoundation.org>
References: <20220504153053.873100034@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pengcheng Yang <yangpc@wangsu.com>

[ Upstream commit eba1a872cb73314280d5448d934935b23e30b7ca ]

The memory size of ip_vs_conn_tab changed after we use hlist
instead of list.

Fixes: 731109e78415 ("ipvs: use hlist instead of list")
Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Acked-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/ip_vs_conn.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 2c467c422dc6..fb67f1ca2495 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1495,7 +1495,7 @@ int __init ip_vs_conn_init(void)
 	pr_info("Connection hash table configured "
 		"(size=%d, memory=%ldKbytes)\n",
 		ip_vs_conn_tab_size,
-		(long)(ip_vs_conn_tab_size*sizeof(struct list_head))/1024);
+		(long)(ip_vs_conn_tab_size*sizeof(*ip_vs_conn_tab))/1024);
 	IP_VS_DBG(0, "Each connection entry needs %zd bytes at least\n",
 		  sizeof(struct ip_vs_conn));
 
-- 
2.35.1



