Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92BE765EC5C
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 14:08:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234290AbjAENIz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 08:08:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234433AbjAENIe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 08:08:34 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E62C5E652
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 05:08:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5DFE4CE1ADB
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 13:08:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A2F3C433EF;
        Thu,  5 Jan 2023 13:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672924089;
        bh=IiznI6s7z6AJ6dUU8a+7Bqq7FFsj2KoatyvFS47s3fA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EdBzibQwlZvsdVuNsprsZYLlHjzy6foQdJjes9JU8Au/05QokoA10d9UPj99lWd3l
         25LbuVAo6hQCIdkJnpr5esm/bOx9f69yHGrDtBBcs9pq+9DS1ujve1K+G2+isjU8oP
         +kOEy4IDVI56zQpBRNwepT1Njzw7Ec4G/cwUPh4I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 190/251] net: ethernet: ti: Fix return type of netcp_ndo_start_xmit()
Date:   Thu,  5 Jan 2023 13:55:27 +0100
Message-Id: <20230105125343.512129005@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 63fe6ff674a96cfcfc0fa8df1051a27aa31c70b4 ]

With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
indirect call targets are validated against the expected function
pointer prototype to make sure the call target is valid to help mitigate
ROP attacks. If they are not identical, there is a failure at run time,
which manifests as either a kernel panic or thread getting killed. A
proposed warning in clang aims to catch these at compile time, which
reveals:

  drivers/net/ethernet/ti/netcp_core.c:1944:21: error: incompatible function pointer types initializing 'netdev_tx_t (*)(struct sk_buff *, struct net_device *)' (aka 'enum netdev_tx (*)(struct sk_buff *, struct net_device *)') with an expression of type 'int (struct sk_buff *, struct net_device *)' [-Werror,-Wincompatible-function-pointer-types-strict]
          .ndo_start_xmit         = netcp_ndo_start_xmit,
                                    ^~~~~~~~~~~~~~~~~~~~
  1 error generated.

->ndo_start_xmit() in 'struct net_device_ops' expects a return type of
'netdev_tx_t', not 'int'. Adjust the return type of
netcp_ndo_start_xmit() to match the prototype's to resolve the warning
and CFI failure.

Link: https://github.com/ClangBuiltLinux/linux/issues/1750
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20221102160933.1601260-1-nathan@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/netcp_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/netcp_core.c b/drivers/net/ethernet/ti/netcp_core.c
index c17967b23d3c..957701d48712 100644
--- a/drivers/net/ethernet/ti/netcp_core.c
+++ b/drivers/net/ethernet/ti/netcp_core.c
@@ -1237,7 +1237,7 @@ static int netcp_tx_submit_skb(struct netcp_intf *netcp,
 }
 
 /* Submit the packet */
-static int netcp_ndo_start_xmit(struct sk_buff *skb, struct net_device *ndev)
+static netdev_tx_t netcp_ndo_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	struct netcp_intf *netcp = netdev_priv(ndev);
 	int subqueue = skb_get_queue_mapping(skb);
-- 
2.35.1



