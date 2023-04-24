Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91D6F6ECD92
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232053AbjDXNYf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbjDXNY2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:24:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864C2D8
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:24:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A84662277
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:24:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2676FC433EF;
        Mon, 24 Apr 2023 13:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682342666;
        bh=QaGyfEE1Z/jhX1T8Y/mQeHwr6PbiIzeSmm0AjJ6mzzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oUXifA7+ICsbASMjJIz0MXSR0CuyNpCOLCyPvjqxgEG8WwXqwdlhY1BMj+92yytH6
         aV2k/F6bN7xVolbD3uz/L5Qx4NNC5Tev9ejnwHMtHnN/sD/BNu8ICmi28sFL5t5ZEQ
         VCeV38MpraQ0ivmNB5F/u7kFMQzs7HpOeeH0t2Lo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chen Aotian <chenaotian2@163.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 12/98] netfilter: nf_tables: Modify nla_memdups flag to GFP_KERNEL_ACCOUNT
Date:   Mon, 24 Apr 2023 15:16:35 +0200
Message-Id: <20230424131134.338361715@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
References: <20230424131133.829259077@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Aotian <chenaotian2@163.com>

[ Upstream commit af0acf22aea359e04412237d68787401f96bb583 ]

For memory alloc that store user data from nla[NFTA_OBJ_USERDATA],
use GFP_KERNEL_ACCOUNT is more suitable.

Fixes: 33758c891479 ("memcg: enable accounting for nft objects")
Signed-off-by: Chen Aotian <chenaotian2@163.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1a9d759d0a026..ee052a5874fc3 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6980,7 +6980,7 @@ static int nf_tables_newobj(struct sk_buff *skb, const struct nfnl_info *info,
 	}
 
 	if (nla[NFTA_OBJ_USERDATA]) {
-		obj->udata = nla_memdup(nla[NFTA_OBJ_USERDATA], GFP_KERNEL);
+		obj->udata = nla_memdup(nla[NFTA_OBJ_USERDATA], GFP_KERNEL_ACCOUNT);
 		if (obj->udata == NULL)
 			goto err_userdata;
 
-- 
2.39.2



