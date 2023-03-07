Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C82D26AEBAE
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232199AbjCGRrl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:47:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232139AbjCGRrX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:47:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F5899BD5
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:42:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB29B61501
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:41:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C97E0C433EF;
        Tue,  7 Mar 2023 17:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210915;
        bh=hN1zrcX8L/61v/ZkENGtatESrfr608Y8s+eR9V5xJug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t96BKODxnXDKdlm/YD/HydYVXu6QB8pUn3yWY6R5ErlARAiUHD+pZMTPx5Ar2zZJe
         TyQYATlWiKefdWcY1Iy5YkShy4zp02I+iCiahqcmJ1wSpq1nE1710dkuq5+NKEUqvq
         g5B3PvhmDYGt84Mayacfb6l7HzLaE/P/7u4CHSgI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alok Tiwari <alok.a.tiwari@oracle.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0664/1001] netfilter: nf_tables: NULL pointer dereference in nf_tables_updobj()
Date:   Tue,  7 Mar 2023 17:57:16 +0100
Message-Id: <20230307170050.423011835@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit dac7f50a45216d652887fb92d6cd3b7ca7f006ea ]

static analyzer detect null pointer dereference case for 'type'
function __nft_obj_type_get() can return NULL value which require to handle
if type is NULL pointer return -ENOENT.

This is a theoretical issue, since an existing object has a type, but
better add this failsafe check.

Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8c09e4d12ac1e..fc8256b00b320 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6999,6 +6999,9 @@ static int nf_tables_newobj(struct sk_buff *skb, const struct nfnl_info *info,
 			return -EOPNOTSUPP;
 
 		type = __nft_obj_type_get(objtype);
+		if (WARN_ON_ONCE(!type))
+			return -ENOENT;
+
 		nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
 
 		return nf_tables_updobj(&ctx, type, nla[NFTA_OBJ_DATA], obj);
-- 
2.39.2



