Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 413485408F5
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349672AbiFGSEJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351794AbiFGSCV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:02:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8974131283;
        Tue,  7 Jun 2022 10:45:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5485361650;
        Tue,  7 Jun 2022 17:45:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63032C385A5;
        Tue,  7 Jun 2022 17:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623926;
        bh=sm8MbBlNG5K6X9hLCmzFjLBYl5czMKscsEUm5HoPOMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f9n91zQJSL/tTLszciMakvC7VojfvmLLVsP/rF9BUz3P1+xKqgHuATBaoqV1VNxMt
         i3mnv5YGAasu8mCE25nMo2LU3HP/DvGl0H3gVxVJp79GXgCZl15MuflmKNI2dRVpGD
         ubfk6eJdEC6sCtyd9v5Wb3wg8jfBpamh2WjG+fqg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 143/667] eth: tg3: silence the GCC 12 array-bounds warning
Date:   Tue,  7 Jun 2022 18:56:48 +0200
Message-Id: <20220607164939.109211454@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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
index 0ddfb5b5d53c..2e6c5f258a1f 100644
--- a/drivers/net/ethernet/broadcom/Makefile
+++ b/drivers/net/ethernet/broadcom/Makefile
@@ -17,3 +17,8 @@ obj-$(CONFIG_BGMAC_BCMA) += bgmac-bcma.o bgmac-bcma-mdio.o
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



