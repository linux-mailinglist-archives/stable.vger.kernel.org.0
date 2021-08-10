Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 622AF3E804C
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235504AbhHJRr6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:47:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:50908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235721AbhHJRqD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:46:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4AA061222;
        Tue, 10 Aug 2021 17:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617225;
        bh=aHOct+bx6Cjbr8OP3I/zD54Bd2a8hWbeDkTTOfi7ePI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MoWem61AIzFFwR/Q82XPXcCkNq95Nl76QlQ5vFbtiKkGTcH1wYXRn2PWwjTCE1K1o
         IO4M3ofol89W28WX5H0DZIgLzBndsiJuSO2axkKs7v/iqEgyk5yDA0B1dQw5Srpvgq
         XTSEN3rzYKVaMxvUaMppZlH6ayi0z0IG8kymG4Ik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dong Aisheng <aisheng.dong@nxp.com>,
        Brian Norris <briannorris@chromium.org>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 5.10 073/135] clk: fix leak on devm_clk_bulk_get_all() unwind
Date:   Tue, 10 Aug 2021 19:30:07 +0200
Message-Id: <20210810172958.201767375@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Norris <briannorris@chromium.org>

commit f828b0bcacef189edbd247e9f48864fc36bfbe33 upstream.

clk_bulk_get_all() allocates an array of struct clk_bulk data for us
(unlike clk_bulk_get()), so we need to free it. Let's use the
clk_bulk_put_all() helper.

kmemleak complains, on an RK3399 Gru/Kevin system:

unreferenced object 0xffffff80045def00 (size 128):
  comm "swapper/0", pid 1, jiffies 4294667682 (age 86.394s)
  hex dump (first 32 bytes):
    44 32 60 fe fe ff ff ff 00 00 00 00 00 00 00 00  D2`.............
    48 32 60 fe fe ff ff ff 00 00 00 00 00 00 00 00  H2`.............
  backtrace:
    [<00000000742860d6>] __kmalloc+0x22c/0x39c
    [<00000000b0493f2c>] clk_bulk_get_all+0x64/0x188
    [<00000000325f5900>] devm_clk_bulk_get_all+0x58/0xa8
    [<00000000175b9bc5>] dwc3_probe+0x8ac/0xb5c
    [<000000009169e2f9>] platform_drv_probe+0x9c/0xbc
    [<000000005c51e2ee>] really_probe+0x13c/0x378
    [<00000000c47b1f24>] driver_probe_device+0x84/0xc0
    [<00000000f870fcfb>] __device_attach_driver+0x94/0xb0
    [<000000004d1b92ae>] bus_for_each_drv+0x8c/0xd8
    [<00000000481d60c3>] __device_attach+0xc4/0x150
    [<00000000a163bd36>] device_initial_probe+0x1c/0x28
    [<00000000accb6bad>] bus_probe_device+0x3c/0x9c
    [<000000001a199f89>] device_add+0x218/0x3cc
    [<000000001bd84952>] of_device_add+0x40/0x50
    [<000000009c658c29>] of_platform_device_create_pdata+0xac/0x100
    [<0000000021c69ba4>] of_platform_bus_create+0x190/0x224

Fixes: f08c2e2865f6 ("clk: add managed version of clk_bulk_get_all")
Cc: Dong Aisheng <aisheng.dong@nxp.com>
Cc: stable@vger.kernel.org
Signed-off-by: Brian Norris <briannorris@chromium.org>
Link: https://lore.kernel.org/r/20210731025950.2238582-1-briannorris@chromium.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/clk-devres.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/clk/clk-devres.c
+++ b/drivers/clk/clk-devres.c
@@ -92,13 +92,20 @@ int __must_check devm_clk_bulk_get_optio
 }
 EXPORT_SYMBOL_GPL(devm_clk_bulk_get_optional);
 
+static void devm_clk_bulk_release_all(struct device *dev, void *res)
+{
+	struct clk_bulk_devres *devres = res;
+
+	clk_bulk_put_all(devres->num_clks, devres->clks);
+}
+
 int __must_check devm_clk_bulk_get_all(struct device *dev,
 				       struct clk_bulk_data **clks)
 {
 	struct clk_bulk_devres *devres;
 	int ret;
 
-	devres = devres_alloc(devm_clk_bulk_release,
+	devres = devres_alloc(devm_clk_bulk_release_all,
 			      sizeof(*devres), GFP_KERNEL);
 	if (!devres)
 		return -ENOMEM;


