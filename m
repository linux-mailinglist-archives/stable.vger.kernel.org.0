Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08BAB3F64AF
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239185AbhHXRGc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:06:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:45878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239592AbhHXRE3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:04:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14476619E2;
        Tue, 24 Aug 2021 16:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824368;
        bh=2l1MTADzjG9l7HxHfrrGl87rCrQzi97eRenUpP5Th/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rE5b1Et4OrKvxXK5YBDQcEWOLUTKCma4AXA15PdPAcaC0FibWQkp2PRegJ/Qz/6Kj
         T+3AtcMornaKgyQkqdNNW+MFiv1YbDYmGli0ibd4bu24ke2Dt4htlMrZu3f4eYkmMO
         +P2/QzrC+bqLP/WUeyAoyOvA6TcILQ27iTo2dFGFM2bR0YdF4sW6pds62dYF+Uh0Ht
         wQzEJs2hZK+N8YspXr+rttz7hFZIP/Y6VtjHMNumxNTs5TQtUXWr6VYZ8PraXJYO04
         mqpGCLlRKZYxuvudBl6+ZZKFKV5OZMK5N8IgyUD75rb8/u4YW+ZMTc3nNqdqtvy45L
         3cTxv05Xz6+vA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 18/98] spi: spi-mux: Add module info needed for autoloading
Date:   Tue, 24 Aug 2021 12:57:48 -0400
Message-Id: <20210824165908.709932-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.61-rc1
X-KernelTest-Deadline: 2021-08-26T16:58+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 1d5ccab95f06675a269f4cb223a1e3f6d1ebef42 ]

With the spi device table udev can autoload the spi-mux module in
the presence of an spi-mux device.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20210721095321.2165453-1-u.kleine-koenig@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mux.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/spi/spi-mux.c b/drivers/spi/spi-mux.c
index 37dfc6e82804..9708b7827ff7 100644
--- a/drivers/spi/spi-mux.c
+++ b/drivers/spi/spi-mux.c
@@ -167,10 +167,17 @@ err_put_ctlr:
 	return ret;
 }
 
+static const struct spi_device_id spi_mux_id[] = {
+	{ "spi-mux" },
+	{ }
+};
+MODULE_DEVICE_TABLE(spi, spi_mux_id);
+
 static const struct of_device_id spi_mux_of_match[] = {
 	{ .compatible = "spi-mux" },
 	{ }
 };
+MODULE_DEVICE_TABLE(of, spi_mux_of_match);
 
 static struct spi_driver spi_mux_driver = {
 	.probe  = spi_mux_probe,
@@ -178,6 +185,7 @@ static struct spi_driver spi_mux_driver = {
 		.name   = "spi-mux",
 		.of_match_table = spi_mux_of_match,
 	},
+	.id_table = spi_mux_id,
 };
 
 module_spi_driver(spi_mux_driver);
-- 
2.30.2

