Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F09F3582FD7
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242180AbiG0RaZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242292AbiG0R3U (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:29:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD0E452466;
        Wed, 27 Jul 2022 09:47:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2CA2BB821BE;
        Wed, 27 Jul 2022 16:47:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DABAC433B5;
        Wed, 27 Jul 2022 16:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940451;
        bh=lBNpbwAz4MluJai4tIGarwcVNMTQu6FMGiQvNRLpuZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OZPJas7Xc6Q1PvAd0fM11cDDCVP0138e0v4HrfAg/UOLgbwbWH1Ew3gAXHjLeiXQg
         +CqxrDgeY1UMSCC81vl93UUxGxKBbgG089+ilNUxpuLV8jQN1zEdPwrpRomOAVSgdd
         MMfrFvq/2gnvyEt8ePd/2ujaOaC0CFTbREPsWGmo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hacash Robot <hacashRobot@santino.com>,
        William Dean <williamsukatube@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 027/158] pinctrl: ralink: Check for null return of devm_kcalloc
Date:   Wed, 27 Jul 2022 18:11:31 +0200
Message-Id: <20220727161022.566725196@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
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
 drivers/pinctrl/ralink/pinctrl-ralink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pinctrl/ralink/pinctrl-ralink.c b/drivers/pinctrl/ralink/pinctrl-ralink.c
index 841f23f55c95..3a8268a43d74 100644
--- a/drivers/pinctrl/ralink/pinctrl-ralink.c
+++ b/drivers/pinctrl/ralink/pinctrl-ralink.c
@@ -266,6 +266,8 @@ static int ralink_pinmux_pins(struct ralink_priv *p)
 						p->func[i]->pin_count,
 						sizeof(int),
 						GFP_KERNEL);
+		if (!p->func[i]->pins)
+			return -ENOMEM;
 		for (j = 0; j < p->func[i]->pin_count; j++)
 			p->func[i]->pins[j] = p->func[i]->pin_first + j;
 
-- 
2.35.1



