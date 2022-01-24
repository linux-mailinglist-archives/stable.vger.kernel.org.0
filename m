Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 898AB498F49
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350437AbiAXTvr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:51:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354033AbiAXTfs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:35:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDDE8C0617AB;
        Mon, 24 Jan 2022 11:16:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A64CB81232;
        Mon, 24 Jan 2022 19:16:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6D92C340E5;
        Mon, 24 Jan 2022 19:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051804;
        bh=gZSDVsfYlsAxlWnp9Aw1egp1OcnEtoIW76K3GdYQkMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LjV9gJ9aeM2maLmAyiEZQSqDoLDOZbsIP+3dD1nnVNI6FdzN1ItZ4gAEgW6TpysRJ
         G6q8HkRjd0+OCIS6hskPzQtdQohXzWurutm0+zCCwMKrMBo9lmlXdblHMz71A6ZQec
         UoXD19wbg6yu4++3DAHyKl24KHp+DQyTsqvT8nJE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 092/239] spi: spi-meson-spifc: Add missing pm_runtime_disable() in meson_spifc_probe
Date:   Mon, 24 Jan 2022 19:42:10 +0100
Message-Id: <20220124183946.040344577@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 69c1b87516e327a60b39f96b778fe683259408bf ]

If the probe fails, we should use pm_runtime_disable() to balance
pm_runtime_enable().
Add missing pm_runtime_disable() for meson_spifc_probe.

Fixes: c3e4bc5434d2 ("spi: meson: Add support for Amlogic Meson SPIFC")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220107075424.7774-1-linmq006@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-meson-spifc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-meson-spifc.c b/drivers/spi/spi-meson-spifc.c
index 616566e793c62..28975b6f054fa 100644
--- a/drivers/spi/spi-meson-spifc.c
+++ b/drivers/spi/spi-meson-spifc.c
@@ -357,6 +357,7 @@ static int meson_spifc_probe(struct platform_device *pdev)
 	return 0;
 out_clk:
 	clk_disable_unprepare(spifc->clk);
+	pm_runtime_disable(spifc->dev);
 out_err:
 	spi_master_put(master);
 	return ret;
-- 
2.34.1



