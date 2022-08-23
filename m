Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCCC459D8FF
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242256AbiHWJl7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351818AbiHWJkd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:40:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B600779686;
        Tue, 23 Aug 2022 01:41:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 103E06152E;
        Tue, 23 Aug 2022 08:40:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14DD5C433C1;
        Tue, 23 Aug 2022 08:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244041;
        bh=UnsYK3CCZV3d4U2OT6f8xJcmMIqfdF3LWGKXGLp2kE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QeNYWMiPcAU7XSz8sblioW0AFHTwHleTTWA01yyccx8GKInLCtXC9H5uN3wkRx5Xw
         4n9F1R3wd6f5V2P7dxqsVQYoB5kdQ0Xck0LCHXBmU+8OZnKt0BU7y8BbGfK/GKvlpt
         8HPh5INeZwNKsXdzzI7+bN1gaMt8uus7Br+A9lgE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Christian Lamparter <chunkeey@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 077/229] wifi: p54: Fix an error handling path in p54spi_probe()
Date:   Tue, 23 Aug 2022 10:23:58 +0200
Message-Id: <20220823080056.464724503@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
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
index e41bf042352e..3dcfad5b61ff 100644
--- a/drivers/net/wireless/intersil/p54/p54spi.c
+++ b/drivers/net/wireless/intersil/p54/p54spi.c
@@ -177,7 +177,7 @@ static int p54spi_request_firmware(struct ieee80211_hw *dev)
 
 	ret = p54_parse_firmware(dev, priv->firmware);
 	if (ret) {
-		release_firmware(priv->firmware);
+		/* the firmware is released by the caller */
 		return ret;
 	}
 
@@ -672,6 +672,7 @@ static int p54spi_probe(struct spi_device *spi)
 	return 0;
 
 err_free_common:
+	release_firmware(priv->firmware);
 	free_irq(gpio_to_irq(p54spi_gpio_irq), spi);
 err_free_gpio_irq:
 	gpio_free(p54spi_gpio_irq);
-- 
2.35.1



