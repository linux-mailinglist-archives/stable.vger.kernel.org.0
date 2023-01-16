Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B05D66C175
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232210AbjAPOMI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:12:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232211AbjAPOLW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:11:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8751E2A9A2;
        Mon, 16 Jan 2023 06:04:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7069060FD3;
        Mon, 16 Jan 2023 14:04:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E9EBC433F0;
        Mon, 16 Jan 2023 14:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877869;
        bh=UPV1IneB0Ifz9vqAAKn8eXpAFravS9D32gXwK6aco9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EZlxPC5zXpgf1nFcMDzkXySUWOER/Q2yBeYjH/2LJNY1HqT4qXMCSuIK/Kk3BKCuX
         t28lClckBg3/7jkssfTSqI4UdeTxoB1/v1W92EPVI8GogbyRBd+ppxZG76UdZ3kkmj
         UPDcA8Xcv111tYWOez7qzxYz0h2imUob7dKjnDqNmpcf7dANkaMniubVURqJlBGFSM
         ghlIhK904ZrzlDO6lWvDobQDDt0AleKVBoXiudRWuB/cMm6xshZLBC+/MIgYWHrGTn
         Wj/gdMtUug65eTlDZg3q9oAfbSHwvAhMaShBB051i1GOcrD5zzuYP4kwtHKb1+HpNn
         8kH17Gbz+sWbQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 17/24] spi: spidev: remove debug messages that access spidev->spi without locking
Date:   Mon, 16 Jan 2023 09:03:52 -0500
Message-Id: <20230116140359.115716-17-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230116140359.115716-1-sashal@kernel.org>
References: <20230116140359.115716-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit 6b35b173dbc1711f8d272e3f322d2ad697015919 ]

The two debug messages in spidev_open() dereference spidev->spi without
taking the lock and without checking if it's not null. This can lead to
a crash. Drop the messages as they're not needed - the user-space will
get informed about ENOMEM with the syscall return value.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Link: https://lore.kernel.org/r/20230106100719.196243-2-brgl@bgdev.pl
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spidev.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index 2cfbf840410a..6e978dad72dc 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -594,7 +594,6 @@ static int spidev_open(struct inode *inode, struct file *filp)
 	if (!spidev->tx_buffer) {
 		spidev->tx_buffer = kmalloc(bufsiz, GFP_KERNEL);
 		if (!spidev->tx_buffer) {
-			dev_dbg(&spidev->spi->dev, "open/ENOMEM\n");
 			status = -ENOMEM;
 			goto err_find_dev;
 		}
@@ -603,7 +602,6 @@ static int spidev_open(struct inode *inode, struct file *filp)
 	if (!spidev->rx_buffer) {
 		spidev->rx_buffer = kmalloc(bufsiz, GFP_KERNEL);
 		if (!spidev->rx_buffer) {
-			dev_dbg(&spidev->spi->dev, "open/ENOMEM\n");
 			status = -ENOMEM;
 			goto err_alloc_rx_buf;
 		}
-- 
2.35.1

