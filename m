Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC89B4B4A3C
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:38:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345711AbiBNKOy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:14:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345891AbiBNKOL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:14:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6776667355;
        Mon, 14 Feb 2022 01:52:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F18F360DFE;
        Mon, 14 Feb 2022 09:52:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2A9CC36AE3;
        Mon, 14 Feb 2022 09:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832339;
        bh=4Ww7YY60vIbpvXUj1vAzBR+a7Waun+OVFOKjDCpCtdk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JB8AOctlOyCzmRQW1m0DkCtdGzCW+lI4k8FeVGCOQLtldewt2a/cas1v0x/gJBIvz
         6ntF+T63xIs0R9uoyvi/ARikRDWVcR5aD8s4vxLf+C1J14ja11/hkkSWTlRC1jpw+m
         Dqp+SNCrb2ikOEuF/v5uD2JrWe8dbT186df3r5aE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 155/172] phy: ti: Fix missing sentinel for clk_div_table
Date:   Mon, 14 Feb 2022 10:26:53 +0100
Message-Id: <20220214092511.752273580@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kishon Vijay Abraham I <kishon@ti.com>

commit 6d1e6bcb31663ee83aaea1f171f3dbfe95dd4a69 upstream.

_get_table_maxdiv() tries to access "clk_div_table" array out of bound
defined in phy-j721e-wiz.c. Add a sentinel entry to prevent
the following global-out-of-bounds error reported by enabling KASAN.

[    9.552392] BUG: KASAN: global-out-of-bounds in _get_maxdiv+0xc0/0x148
[    9.558948] Read of size 4 at addr ffff8000095b25a4 by task kworker/u4:1/38
[    9.565926]
[    9.567441] CPU: 1 PID: 38 Comm: kworker/u4:1 Not tainted 5.16.0-116492-gdaadb3bd0e8d-dirty #360
[    9.576242] Hardware name: Texas Instruments J721e EVM (DT)
[    9.581832] Workqueue: events_unbound deferred_probe_work_func
[    9.587708] Call trace:
[    9.590174]  dump_backtrace+0x20c/0x218
[    9.594038]  show_stack+0x18/0x68
[    9.597375]  dump_stack_lvl+0x9c/0xd8
[    9.601062]  print_address_description.constprop.0+0x78/0x334
[    9.606830]  kasan_report+0x1f0/0x260
[    9.610517]  __asan_load4+0x9c/0xd8
[    9.614030]  _get_maxdiv+0xc0/0x148
[    9.617540]  divider_determine_rate+0x88/0x488
[    9.622005]  divider_round_rate_parent+0xc8/0x124
[    9.626729]  wiz_clk_div_round_rate+0x54/0x68
[    9.631113]  clk_core_determine_round_nolock+0x124/0x158
[    9.636448]  clk_core_round_rate_nolock+0x68/0x138
[    9.641260]  clk_core_set_rate_nolock+0x268/0x3a8
[    9.645987]  clk_set_rate+0x50/0xa8
[    9.649499]  cdns_sierra_phy_init+0x88/0x248
[    9.653794]  phy_init+0x98/0x108
[    9.657046]  cdns_pcie_enable_phy+0xa0/0x170
[    9.661340]  cdns_pcie_init_phy+0x250/0x2b0
[    9.665546]  j721e_pcie_probe+0x4b8/0x798
[    9.669579]  platform_probe+0x8c/0x108
[    9.673350]  really_probe+0x114/0x630
[    9.677037]  __driver_probe_device+0x18c/0x220
[    9.681505]  driver_probe_device+0xac/0x150
[    9.685712]  __device_attach_driver+0xec/0x170
[    9.690178]  bus_for_each_drv+0xf0/0x158
[    9.694124]  __device_attach+0x184/0x210
[    9.698070]  device_initial_probe+0x14/0x20
[    9.702277]  bus_probe_device+0xec/0x100
[    9.706223]  deferred_probe_work_func+0x124/0x180
[    9.710951]  process_one_work+0x4b0/0xbc0
[    9.714983]  worker_thread+0x74/0x5d0
[    9.718668]  kthread+0x214/0x230
[    9.721919]  ret_from_fork+0x10/0x20
[    9.725520]
[    9.727032] The buggy address belongs to the variable:
[    9.732183]  clk_div_table+0x24/0x440

Fixes: 091876cc355d ("phy: ti: j721e-wiz: Add support for WIZ module present in TI J721E SoC")
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Link: https://lore.kernel.org/r/20220117110108.4117-1-kishon@ti.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/ti/phy-j721e-wiz.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/phy/ti/phy-j721e-wiz.c
+++ b/drivers/phy/ti/phy-j721e-wiz.c
@@ -233,6 +233,7 @@ static const struct clk_div_table clk_di
 	{ .val = 1, .div = 2, },
 	{ .val = 2, .div = 4, },
 	{ .val = 3, .div = 8, },
+	{ /* sentinel */ },
 };
 
 static const struct wiz_clk_div_sel clk_div_sel[] = {


