Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78105472A4E
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243979AbhLMKiX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:38:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243882AbhLMKiN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:38:13 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3174C0A8872;
        Mon, 13 Dec 2021 01:50:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2BBF7CE0AE2;
        Mon, 13 Dec 2021 09:50:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD4AC341C8;
        Mon, 13 Dec 2021 09:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389050;
        bh=rtMG2C2eypS+jCdhY4ZDNuEnTr2zxKv+vDG4swO50f4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iTj6nIruMEb0M+LihOCHKyTDGs2KNxlRqP++ptLW2DH13Cf8T4rF/5oygmw/bdTCg
         9KJpgK9CYk2ex0ffooVcQLxPJPA2OvAMnoyM/EN9T3jySpJhGl0RnsE5CHaXuHzrtB
         SzYou5v5IdvTZAwkBw4nrPwYUeBBX7MmiwK2xOB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Miles Chen <miles.chen@mediatek.com>
Subject: [PATCH 5.10 083/132] clk: imx: use module_platform_driver
Date:   Mon, 13 Dec 2021 10:30:24 +0100
Message-Id: <20211213092941.969660619@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
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
@@ -231,7 +231,7 @@ static struct platform_driver imx8qxp_lp
 	.probe = imx8qxp_lpcg_clk_probe,
 };
 
-builtin_platform_driver(imx8qxp_lpcg_clk_driver);
+module_platform_driver(imx8qxp_lpcg_clk_driver);
 
 MODULE_AUTHOR("Aisheng Dong <aisheng.dong@nxp.com>");
 MODULE_DESCRIPTION("NXP i.MX8QXP LPCG clock driver");
--- a/drivers/clk/imx/clk-imx8qxp.c
+++ b/drivers/clk/imx/clk-imx8qxp.c
@@ -151,7 +151,7 @@ static struct platform_driver imx8qxp_cl
 	},
 	.probe = imx8qxp_clk_probe,
 };
-builtin_platform_driver(imx8qxp_clk_driver);
+module_platform_driver(imx8qxp_clk_driver);
 
 MODULE_AUTHOR("Aisheng Dong <aisheng.dong@nxp.com>");
 MODULE_DESCRIPTION("NXP i.MX8QXP clock driver");


