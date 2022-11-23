Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67EEE635489
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:08:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237077AbiKWJIE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:08:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237079AbiKWJH2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:07:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9375E105582
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:07:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E6F461B4C
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:07:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29F89C433D6;
        Wed, 23 Nov 2022 09:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194435;
        bh=17nVzYZDlxOShlzcokmJyNZashaE+MB7kmghc896PYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=seRVJ7ngoiahmY9gq9Mk6J2QtNnXvw0SA+4VM1jafVWiuiCLHnYxK/MQo0CpEEoaR
         01jC8zY/obFhWo5B3+qnUIR1EF+nDkrdl7QS0y/e2voCpHu3K+M5j6/teEtkSfmLs/
         Ah75xyzvpCv46zHDnxQQOYCi0U25dI0dfM+ps1xk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mauro Lima <mauro.lima@eclypsium.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 046/114] spi: intel: Fix the offset to get the 64K erase opcode
Date:   Wed, 23 Nov 2022 09:50:33 +0100
Message-Id: <20221123084553.687405407@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084551.864610302@linuxfoundation.org>
References: <20221123084551.864610302@linuxfoundation.org>
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
 drivers/mtd/spi-nor/intel-spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/spi-nor/intel-spi.c b/drivers/mtd/spi-nor/intel-spi.c
index d60cbf23d9aa..642a6f9071f2 100644
--- a/drivers/mtd/spi-nor/intel-spi.c
+++ b/drivers/mtd/spi-nor/intel-spi.c
@@ -116,7 +116,7 @@
 #define ERASE_OPCODE_SHIFT		8
 #define ERASE_OPCODE_MASK		(0xff << ERASE_OPCODE_SHIFT)
 #define ERASE_64K_OPCODE_SHIFT		16
-#define ERASE_64K_OPCODE_MASK		(0xff << ERASE_OPCODE_SHIFT)
+#define ERASE_64K_OPCODE_MASK		(0xff << ERASE_64K_OPCODE_SHIFT)
 
 #define INTEL_SPI_TIMEOUT		5000 /* ms */
 #define INTEL_SPI_FIFO_SZ		64
-- 
2.35.1



