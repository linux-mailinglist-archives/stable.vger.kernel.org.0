Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8C8151A659
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354164AbiEDQzB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 12:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354068AbiEDQxt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 12:53:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FB7346B3D;
        Wed,  4 May 2022 09:49:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B211B827A0;
        Wed,  4 May 2022 16:49:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A76DFC385AA;
        Wed,  4 May 2022 16:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651682940;
        bh=NhFhnzI0gdPcL+Y4/SDdfwLcqHDIn6Qbw2CnLVHsIJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sa0j9RD3jWfq775bDv9iFKm3y+ZzJje9UvFquC9/txsCJ+1x8RtBfQTzdozPDc1eQ
         dQwQW/cNma46sW2P56JmDQbPe54jrxD1Z0dr0SAsn5ykdFKE6faCNxOB/EUfghYz1s
         qwcmDCx5rh2bSlCv3qaRFKlPdbZNFes7fmf5xOe4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pengcheng Yang <yangpc@wangsu.com>,
        Julian Anastasov <ja@ssi.bg>,
        Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 45/84] ipvs: correctly print the memory size of ip_vs_conn_tab
Date:   Wed,  4 May 2022 18:44:26 +0200
Message-Id: <20220504152931.009523556@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504152927.744120418@linuxfoundation.org>
References: <20220504152927.744120418@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
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
index d1524ca4b90e..a189079a6ea5 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1421,7 +1421,7 @@ int __init ip_vs_conn_init(void)
 	pr_info("Connection hash table configured "
 		"(size=%d, memory=%ldKbytes)\n",
 		ip_vs_conn_tab_size,
-		(long)(ip_vs_conn_tab_size*sizeof(struct list_head))/1024);
+		(long)(ip_vs_conn_tab_size*sizeof(*ip_vs_conn_tab))/1024);
 	IP_VS_DBG(0, "Each connection entry needs %zd bytes at least\n",
 		  sizeof(struct ip_vs_conn));
 
-- 
2.35.1



