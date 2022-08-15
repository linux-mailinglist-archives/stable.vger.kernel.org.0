Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B89B594109
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243331AbiHOVTi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241870AbiHOVNw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:13:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A69E5723A;
        Mon, 15 Aug 2022 12:19:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DB686009B;
        Mon, 15 Aug 2022 19:19:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70380C433D6;
        Mon, 15 Aug 2022 19:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591189;
        bh=0UKjixtL0eNbQD7Gi+0rqyBPU1iqbuobQHBHws/8h70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rsh5hG/Wc5bYF/vXt48K7Ix8RYmQ8vD/gbfa3YRXkR8cvms5rBYnBVMXQgoWzYI8D
         /+nNbiX7YElthvfUmglURxhGM19M9HbgTlLGZbXogCAgU1fbDTYeIXXhk8NcFMMrLE
         cTWwkIPIx5Vwc9DMmJ+sjrs1PGBUqUSexzXrBdcY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Christian Lamparter <chunkeey@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0468/1095] wifi: p54: Fix an error handling path in p54spi_probe()
Date:   Mon, 15 Aug 2022 19:57:47 +0200
Message-Id: <20220815180448.961526283@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 83781f0162d080fec7dcb911afd1bc2f5ad04471 ]

If an error occurs after a successful call to p54spi_request_firmware(), it
must be undone by a corresponding release_firmware() as already done in
the error handling path of p54spi_request_firmware() and in the .remove()
function.

Add the missing call in the error handling path and remove it from
p54spi_request_firmware() now that it is the responsibility of the caller
to release the firmware

Fixes: cd8d3d321285 ("p54spi: p54spi driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Christian Lamparter <chunkeey@gmail.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/297d2547ff2ee627731662abceeab9dbdaf23231.1655068321.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intersil/p54/p54spi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intersil/p54/p54spi.c b/drivers/net/wireless/intersil/p54/p54spi.c
index f99b7ba69fc3..19152fd449ba 100644
--- a/drivers/net/wireless/intersil/p54/p54spi.c
+++ b/drivers/net/wireless/intersil/p54/p54spi.c
@@ -164,7 +164,7 @@ static int p54spi_request_firmware(struct ieee80211_hw *dev)
 
 	ret = p54_parse_firmware(dev, priv->firmware);
 	if (ret) {
-		release_firmware(priv->firmware);
+		/* the firmware is released by the caller */
 		return ret;
 	}
 
@@ -659,6 +659,7 @@ static int p54spi_probe(struct spi_device *spi)
 	return 0;
 
 err_free_common:
+	release_firmware(priv->firmware);
 	free_irq(gpio_to_irq(p54spi_gpio_irq), spi);
 err_free_gpio_irq:
 	gpio_free(p54spi_gpio_irq);
-- 
2.35.1



