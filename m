Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB81617F933
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728992AbgCJMyl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:54:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:33160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728574AbgCJMyj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:54:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE4F420674;
        Tue, 10 Mar 2020 12:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844879;
        bh=gT28lgSALOjg9Oy2Uz9uwJz0kp5lejbDlA6KiD7JrIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z2yS+4nKLCwDupp9EXNK3LsqOx3xBgTlahmC1z9kQlByxL3+4nFKmQPOo492s4nRr
         jLyyCymvzj6ebFyLPounv1X6L+5tNz0YoD1m3DFr7AeXKsdUrFF8972Et3XtGDAglu
         /66pwRDNSLe4A/3vA2cJodTIKRNeGsXiXeyGsA/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Jonas Gorski <jonas.gorski@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 114/168] spi: bcm63xx-hsspi: Really keep pll clk enabled
Date:   Tue, 10 Mar 2020 13:39:20 +0100
Message-Id: <20200310123646.963911379@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 51bddd4501bc414b8b1e8f4d096b4a5304068169 upstream.

The purpose of commit 0fd85869c2a9 ("spi/bcm63xx-hsspi: keep pll clk enabled")
was to keep the pll clk enabled through the lifetime of the device.

In order to do that, some 'clk_prepare_enable()'/'clk_disable_unprepare()'
calls have been added in the error handling path of the probe function, in
the remove function and in the suspend and resume functions.

However, a 'clk_disable_unprepare()' call has been unfortunately left in
the probe function. So the commit seems to be more or less a no-op.

Axe it now, so that the pll clk is left enabled through the lifetime of
the device, as described in the commit.

Fixes: 0fd85869c2a9 ("spi/bcm63xx-hsspi: keep pll clk enabled")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Jonas Gorski <jonas.gorski@gmail.com>
Link: https://lore.kernel.org/r/20200228213838.7124-1-christophe.jaillet@wanadoo.fr
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-bcm63xx-hsspi.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/spi/spi-bcm63xx-hsspi.c
+++ b/drivers/spi/spi-bcm63xx-hsspi.c
@@ -367,7 +367,6 @@ static int bcm63xx_hsspi_probe(struct pl
 			goto out_disable_clk;
 
 		rate = clk_get_rate(pll_clk);
-		clk_disable_unprepare(pll_clk);
 		if (!rate) {
 			ret = -EINVAL;
 			goto out_disable_pll_clk;


