Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B70C6ECEA9
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232587AbjDXNeJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:34:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232583AbjDXNdr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:33:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D35957EC9
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:33:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1DAC6238C
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:33:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF348C433D2;
        Mon, 24 Apr 2023 13:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682343217;
        bh=D3qPnZNs2+soew6UdpuGhtEJDWUUqrtnswa0sbnQVAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nprgiaoUVzJ+0I2xFDCcna3Q+L0l03HRb7q/jW2uAUvI2TsFy/1IVKQxAqxEpfQEc
         Na5XM17REujkctbvApzKTLeGJ8j6SgIefAsExZ76uCZ+cRBcIUStHFOo7W0UActfk/
         D2IA/i3Nrd6RpYaKU5eE5YFVu9NiwgtT/erVRX1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 11/68] netfilter: nf_tables: fix ifdef to also consider nf_tables=m
Date:   Mon, 24 Apr 2023 15:17:42 +0200
Message-Id: <20230424131128.110482652@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131127.653885914@linuxfoundation.org>
References: <20230424131127.653885914@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit c55c0e91c813589dc55bea6bf9a9fbfaa10ae41d ]

nftables can be built as a module, so fix the preprocessor conditional
accordingly.

Fixes: 478b360a47b7 ("netfilter: nf_tables: fix nf_trace always-on with XT_TRACE=n")
Reported-by: Florian Fainelli <f.fainelli@gmail.com>
Reported-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skbuff.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 287999eedef45..a210f19958621 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -4277,7 +4277,7 @@ static inline void nf_reset_ct(struct sk_buff *skb)
 
 static inline void nf_reset_trace(struct sk_buff *skb)
 {
-#if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE) || defined(CONFIG_NF_TABLES)
+#if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE) || IS_ENABLED(CONFIG_NF_TABLES)
 	skb->nf_trace = 0;
 #endif
 }
@@ -4297,7 +4297,7 @@ static inline void __nf_copy(struct sk_buff *dst, const struct sk_buff *src,
 	dst->_nfct = src->_nfct;
 	nf_conntrack_get(skb_nfct(src));
 #endif
-#if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE) || defined(CONFIG_NF_TABLES)
+#if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE) || IS_ENABLED(CONFIG_NF_TABLES)
 	if (copy)
 		dst->nf_trace = src->nf_trace;
 #endif
-- 
2.39.2



