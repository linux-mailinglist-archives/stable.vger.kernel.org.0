Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2629453CF1B
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345465AbiFCRwl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345951AbiFCRug (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:50:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF8A2BDE;
        Fri,  3 Jun 2022 10:46:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E7C0B82419;
        Fri,  3 Jun 2022 17:46:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78333C385A9;
        Fri,  3 Jun 2022 17:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278406;
        bh=UIvOGU9ezNqd/V+eh1/mLYA2MyU4xUyFduSUC7Zg0Ms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vLI8RaFASW9XB3nLQy8Tu3j0bvjPAYnjEylGfzcMNvQdknB8UaqqdHGASEsypCK2V
         5Iix/qpoYi5e/gUJfSnDXpi5svq1mjsJgLRVoowkEg7YP33KF8d+fmXAKX05Rgavlq
         cQhEY4azix6D79qHrPcyRhJOUP0zdKca+kp1lN0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Szymon Balcerak <sbalcerak@marvell.com>,
        Piyush Malgujar <pmalgujar@marvell.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 07/53] drivers: i2c: thunderx: Allow driver to work with ACPI defined TWSI controllers
Date:   Fri,  3 Jun 2022 19:42:52 +0200
Message-Id: <20220603173818.934482633@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173818.716010877@linuxfoundation.org>
References: <20220603173818.716010877@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Piyush Malgujar <pmalgujar@marvell.com>

[ Upstream commit 03a35bc856ddc09f2cc1f4701adecfbf3b464cb3 ]

Due to i2c->adap.dev.fwnode not being set, ACPI_COMPANION() wasn't properly
found for TWSI controllers.

Signed-off-by: Szymon Balcerak <sbalcerak@marvell.com>
Signed-off-by: Piyush Malgujar <pmalgujar@marvell.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-thunderx-pcidrv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i2c/busses/i2c-thunderx-pcidrv.c b/drivers/i2c/busses/i2c-thunderx-pcidrv.c
index 12c90aa0900e..a77cd86fe75e 100644
--- a/drivers/i2c/busses/i2c-thunderx-pcidrv.c
+++ b/drivers/i2c/busses/i2c-thunderx-pcidrv.c
@@ -213,6 +213,7 @@ static int thunder_i2c_probe_pci(struct pci_dev *pdev,
 	i2c->adap.bus_recovery_info = &octeon_i2c_recovery_info;
 	i2c->adap.dev.parent = dev;
 	i2c->adap.dev.of_node = pdev->dev.of_node;
+	i2c->adap.dev.fwnode = dev->fwnode;
 	snprintf(i2c->adap.name, sizeof(i2c->adap.name),
 		 "Cavium ThunderX i2c adapter at %s", dev_name(dev));
 	i2c_set_adapdata(&i2c->adap, i2c);
-- 
2.35.1



