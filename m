Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3BC4ABA6A
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383687AbiBGLXZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:23:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381510AbiBGLRL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:17:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C02BC0401D2;
        Mon,  7 Feb 2022 03:17:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A93646126D;
        Mon,  7 Feb 2022 11:16:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88DC0C004E1;
        Mon,  7 Feb 2022 11:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232619;
        bh=Fi5FmP3vg78vf+vuAoyI4qaqL8RRmG0PE5bYYQm08KI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S00cdXgwBxdWsR5BlfZZWdr7J6cw7vDekJtSzOIJmGqeXzpHS4t9rLevPrvlJCm6h
         O2ANp3GZje6wGsEnuaYE9U7TzxaSU7q2gSbbAkM8ZFRJJIcGmRzEEVjDtfo+2eeUQI
         jkb2KcKQiQ1j4JlxzkzQrihY/W8Q/aTQ5Fnhzh1w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.19 69/86] spi: meson-spicc: add IRQ check in meson_spicc_probe
Date:   Mon,  7 Feb 2022 12:06:32 +0100
Message-Id: <20220207103759.932004839@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103757.550973048@linuxfoundation.org>
References: <20220207103757.550973048@linuxfoundation.org>
User-Agent: quilt/0.66
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
@@ -529,6 +529,11 @@ static int meson_spicc_probe(struct plat
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


