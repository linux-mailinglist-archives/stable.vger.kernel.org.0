Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 871E4472769
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236502AbhLMKAj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:00:39 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:47128 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237773AbhLMJ6f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:58:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D3E1ACE0EF8;
        Mon, 13 Dec 2021 09:58:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B29BC34601;
        Mon, 13 Dec 2021 09:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389511;
        bh=Z2NymqUIz1V9OJSHo5TZkY8k2XeW/+MxINcapfiYSDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TbdwLaBV8DijnIq71bgLZUW8558IAFtfhRA2Aij1+wgGzTsHwW5L6FhVfsPceSuSF
         BakH4QLNw1mKGJjhkoDYP8IInq0DOk8S/Ul1tM1Q8Lttj7VptjFDY0PVnLBNRZsyX1
         7LyOP9ZbGEBW/lneif2+IfV9Rdrjyx77Y0ALl4G0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Miles Chen <miles.chen@mediatek.com>
Subject: [PATCH 5.15 116/171] clk: imx: use module_platform_driver
Date:   Mon, 13 Dec 2021 10:30:31 +0100
Message-Id: <20211213092948.961672155@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miles Chen <miles.chen@mediatek.com>

commit eee377b8f44e7ac4f76bbf2440e5cbbc1d25c25f upstream.

Replace builtin_platform_driver_probe with module_platform_driver_probe
because CONFIG_CLK_IMX8QXP can be set to =m (kernel module).

Fixes: e0d0d4d86c766 ("clk: imx8qxp: Support building i.MX8QXP clock driver as module")
Cc: Fabio Estevam <festevam@gmail.com>
Cc: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Miles Chen <miles.chen@mediatek.com>
Link: https://lore.kernel.org/r/20210904235418.2442-1-miles.chen@mediatek.com
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Reviewed-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/imx/clk-imx8qxp-lpcg.c |    2 +-
 drivers/clk/imx/clk-imx8qxp.c      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/clk/imx/clk-imx8qxp-lpcg.c
+++ b/drivers/clk/imx/clk-imx8qxp-lpcg.c
@@ -370,7 +370,7 @@ static struct platform_driver imx8qxp_lp
 	.probe = imx8qxp_lpcg_clk_probe,
 };
 
-builtin_platform_driver(imx8qxp_lpcg_clk_driver);
+module_platform_driver(imx8qxp_lpcg_clk_driver);
 
 MODULE_AUTHOR("Aisheng Dong <aisheng.dong@nxp.com>");
 MODULE_DESCRIPTION("NXP i.MX8QXP LPCG clock driver");
--- a/drivers/clk/imx/clk-imx8qxp.c
+++ b/drivers/clk/imx/clk-imx8qxp.c
@@ -308,7 +308,7 @@ static struct platform_driver imx8qxp_cl
 	},
 	.probe = imx8qxp_clk_probe,
 };
-builtin_platform_driver(imx8qxp_clk_driver);
+module_platform_driver(imx8qxp_clk_driver);
 
 MODULE_AUTHOR("Aisheng Dong <aisheng.dong@nxp.com>");
 MODULE_DESCRIPTION("NXP i.MX8QXP clock driver");


