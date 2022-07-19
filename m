Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBA51579F09
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242975AbiGSNKK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 09:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243268AbiGSNJM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 09:09:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D56962A41;
        Tue, 19 Jul 2022 05:28:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10E4A60DEB;
        Tue, 19 Jul 2022 12:28:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8C1FC341C6;
        Tue, 19 Jul 2022 12:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233694;
        bh=mlyiupWzoaqCGlzd2A4M2PlghwEdsgGXG2cqiizqiTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=diFMR5WnXqQFF6QizKasJ+ZoDmO26Bn/E79oURuqLGw4AMWKvoiYQVbEKsho0kUQF
         bKl473+IU+QDfPwyCGlmThX9uEq1kU6oI4VBkjbnKKebYOdi+PHWB4+iJPNPc6uEXd
         pZ+cjgKXCW3n81I42JN9oGugzL6IUk3uYeymr5tg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacky Bai <ping.bai@nxp.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 208/231] pinctrl: imx: Add the zero base flag for imx93
Date:   Tue, 19 Jul 2022 13:54:53 +0200
Message-Id: <20220719114731.416809654@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacky Bai <ping.bai@nxp.com>

[ Upstream commit fbc24ebc65507feb9728dc38197f90486148dda0 ]

On i.MX93, the pin mux reg offset is from 0x0,
so need to add the 'ZERO_OFFSET_VALID' flag to make
sure the pin at mux offset 0 can be found.

Signed-off-by: Jacky Bai <ping.bai@nxp.com>
Link: https://lore.kernel.org/r/20220613031854.1571357-1-ping.bai@nxp.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/freescale/pinctrl-imx93.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/freescale/pinctrl-imx93.c b/drivers/pinctrl/freescale/pinctrl-imx93.c
index c0630f69e995..417e41b37a6f 100644
--- a/drivers/pinctrl/freescale/pinctrl-imx93.c
+++ b/drivers/pinctrl/freescale/pinctrl-imx93.c
@@ -239,6 +239,7 @@ static const struct pinctrl_pin_desc imx93_pinctrl_pads[] = {
 static const struct imx_pinctrl_soc_info imx93_pinctrl_info = {
 	.pins = imx93_pinctrl_pads,
 	.npins = ARRAY_SIZE(imx93_pinctrl_pads),
+	.flags = ZERO_OFFSET_VALID,
 	.gpr_compatible = "fsl,imx93-iomuxc-gpr",
 };
 
-- 
2.35.1



