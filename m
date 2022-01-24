Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7F5A49A9B2
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:27:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384264AbiAYD04 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:26:56 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56624 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445413AbiAXVDX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:03:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70498B812A4;
        Mon, 24 Jan 2022 21:03:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA448C36AE9;
        Mon, 24 Jan 2022 21:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058199;
        bh=AMRrFw241ZNcJROd7kDoE1b/E1gc3bQHomw3ZEgExvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fIxbrJG/gkN6iU5uB8kco8LitLSs9BPG9TzaIyGjVdfabo5pQHHhcHrU299Sxqfux
         2Ln6lq6DlqdRBlHwrSycJgjYJLFJciS2rt6SvzXSvf5jEaPCcDUgUQTDU83c7DEKIV
         vrsN4ZoZn/qJujq2tTXEopc+XFSkHwk3rgOcAga0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0211/1039] pinctrl: mediatek: add a check for error in mtk_pinconf_bias_get_rsel()
Date:   Mon, 24 Jan 2022 19:33:20 +0100
Message-Id: <20220124184132.426242390@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 9f9d17c228c89e38ed612500126daf626270be9a ]

All the other mtk_hw_get_value() calls have a check for "if (err)" so
we can add one here as well.  This silences a Smatch warning:

    drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c:819 mtk_pinconf_bias_get_rsel()
    error: uninitialized symbol 'pd'.

Fixes: fb34a9ae383a ("pinctrl: mediatek: support rsel feature")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20211127140836.GB24002@kili
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c b/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c
index 53779822348da..e1ae3beb9f72b 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c
@@ -815,6 +815,8 @@ static int mtk_pinconf_bias_get_rsel(struct mtk_pinctrl *hw,
 		goto out;
 
 	err = mtk_hw_get_value(hw, desc, PINCTRL_PIN_REG_PD, &pd);
+	if (err)
+		goto out;
 
 	if (pu == 0 && pd == 0) {
 		*pullup = 0;
-- 
2.34.1



