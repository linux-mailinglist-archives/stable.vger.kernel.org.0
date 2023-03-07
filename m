Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49B4D6AEA7C
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbjCGReZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:34:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbjCGReK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:34:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDBA59B986
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:29:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F8D561515
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:29:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94901C433D2;
        Tue,  7 Mar 2023 17:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210183;
        bh=fXzPbYK1dAhC782/uLVcdJd9IvDRrR+9sqOWzIGsKgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XpWA1Z5Q9Bt6iB1dEpImpb/S32wgXR1iHIjrW2cq1MFdSlcIHGMa1n573v9nNLRbM
         czKkpr3GFInTb/GksLCObu87k5Bopdk7DSoS3ltJ1N6pA6sHHjUkQhPcwFzb7sIsUy
         cU97+BqiQ9nkxaDHJ6HyQUlJc2K1yOYg9Ih4S86I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kursad Oney <kursad.oney@broadcom.com>,
        William Zhang <william.zhang@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0429/1001] spi: bcm63xx-hsspi: Endianness fix for ARM based SoC
Date:   Tue,  7 Mar 2023 17:53:21 +0100
Message-Id: <20230307170039.969288029@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: William Zhang <william.zhang@broadcom.com>

[ Upstream commit 85a84a61699990db6a025b5073f337f49933a875 ]

HSSPI controller uses big endian for the opcode in the message to the
controller ping pong buffer. Use cpu_to_be16 to properly handle the
endianness for both big and little endian host.

Fixes: 142168eba9dc ("spi: bcm63xx-hsspi: add bcm63xx HSSPI driver")
Signed-off-by: Kursad Oney <kursad.oney@broadcom.com>
Signed-off-by: William Zhang <william.zhang@broadcom.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>

Link: https://lore.kernel.org/r/20230207065826.285013-7-william.zhang@broadcom.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm63xx-hsspi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-bcm63xx-hsspi.c b/drivers/spi/spi-bcm63xx-hsspi.c
index b871fd810d801..a74345ed0e2ff 100644
--- a/drivers/spi/spi-bcm63xx-hsspi.c
+++ b/drivers/spi/spi-bcm63xx-hsspi.c
@@ -194,7 +194,7 @@ static int bcm63xx_hsspi_do_txrx(struct spi_device *spi, struct spi_transfer *t)
 			tx += curr_step;
 		}
 
-		__raw_writew(opcode | curr_step, bs->fifo);
+		__raw_writew((u16)cpu_to_be16(opcode | curr_step), bs->fifo);
 
 		/* enable interrupt */
 		__raw_writel(HSSPI_PINGx_CMD_DONE(0),
-- 
2.39.2



