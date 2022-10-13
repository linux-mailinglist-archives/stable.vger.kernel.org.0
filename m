Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3A815FD144
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231776AbiJMAfv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232168AbiJMAeV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:34:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72A45109A;
        Wed, 12 Oct 2022 17:29:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EFA28B81C48;
        Thu, 13 Oct 2022 00:28:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A10ADC433D7;
        Thu, 13 Oct 2022 00:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620903;
        bh=onPe5fJ7fr9bzrF4dH6UIin84lWulEOkVhLMTXM4P0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aMXmxtsXjO5nNHKqE/ABQWBl83SZh3CYwQxDnT8rWvmMOOWX5jx2UGHynAHij8eeS
         2u2J7LRAaPAbGjkgc4S9BBlNEmOMKDotpWnhXgAGgIoa0jNO6WUD/VQQNuvWVT07eg
         bMxywYLq2hL21Z1yxd0X18kmBG8O/LdJDbLRgxXG6tR1i+M19nnGLgKn7inGDtG8hx
         cySYxpDNnmr5ynnAoj+T/oQokPYx1bNTKHPA/PbynL89qA4McSbjY4CmNLgnSykA84
         9dBizUxUk/B/qkKQ1TIEYZJFgaNoCzJ2VjtjV7f14epeDPWBnPXsnGFKevmMMyFWoM
         tOTVpJcAGR7Sg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Huckleberry <nhuck@google.com>, llvm@lists.linux.dev,
        Dan Carpenter <error27@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, ndesaulniers@google.com,
        linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 4.9 09/10] staging: octeon: Fix return type of cvm_oct_xmit and cvm_oct_xmit_pow
Date:   Wed, 12 Oct 2022 20:27:56 -0400
Message-Id: <20221013002802.1896096-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013002802.1896096-1-sashal@kernel.org>
References: <20221013002802.1896096-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Huckleberry <nhuck@google.com>

[ Upstream commit b77599043f00fce9253d0f22522c5d5b521555ce ]

The ndo_start_xmit field in net_device_ops is expected to be of type
netdev_tx_t (*ndo_start_xmit)(struct sk_buff *skb, struct net_device *dev).

The mismatched return type breaks forward edge kCFI since the underlying
function definition does not match the function hook definition.

The return type of cvm_oct_xmit and cvm_oct_xmit_pow should be changed
from int to netdev_tx_t.

Link: https://github.com/ClangBuiltLinux/linux/issues/1703
Cc: llvm@lists.linux.dev
Reported-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Nathan Huckleberry <nhuck@google.com>
Link: https://lore.kernel.org/r/20220914211057.423617-1-nhuck@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/octeon/ethernet-tx.c | 4 ++--
 drivers/staging/octeon/ethernet-tx.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/octeon/ethernet-tx.c b/drivers/staging/octeon/ethernet-tx.c
index 6b4c20872323..e773353ee579 100644
--- a/drivers/staging/octeon/ethernet-tx.c
+++ b/drivers/staging/octeon/ethernet-tx.c
@@ -137,7 +137,7 @@ static void cvm_oct_free_tx_skbs(struct net_device *dev)
  *
  * Returns Always returns NETDEV_TX_OK
  */
-int cvm_oct_xmit(struct sk_buff *skb, struct net_device *dev)
+netdev_tx_t cvm_oct_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	cvmx_pko_command_word0_t pko_command;
 	union cvmx_buf_ptr hw_buffer;
@@ -523,7 +523,7 @@ int cvm_oct_xmit(struct sk_buff *skb, struct net_device *dev)
 
  * Returns Always returns zero
  */
-int cvm_oct_xmit_pow(struct sk_buff *skb, struct net_device *dev)
+netdev_tx_t cvm_oct_xmit_pow(struct sk_buff *skb, struct net_device *dev)
 {
 	struct octeon_ethernet *priv = netdev_priv(dev);
 	void *packet_buffer;
diff --git a/drivers/staging/octeon/ethernet-tx.h b/drivers/staging/octeon/ethernet-tx.h
index 84848e4c1664..65faefc87081 100644
--- a/drivers/staging/octeon/ethernet-tx.h
+++ b/drivers/staging/octeon/ethernet-tx.h
@@ -8,8 +8,8 @@
  * published by the Free Software Foundation.
  */
 
-int cvm_oct_xmit(struct sk_buff *skb, struct net_device *dev);
-int cvm_oct_xmit_pow(struct sk_buff *skb, struct net_device *dev);
+netdev_tx_t cvm_oct_xmit(struct sk_buff *skb, struct net_device *dev);
+netdev_tx_t cvm_oct_xmit_pow(struct sk_buff *skb, struct net_device *dev);
 int cvm_oct_transmit_qos(struct net_device *dev, void *work_queue_entry,
 			 int do_free, int qos);
 void cvm_oct_tx_initialize(void);
-- 
2.35.1

