Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD1D66C111
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231893AbjAPOHd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:07:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231739AbjAPOGf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:06:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68AE223C7B;
        Mon, 16 Jan 2023 06:03:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05DAE60FB1;
        Mon, 16 Jan 2023 14:03:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC70DC433D2;
        Mon, 16 Jan 2023 14:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877808;
        bh=Ko+6sOwYpIYL2EpmeWW5zp5GW1wurCq0r8H+3vIcNsw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AGmtOO54L3jWcsUbqnoAoMr7sZbg9kbOvfvxG05z2cAq52nfzJcK5oWLuyKC7A2oV
         Ze4j2G7GVRYMS5gHin2N2MskcAsBuqjc1gf4neMLY28yMikRm+whF26v4aG6GniLSn
         h7Wl+wqAW658/xAJAGQlffrUyA5Cv/UeXKHTb84KL48ryjcXHeRYNsossXgxAOfsN2
         2/UIMSRxz2CC7ofCbiTjTh778k+rgr0goLK8CV9N71Kxw8iKduZkFwG0VzpCpk9V8x
         q+RJrOKXaEUkdi2PQstExSJpg+7s/p5MAYk0FbJyKg3hwRRCoq1Un7yIFIYTdQWBWJ
         w3TA35AOtHjfw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 39/53] spi: spidev: remove debug messages that access spidev->spi without locking
Date:   Mon, 16 Jan 2023 09:01:39 -0500
Message-Id: <20230116140154.114951-39-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230116140154.114951-1-sashal@kernel.org>
References: <20230116140154.114951-1-sashal@kernel.org>
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
index 42aaaca67265..1935ca613447 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -603,7 +603,6 @@ static int spidev_open(struct inode *inode, struct file *filp)
 	if (!spidev->tx_buffer) {
 		spidev->tx_buffer = kmalloc(bufsiz, GFP_KERNEL);
 		if (!spidev->tx_buffer) {
-			dev_dbg(&spidev->spi->dev, "open/ENOMEM\n");
 			status = -ENOMEM;
 			goto err_find_dev;
 		}
@@ -612,7 +611,6 @@ static int spidev_open(struct inode *inode, struct file *filp)
 	if (!spidev->rx_buffer) {
 		spidev->rx_buffer = kmalloc(bufsiz, GFP_KERNEL);
 		if (!spidev->rx_buffer) {
-			dev_dbg(&spidev->spi->dev, "open/ENOMEM\n");
 			status = -ENOMEM;
 			goto err_alloc_rx_buf;
 		}
-- 
2.35.1

