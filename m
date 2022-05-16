Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB25B528EED
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 21:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345858AbiEPTod (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 15:44:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345854AbiEPTmL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:42:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9631041322;
        Mon, 16 May 2022 12:40:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2EE8614B6;
        Mon, 16 May 2022 19:40:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F2B3C385AA;
        Mon, 16 May 2022 19:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730043;
        bh=oE7W6xw29WDDgIV+YB10Eo+LSQnZt2ZhTkmKIST7jmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cj5RNqlYMfUNKA/HtQm47LhZxAm41q3HWM02OTErwdT5SobsuXHeVGG41OkUTktyR
         owtwmmlk3uv83QTVnqYFhvDp9mV6eq7UXBmrWA6K7Wfg6t9sH6Pykd5tHe9HvOX5wp
         ns6hnyEDy64LgAg4Tb9mi3YroWBf8NAQaOXoyt6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Habets <habetsm.xilinx@gmail.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 13/32] net: sfc: ef10: fix memory leak in efx_ef10_mtd_probe()
Date:   Mon, 16 May 2022 21:36:27 +0200
Message-Id: <20220516193615.169017131@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193614.773450018@linuxfoundation.org>
References: <20220516193614.773450018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 1fa89ffbc04545b7582518e57f4b63e2a062870f ]

In the NIC ->probe() callback, ->mtd_probe() callback is called.
If NIC has 2 ports, ->probe() is called twice and ->mtd_probe() too.
In the ->mtd_probe(), which is efx_ef10_mtd_probe() it allocates and
initializes mtd partiion.
But mtd partition for sfc is shared data.
So that allocated mtd partition data from last called
efx_ef10_mtd_probe() will not be used.
Therefore it must be freed.
But it doesn't free a not used mtd partition data in efx_ef10_mtd_probe().

kmemleak reports:
unreferenced object 0xffff88811ddb0000 (size 63168):
  comm "systemd-udevd", pid 265, jiffies 4294681048 (age 348.586s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffffa3767749>] kmalloc_order_trace+0x19/0x120
    [<ffffffffa3873f0e>] __kmalloc+0x20e/0x250
    [<ffffffffc041389f>] efx_ef10_mtd_probe+0x11f/0x270 [sfc]
    [<ffffffffc0484c8a>] efx_pci_probe.cold.17+0x3df/0x53d [sfc]
    [<ffffffffa414192c>] local_pci_probe+0xdc/0x170
    [<ffffffffa4145df5>] pci_device_probe+0x235/0x680
    [<ffffffffa443dd52>] really_probe+0x1c2/0x8f0
    [<ffffffffa443e72b>] __driver_probe_device+0x2ab/0x460
    [<ffffffffa443e92a>] driver_probe_device+0x4a/0x120
    [<ffffffffa443f2ae>] __driver_attach+0x16e/0x320
    [<ffffffffa4437a90>] bus_for_each_dev+0x110/0x190
    [<ffffffffa443b75e>] bus_add_driver+0x39e/0x560
    [<ffffffffa4440b1e>] driver_register+0x18e/0x310
    [<ffffffffc02e2055>] 0xffffffffc02e2055
    [<ffffffffa3001af3>] do_one_initcall+0xc3/0x450
    [<ffffffffa33ca574>] do_init_module+0x1b4/0x700

Acked-by: Martin Habets <habetsm.xilinx@gmail.com>
Fixes: 8127d661e77f ("sfc: Add support for Solarflare SFC9100 family")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Link: https://lore.kernel.org/r/20220512054709.12513-1-ap420073@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/ef10.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 1f971d31ec30..6b0a4dc1ced1 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -6146,6 +6146,11 @@ static int efx_ef10_mtd_probe(struct efx_nic *efx)
 		n_parts++;
 	}
 
+	if (!n_parts) {
+		kfree(parts);
+		return 0;
+	}
+
 	rc = efx_mtd_add(efx, &parts[0].common, n_parts, sizeof(*parts));
 fail:
 	if (rc)
-- 
2.35.1



