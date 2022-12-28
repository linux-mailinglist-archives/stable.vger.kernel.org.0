Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3E25658452
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235317AbiL1Q4m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:56:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235320AbiL1Qzz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:55:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E845E1E72A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:51:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FBB16156E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:51:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 831C8C433EF;
        Wed, 28 Dec 2022 16:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246265;
        bh=bylQ92nndUsQDEdsR7BlnEBaPmFt2kKNmE0KssvA6Mg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=knajd+udH3/CrNJyaitNVE56ag1JXWjKHzJsuNibLd2e0dEvOU7W5rEP8Y8ain1fO
         /m2mX2QDQkCsU58r6y2z9hbE2edzwZPcz3cDFcl2tuTfKj3Be0XRY/5kX+GCfS6kbI
         K8iZmwjaZmiv2D90xx3BcPqVkjhGldHDNdHVd1Vo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alexandra Winter <wintera@linux.ibm.com>,
        Kees Cook <keescook@chromium.org>,
        Nathan Chancellor <nathan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0999/1146] s390/lcs: Fix return type of lcs_start_xmit()
Date:   Wed, 28 Dec 2022 15:42:18 +0100
Message-Id: <20221228144357.502541663@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

[ Upstream commit bb16db8393658e0978c3f0d30ae069e878264fa3 ]

With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
indirect call targets are validated against the expected function
pointer prototype to make sure the call target is valid to help mitigate
ROP attacks. If they are not identical, there is a failure at run time,
which manifests as either a kernel panic or thread getting killed. A
proposed warning in clang aims to catch these at compile time, which
reveals:

  drivers/s390/net/lcs.c:2090:21: error: incompatible function pointer types initializing 'netdev_tx_t (*)(struct sk_buff *, struct net_device *)' (aka 'enum netdev_tx (*)(struct sk_buff *, struct net_device *)') with an expression of type 'int (struct sk_buff *, struct net_device *)' [-Werror,-Wincompatible-function-pointer-types-strict]
          .ndo_start_xmit         = lcs_start_xmit,
                                    ^~~~~~~~~~~~~~
  drivers/s390/net/lcs.c:2097:21: error: incompatible function pointer types initializing 'netdev_tx_t (*)(struct sk_buff *, struct net_device *)' (aka 'enum netdev_tx (*)(struct sk_buff *, struct net_device *)') with an expression of type 'int (struct sk_buff *, struct net_device *)' [-Werror,-Wincompatible-function-pointer-types-strict]
          .ndo_start_xmit         = lcs_start_xmit,
                                    ^~~~~~~~~~~~~~

->ndo_start_xmit() in 'struct net_device_ops' expects a return type of
'netdev_tx_t', not 'int'. Adjust the return type of lcs_start_xmit() to
match the prototype's to resolve the warning and potential CFI failure,
should s390 select ARCH_SUPPORTS_CFI_CLANG in the future.

Link: https://github.com/ClangBuiltLinux/linux/issues/1750
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/lcs.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/net/lcs.c b/drivers/s390/net/lcs.c
index 84c8981317b4..38f312664ce7 100644
--- a/drivers/s390/net/lcs.c
+++ b/drivers/s390/net/lcs.c
@@ -1519,9 +1519,8 @@ lcs_txbuffer_cb(struct lcs_channel *channel, struct lcs_buffer *buffer)
 /*
  * Packet transmit function called by network stack
  */
-static int
-__lcs_start_xmit(struct lcs_card *card, struct sk_buff *skb,
-		 struct net_device *dev)
+static netdev_tx_t __lcs_start_xmit(struct lcs_card *card, struct sk_buff *skb,
+				    struct net_device *dev)
 {
 	struct lcs_header *header;
 	int rc = NETDEV_TX_OK;
@@ -1582,8 +1581,7 @@ __lcs_start_xmit(struct lcs_card *card, struct sk_buff *skb,
 	return rc;
 }
 
-static int
-lcs_start_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t lcs_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct lcs_card *card;
 	int rc;
-- 
2.35.1



