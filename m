Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC63062142F
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234305AbiKHN6Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:58:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234857AbiKHN6P (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:58:15 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CB8D63F0
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:58:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6BF5FCE1B94
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:58:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 307C5C433C1;
        Tue,  8 Nov 2022 13:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915890;
        bh=BQwo9hfsiwVPOQyyAzrORC8RUrMblkwCLCzIcx+o5BE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A7s0wBygEgyQZ++MoHnLdtg+sm80MUj0mAzhpwYWNQzgOQT3+lmXXC310j1rSGTct
         dMZq/5q9k8sLvMzfDZq5hty+uMz0XWsWgfkEOvYQLp5KqLPqTBPUhUk/T3Jt5BU+D6
         A2zjghHIISe0YVzMR/uAmSRxpG1Orz/HYmlS93+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Brian Norris <briannorris@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 5.10 114/118] drm/rockchip: dsi: Force synchronous probe
Date:   Tue,  8 Nov 2022 14:39:52 +0100
Message-Id: <20221108133345.641594440@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Norris <briannorris@chromium.org>

commit 81e592f86f7afdb76d655e7fbd7803d7b8f985d8 upstream.

We can't safely probe a dual-DSI display asynchronously
(driver_async_probe='*' or driver_async_probe='dw-mipi-dsi-rockchip'
cmdline), because dw_mipi_dsi_rockchip_find_second() pokes one DSI
device's drvdata from the other device without any locking.

Request synchronous probe, at least until this driver learns some
appropriate locking for dual-DSI initialization.

Cc: <stable@vger.kernel.org>
Signed-off-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20221019170255.2.I6b985b0ca372b7e35c6d9ea970b24bcb262d4fc1@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c
+++ b/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c
@@ -1286,5 +1286,11 @@ struct platform_driver dw_mipi_dsi_rockc
 		.of_match_table = dw_mipi_dsi_rockchip_dt_ids,
 		.pm	= &dw_mipi_dsi_rockchip_pm_ops,
 		.name	= "dw-mipi-dsi-rockchip",
+		/*
+		 * For dual-DSI display, one DSI pokes at the other DSI's
+		 * drvdata in dw_mipi_dsi_rockchip_find_second(). This is not
+		 * safe for asynchronous probe.
+		 */
+		.probe_type = PROBE_FORCE_SYNCHRONOUS,
 	},
 };


