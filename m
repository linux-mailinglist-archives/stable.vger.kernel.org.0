Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54E53548C55
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241756AbiFMKQv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241855AbiFMKQS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:16:18 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33649DFE1;
        Mon, 13 Jun 2022 03:15:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 284E6CE116E;
        Mon, 13 Jun 2022 10:15:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33506C3411C;
        Mon, 13 Jun 2022 10:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655115305;
        bh=nenEibBJQkf8B+U53841xOeYfUma/aYeU1WO7LivkSI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AHORgVgNAaeemZCGt820jIgI5ogTnG60neiYbGHsajAETS5PKLwHp5RbgZzrkdmrO
         ldxzlMpTyErDFJjwBoig0/60PLl7QxhtmlF3naafrL/Jr2MgLxSKN5m9Ke1CFGk4xu
         svf0DEYlr4W5i2mTUIGUHsyG+Y12Nlxb+Vz5qDgE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 026/167] eth: tg3: silence the GCC 12 array-bounds warning
Date:   Mon, 13 Jun 2022 12:08:20 +0200
Message-Id: <20220613094846.913893676@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094840.720778945@linuxfoundation.org>
References: <20220613094840.720778945@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 9dec850fd7c210a04b4707df8e6c95bfafdd6a4b ]

GCC 12 currently generates a rather inconsistent warning:

drivers/net/ethernet/broadcom/tg3.c:17795:51: warning: array subscript 5 is above array bounds of ‘struct tg3_napi[5]’ [-Warray-bounds]
17795 |                 struct tg3_napi *tnapi = &tp->napi[i];
      |                                           ~~~~~~~~^~~

i is guaranteed < tp->irq_max which in turn is either 1 or 5.
There are more loops like this one in the driver, but strangely
GCC 12 dislikes only this single one.

Silence this silliness for now.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/Makefile | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/Makefile b/drivers/net/ethernet/broadcom/Makefile
index 79f2372c66ec..4211c6cd6b35 100644
--- a/drivers/net/ethernet/broadcom/Makefile
+++ b/drivers/net/ethernet/broadcom/Makefile
@@ -15,3 +15,8 @@ obj-$(CONFIG_BGMAC_BCMA) += bgmac-bcma.o bgmac-bcma-mdio.o
 obj-$(CONFIG_BGMAC_PLATFORM) += bgmac-platform.o
 obj-$(CONFIG_SYSTEMPORT) += bcmsysport.o
 obj-$(CONFIG_BNXT) += bnxt/
+
+# FIXME: temporarily silence -Warray-bounds on non W=1+ builds
+ifndef KBUILD_EXTRA_WARN
+CFLAGS_tg3.o += -Wno-array-bounds
+endif
-- 
2.35.1



