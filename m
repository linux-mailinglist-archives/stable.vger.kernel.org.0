Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0E3F6355B4
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237447AbiKWJWP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:22:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237570AbiKWJVv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:21:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EBB810B43F
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:21:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4862B81EF5
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:21:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ED0EC433D6;
        Wed, 23 Nov 2022 09:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195292;
        bh=4QgEydFWYE+iOzvndmU3IrAlgl9UyUzLDI7WJ3V13XQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ONk2dV5F24lm4r561C+nA9xPD23mLMFUWM78E/EyHrvVBwumvWGsPiNDXnXCDDsx5
         Sab603QkRk/RNyXfYlzHFBcaUByZEr62sLfGJhqjyulAv7uIaPM/ExewOE2LqBfXC+
         TgR+7LM/THcNLFg5MCWIe55Petk7akJJGZ8UoRBg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 026/149] spi: intel: Use correct mask for flash and protected regions
Date:   Wed, 23 Nov 2022 09:50:09 +0100
Message-Id: <20221123084558.949017098@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
References: <20221123084557.945845710@linuxfoundation.org>
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

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit 92a66cbf6b30eda5719fbdfb24cd15fb341bba32 ]

The flash and protected region mask is actually 0x7fff (30:16 and 14:0)
and not 0x3fff so fix this accordingly. While there use GENMASK() instead.

Cc: stable@vger.kernel.org
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Link: https://lore.kernel.org/r/20221025062800.22357-1-mika.westerberg@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/controllers/intel-spi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/spi-nor/controllers/intel-spi.c b/drivers/mtd/spi-nor/controllers/intel-spi.c
index 65f41c0781bf..6c802db6b4af 100644
--- a/drivers/mtd/spi-nor/controllers/intel-spi.c
+++ b/drivers/mtd/spi-nor/controllers/intel-spi.c
@@ -53,17 +53,17 @@
 #define FRACC				0x50
 
 #define FREG(n)				(0x54 + ((n) * 4))
-#define FREG_BASE_MASK			0x3fff
+#define FREG_BASE_MASK			GENMASK(14, 0)
 #define FREG_LIMIT_SHIFT		16
-#define FREG_LIMIT_MASK			(0x03fff << FREG_LIMIT_SHIFT)
+#define FREG_LIMIT_MASK			GENMASK(30, 16)
 
 /* Offset is from @ispi->pregs */
 #define PR(n)				((n) * 4)
 #define PR_WPE				BIT(31)
 #define PR_LIMIT_SHIFT			16
-#define PR_LIMIT_MASK			(0x3fff << PR_LIMIT_SHIFT)
+#define PR_LIMIT_MASK			GENMASK(30, 16)
 #define PR_RPE				BIT(15)
-#define PR_BASE_MASK			0x3fff
+#define PR_BASE_MASK			GENMASK(14, 0)
 
 /* Offsets are from @ispi->sregs */
 #define SSFSTS_CTL			0x00
-- 
2.35.1



