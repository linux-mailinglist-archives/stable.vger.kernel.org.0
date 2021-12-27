Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94FBA48000F
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239011AbhL0Pms (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:42:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239009AbhL0PlB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:41:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 839F4C08E88C;
        Mon, 27 Dec 2021 07:39:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2142261118;
        Mon, 27 Dec 2021 15:39:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06300C36AEA;
        Mon, 27 Dec 2021 15:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619574;
        bh=+VzOVk8c3+Tnef8ZiGHALGqqL3DECjSAnu6MER17gyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CLK+8IeujIV0u70sZ3KqEiNoeMMVGl0vpGN6AjzybCWsBMZr68wOlWqzujQz2Eb0W
         gP6G+Mu4R8f+fmXY24BlWXJ8M1Gree2sA0FpsfFHmpRxSAZN9YLq2hsnsen7ngIzFJ
         4M32JpP2ADgT2x+l3YWyQQl0U5vlIVUE6WUMiDl8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Guodong Liu <guodong.liu@mediatek.corp-partner.google.com>,
        Zhiyong Tao <zhiyong.tao@mediatek.com>,
        Chen-Yu Tsai <wenst@chromium.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.10 70/76] pinctrl: mediatek: fix global-out-of-bounds issue
Date:   Mon, 27 Dec 2021 16:31:25 +0100
Message-Id: <20211227151327.116415333@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151324.694661623@linuxfoundation.org>
References: <20211227151324.694661623@linuxfoundation.org>
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
@@ -280,8 +280,12 @@ static int mtk_xt_get_gpio_n(void *data,
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


