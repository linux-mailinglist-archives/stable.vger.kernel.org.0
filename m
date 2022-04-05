Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11D1C4F2A48
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 12:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235568AbiDEJwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244603AbiDEJKF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:10:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66E9D2AC4E;
        Tue,  5 Apr 2022 01:59:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65652B81BBF;
        Tue,  5 Apr 2022 08:59:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B26B3C385A0;
        Tue,  5 Apr 2022 08:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149188;
        bh=WsW6LYCcpbPQgKzCuxo3ZJJAg7nrkIEDruFN5ptLGag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J8ADRWG/Z4AxqrDBKuZ43p/Y4GPm+0qcKg16IPM0OD4GrsRPPOzJ2ELVUNMDMDkYZ
         ps7lBLj57zoCyZ+C/mNMl0p9lPBreA4HfNafUoh2vosq699HN02dyj1RzKWjb8imza
         r7ncXYQpLcBdlnAnbKuYzyIhgxCp7zdP2QYW4EHM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0625/1017] netfilter: conntrack: Add and use nf_ct_set_auto_assign_helper_warned()
Date:   Tue,  5 Apr 2022 09:25:38 +0200
Message-Id: <20220405070412.833959655@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

[ Upstream commit 31d0bb9763efad30377505f3467f958d1ebe1e3d ]

The function sets the pernet boolean to avoid the spurious warning from
nf_ct_lookup_helper() when assigning conntrack helpers via nftables.

Fixes: 1a64edf54f55 ("netfilter: nft_ct: add helper set support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_conntrack_helper.h | 1 +
 net/netfilter/nf_conntrack_helper.c         | 6 ++++++
 net/netfilter/nft_ct.c                      | 3 +++
 3 files changed, 10 insertions(+)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index 37f0fbefb060..9939c366f720 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -177,4 +177,5 @@ void nf_nat_helper_unregister(struct nf_conntrack_nat_helper *nat);
 int nf_nat_helper_try_module_get(const char *name, u16 l3num,
 				 u8 protonum);
 void nf_nat_helper_put(struct nf_conntrack_helper *helper);
+void nf_ct_set_auto_assign_helper_warned(struct net *net);
 #endif /*_NF_CONNTRACK_HELPER_H*/
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index ae4488a13c70..ceb38a7b37cb 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -556,6 +556,12 @@ static const struct nf_ct_ext_type helper_extend = {
 	.id	= NF_CT_EXT_HELPER,
 };
 
+void nf_ct_set_auto_assign_helper_warned(struct net *net)
+{
+	nf_ct_pernet(net)->auto_assign_helper_warned = true;
+}
+EXPORT_SYMBOL_GPL(nf_ct_set_auto_assign_helper_warned);
+
 void nf_conntrack_helper_pernet_init(struct net *net)
 {
 	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 99b1de14ff7e..54ecb9fbf2de 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -1040,6 +1040,9 @@ static int nft_ct_helper_obj_init(const struct nft_ctx *ctx,
 	if (err < 0)
 		goto err_put_helper;
 
+	/* Avoid the bogus warning, helper will be assigned after CT init */
+	nf_ct_set_auto_assign_helper_warned(ctx->net);
+
 	return 0;
 
 err_put_helper:
-- 
2.34.1



