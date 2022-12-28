Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2A8F657D73
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233576AbiL1PnV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:43:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233564AbiL1PnU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:43:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E258A1705E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:43:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E7666155E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:43:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF23C433EF;
        Wed, 28 Dec 2022 15:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242198;
        bh=YxqzG76YSezYNd/K2pWXjHzfN7YLBUbnOlr+uEnneh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MtvLPYXryeDzyFAYcFJgVAtuXcXVvKSd8JCrZIEysQzitWEmXdMVeMUYGf0EtRULq
         iLI8+37EJNlUP8Yo7h6CJ1GVx6HbbFpocQ36D1go1VEqE8Ti8HUpPVQ6mu/QB9myMl
         nxdj50/kT4R7rilX4/d8splZw+nvaPkFsqGNJM/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Lee Jones <lee@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 574/731] mfd: bd957x: Fix Kconfig dependency on REGMAP_IRQ
Date:   Wed, 28 Dec 2022 15:41:21 +0100
Message-Id: <20221228144313.193738268@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>

[ Upstream commit 85842c46fd47fa6bd78681c154223bed27d5fd19 ]

The BD957x driver uses REGMAP_IRQ but does not 'select' to depend on
it. This can cause build failures.  Select REGMAP_IRQ for BD957X.

Fixes: 0e9692607f94 ("mfd: bd9576: Add IRQ support")
Signed-off-by: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
Signed-off-by: Lee Jones <lee@kernel.org>
Link: https://lore.kernel.org/r/Y3SdCWkRr1L64SWK@dc75zzyyyyyyyyyyyyydt-3.rev.dnainternet.fi
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index d2f345245538..5dd7ea0ebd46 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -1995,6 +1995,7 @@ config MFD_ROHM_BD957XMUF
 	depends on I2C=y
 	depends on OF
 	select REGMAP_I2C
+	select REGMAP_IRQ
 	select MFD_CORE
 	help
 	  Select this option to get support for the ROHM BD9576MUF and
-- 
2.35.1



