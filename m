Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7269E47FF3A
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238095AbhL0PgV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:36:21 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36164 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238270AbhL0Pf4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:35:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 285C6610A5;
        Mon, 27 Dec 2021 15:35:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2195C36AE7;
        Mon, 27 Dec 2021 15:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619355;
        bh=oEKU2/ZoP10MJ0z2k847Ftzf6S51ux60zDKKu8QlbiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SOvAUS+xSie4x+CK9opWneRKPquXtDZVnU4PnOJrv+loe6YKDWqdtgwx8NuPUK2K3
         fiDgN1QPDeWql44uBOT16E2TV9Iq3ghCNgPpM4f1++TO/mt0d+zG0dYdZyqKhiT+jL
         NyztcpHtFhyGQa2O03IUsNiBl9jBK05tzXnVITRw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Guodong Liu <guodong.liu@mediatek.corp-partner.google.com>,
        Zhiyong Tao <zhiyong.tao@mediatek.com>,
        Chen-Yu Tsai <wenst@chromium.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.4 41/47] pinctrl: mediatek: fix global-out-of-bounds issue
Date:   Mon, 27 Dec 2021 16:31:17 +0100
Message-Id: <20211227151322.218665742@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151320.801714429@linuxfoundation.org>
References: <20211227151320.801714429@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guodong Liu <guodong.liu@mediatek.corp-partner.google.com>

commit 2d5446da5acecf9c67db1c9d55ae2c3e5de01f8d upstream.

When eint virtual eint number is greater than gpio number,
it maybe produce 'desc[eint_n]' size globle-out-of-bounds issue.

Signed-off-by: Guodong Liu <guodong.liu@mediatek.corp-partner.google.com>
Signed-off-by: Zhiyong Tao <zhiyong.tao@mediatek.com>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://lore.kernel.org/r/20211110071900.4490-2-zhiyong.tao@mediatek.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c
@@ -236,8 +236,12 @@ static int mtk_xt_get_gpio_n(void *data,
 	desc = (const struct mtk_pin_desc *)hw->soc->pins;
 	*gpio_chip = &hw->chip;
 
-	/* Be greedy to guess first gpio_n is equal to eint_n */
-	if (desc[eint_n].eint.eint_n == eint_n)
+	/*
+	 * Be greedy to guess first gpio_n is equal to eint_n.
+	 * Only eint virtual eint number is greater than gpio number.
+	 */
+	if (hw->soc->npins > eint_n &&
+	    desc[eint_n].eint.eint_n == eint_n)
 		*gpio_n = eint_n;
 	else
 		*gpio_n = mtk_xt_find_eint_num(hw, eint_n);


