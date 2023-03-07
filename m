Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 963B36AEF48
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232719AbjCGSWf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:22:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232430AbjCGSWP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:22:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B61A5AB08A
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:16:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7460FB81851
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:16:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7F8AC433EF;
        Tue,  7 Mar 2023 18:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212967;
        bh=fXzPbYK1dAhC782/uLVcdJd9IvDRrR+9sqOWzIGsKgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QN0z+sXN+bDlWosz9LBpWkWQfQh+Pe4V2m1HybdWkkJDVuw25Xm4j09tGrfRCmi7H
         HoFd7nrAZdcCZi01ih+nucKhGWkf3//vqcYfY6uVVpJoPDn8lOzzkmJsD1lYOZz5Sx
         GskEKjoDPpmDy5/sxf4W8TTHGwiwfpBts9REG0+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kursad Oney <kursad.oney@broadcom.com>,
        William Zhang <william.zhang@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 356/885] spi: bcm63xx-hsspi: Endianness fix for ARM based SoC
Date:   Tue,  7 Mar 2023 17:54:50 +0100
Message-Id: <20230307170017.732793023@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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



