Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40BFB582BE6
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238801AbiG0Qj3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:39:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239370AbiG0QjN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:39:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCB725A2D2;
        Wed, 27 Jul 2022 09:28:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F444B821A6;
        Wed, 27 Jul 2022 16:28:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C602CC433C1;
        Wed, 27 Jul 2022 16:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939328;
        bh=fZCRhPWBOFQUBqV5FF//jX1LfJGFpbtLedILZSXCl8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qmi6dzNKf6OSxCEqJQb+bl02DlNWkf2WxwSfOHFNT5PDLMQY1LhWZCYsnzYX3QP4S
         81geYRO94Fkn+txAyN2ju5PQIuuGFT0M8sGfBFwIdT5FUV0DDlYhu/IM58tz3QOf8a
         5SXFXvsWiSVoTXB6dIy/RRbgsDMuihNNzI2J+Z/U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hacash Robot <hacashRobot@santino.com>,
        William Dean <williamsukatube@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 13/87] pinctrl: ralink: Check for null return of devm_kcalloc
Date:   Wed, 27 Jul 2022 18:10:06 +0200
Message-Id: <20220727161009.535088850@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161008.993711844@linuxfoundation.org>
References: <20220727161008.993711844@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: William Dean <williamsukatube@gmail.com>

[ Upstream commit c3b821e8e406d5650e587b7ac624ac24e9b780a8 ]

Because of the possible failure of the allocation, data->domains might
be NULL pointer and will cause the dereference of the NULL pointer
later.
Therefore, it might be better to check it and directly return -ENOMEM
without releasing data manually if fails, because the comment of the
devm_kmalloc() says "Memory allocated with this function is
automatically freed on driver detach.".

Fixes: a86854d0c599b ("treewide: devm_kzalloc() -> devm_kcalloc()")
Reported-by: Hacash Robot <hacashRobot@santino.com>
Signed-off-by: William Dean <williamsukatube@gmail.com>
Link: https://lore.kernel.org/r/20220710154922.2610876-1-williamsukatube@163.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/mt7621-pinctrl/pinctrl-rt2880.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/mt7621-pinctrl/pinctrl-rt2880.c b/drivers/staging/mt7621-pinctrl/pinctrl-rt2880.c
index 0ba4e4e070a9..7cfbdfb10e23 100644
--- a/drivers/staging/mt7621-pinctrl/pinctrl-rt2880.c
+++ b/drivers/staging/mt7621-pinctrl/pinctrl-rt2880.c
@@ -267,6 +267,8 @@ static int rt2880_pinmux_pins(struct rt2880_priv *p)
 						p->func[i]->pin_count,
 						sizeof(int),
 						GFP_KERNEL);
+		if (!p->func[i]->pins)
+			return -ENOMEM;
 		for (j = 0; j < p->func[i]->pin_count; j++)
 			p->func[i]->pins[j] = p->func[i]->pin_first + j;
 
-- 
2.35.1



