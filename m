Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 119306357C2
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:46:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238140AbiKWJoD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:44:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238142AbiKWJnn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:43:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7928A617D
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:41:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07A40B81E5E
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:41:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 413B1C433D6;
        Wed, 23 Nov 2022 09:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196474;
        bh=Nuj1WWfDFyu8QzYdkC5ugZRtZZWC5YOGO95/bvXF/oE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=buxze7citVPRjjZVL0Lu9Z1w877MAcqtjTPkjN/7aVk1Qfx4XT//szzQIjepvGFc/
         2s4J4FKceFUH9OmU0tPqlMylUksUni8OP6knw6n+zkKfqjDonyROAgMaM7WvF98La7
         i2kQSr3/NOfFnX+KNkBww3ymaARvXHkPiwSMnVR4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mauro Lima <mauro.lima@eclypsium.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 011/314] spi: intel: Fix the offset to get the 64K erase opcode
Date:   Wed, 23 Nov 2022 09:47:36 +0100
Message-Id: <20221123084626.007087477@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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

From: Mauro Lima <mauro.lima@eclypsium.com>

[ Upstream commit 6a43cd02ddbc597dc9a1f82c1e433f871a2f6f06 ]

According to documentation, the 64K erase opcode is located in VSCC
range [16:23] instead of [8:15].
Use the proper value to shift the mask over the correct range.

Signed-off-by: Mauro Lima <mauro.lima@eclypsium.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Link: https://lore.kernel.org/r/20221012152135.28353-1-mauro.lima@eclypsium.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-intel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-intel.c b/drivers/spi/spi-intel.c
index 3f6db482b6c7..a1dbd71bf83e 100644
--- a/drivers/spi/spi-intel.c
+++ b/drivers/spi/spi-intel.c
@@ -114,7 +114,7 @@
 #define ERASE_OPCODE_SHIFT		8
 #define ERASE_OPCODE_MASK		(0xff << ERASE_OPCODE_SHIFT)
 #define ERASE_64K_OPCODE_SHIFT		16
-#define ERASE_64K_OPCODE_MASK		(0xff << ERASE_OPCODE_SHIFT)
+#define ERASE_64K_OPCODE_MASK		(0xff << ERASE_64K_OPCODE_SHIFT)
 
 #define INTEL_SPI_TIMEOUT		5000 /* ms */
 #define INTEL_SPI_FIFO_SZ		64
-- 
2.35.1



