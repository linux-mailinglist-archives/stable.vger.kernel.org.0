Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3230B4ABBB0
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:39:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384718AbiBGL3m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:29:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383297AbiBGLWD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:22:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4097C043188;
        Mon,  7 Feb 2022 03:22:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0AC75B8111C;
        Mon,  7 Feb 2022 11:22:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25B27C340EB;
        Mon,  7 Feb 2022 11:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232919;
        bh=ndaHqpqn4sqHYZzskELwPY5K5zp5TlQe607bssm09fg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G+gPd3utcUirev3nrl05fMXo8bqFRMW6rqQA499cy8cHICUzolBvKjzSVZHqmusfF
         7PMw+SksDezGOyXq3e0Oh6EsCs3aRr16S3ifgxlmmq9xXggsA9goYPHocbOfAKSlZ5
         vlJwfMqpfHtBE2QFUnyLgDc93bnktRqEDZTxesXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 34/74] spi: meson-spicc: add IRQ check in meson_spicc_probe
Date:   Mon,  7 Feb 2022 12:06:32 +0100
Message-Id: <20220207103758.353862017@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103757.232676988@linuxfoundation.org>
References: <20220207103757.232676988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

commit e937440f7fc444a3e3f1fb75ea65292d6f433a44 upstream.

This check misses checking for  platform_get_irq()'s call and may passes
the negative error codes to devm_request_irq(), which takes unsigned IRQ #,
causing it to fail with -EINVAL, overriding an original error code.
Stop calling devm_request_irq() with invalid IRQ #s.

Fixes: 454fa271bc4e ("spi: Add Meson SPICC driver")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220126110447.24549-1-linmq006@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-meson-spicc.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/spi/spi-meson-spicc.c
+++ b/drivers/spi/spi-meson-spicc.c
@@ -693,6 +693,11 @@ static int meson_spicc_probe(struct plat
 	writel_relaxed(0, spicc->base + SPICC_INTREG);
 
 	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		ret = irq;
+		goto out_master;
+	}
+
 	ret = devm_request_irq(&pdev->dev, irq, meson_spicc_irq,
 			       0, NULL, spicc);
 	if (ret) {


