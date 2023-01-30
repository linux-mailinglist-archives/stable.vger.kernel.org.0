Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7471E6812B8
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:24:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235919AbjA3OY2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:24:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237465AbjA3OYO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:24:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 010253D910
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:23:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A5D0B80CB4
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:23:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BACEBC433EF;
        Mon, 30 Jan 2023 14:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088586;
        bh=zL+jDpKgNJoatZKiw2piRhNuUv0oWA6TVS438OSXSAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WDFlozGVE6r6t+Wv0ad70CLmaQ0P6AUus9HH/PxgBZiotu27y6dEb3Sdbe2NtedmY
         ebuq0IzE61jPQ5B53xGZg9IBcQ7XUqLzaWu57lVQWQDZZHkFqs9Ztoi3jpK83NHZYn
         w+pdQg2iHp70JDKcV7n+0N/JsuyaeBziQpBzP/Jk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 069/143] spi: spidev: remove debug messages that access spidev->spi without locking
Date:   Mon, 30 Jan 2023 14:52:06 +0100
Message-Id: <20230130134309.700025726@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
References: <20230130134306.862721518@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index 9c5ec99431d2..aee960a7d7f9 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -592,7 +592,6 @@ static int spidev_open(struct inode *inode, struct file *filp)
 	if (!spidev->tx_buffer) {
 		spidev->tx_buffer = kmalloc(bufsiz, GFP_KERNEL);
 		if (!spidev->tx_buffer) {
-			dev_dbg(&spidev->spi->dev, "open/ENOMEM\n");
 			status = -ENOMEM;
 			goto err_find_dev;
 		}
@@ -601,7 +600,6 @@ static int spidev_open(struct inode *inode, struct file *filp)
 	if (!spidev->rx_buffer) {
 		spidev->rx_buffer = kmalloc(bufsiz, GFP_KERNEL);
 		if (!spidev->rx_buffer) {
-			dev_dbg(&spidev->spi->dev, "open/ENOMEM\n");
 			status = -ENOMEM;
 			goto err_alloc_rx_buf;
 		}
-- 
2.39.0



