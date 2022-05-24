Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA09532E8A
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 18:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239695AbiEXQFP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 12:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239663AbiEXQEQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 12:04:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6F416D862;
        Tue, 24 May 2022 09:01:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8EFEBB817F2;
        Tue, 24 May 2022 16:01:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F0E2C34118;
        Tue, 24 May 2022 16:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653408110;
        bh=hcEIL1pzwL3kUjm/DoQRDd1vOkGaipd/dvLI4ffFRP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=caN0OCkLCSz/17j9N9rGlz1atUKq4pnCTANUXm2MPBNEadvwXawa9Y1Blz53gldru
         en5MoltyGgq3RocV7wRKriPLsbSymQwYzzrGPK3kSlnH0ZlJucCVCmGwDU3KzoagIz
         WCEunah1g6DY/zjShhiG4E42zXYzoDg8CDdd0xoud+k+k91A3PY2EMuWnYnrG3yxbx
         0PgFdzpZqI8IDaoRtZHXU+pt9i0ofBJmvrs9wRIH09svhCtKh5Q11yJ7jpgJKR8dZO
         26znVux/kIHpZqFQZZfqKpZUrW75lSE69I0ALBLMmBP9223GGB7JRbNRxoFd+ykqxA
         To+JXWqTyP3kw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Piyush Malgujar <pmalgujar@marvell.com>,
        Szymon Balcerak <sbalcerak@marvell.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        rric@kernel.org, linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 2/2] drivers: i2c: thunderx: Allow driver to work with ACPI defined TWSI controllers
Date:   Tue, 24 May 2022 12:01:44 -0400
Message-Id: <20220524160144.827435-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220524160144.827435-1-sashal@kernel.org>
References: <20220524160144.827435-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index bba5b429f69c..3298483bb9b4 100644
--- a/drivers/i2c/busses/i2c-thunderx-pcidrv.c
+++ b/drivers/i2c/busses/i2c-thunderx-pcidrv.c
@@ -208,6 +208,7 @@ static int thunder_i2c_probe_pci(struct pci_dev *pdev,
 	i2c->adap.bus_recovery_info = &octeon_i2c_recovery_info;
 	i2c->adap.dev.parent = dev;
 	i2c->adap.dev.of_node = pdev->dev.of_node;
+	i2c->adap.dev.fwnode = dev->fwnode;
 	snprintf(i2c->adap.name, sizeof(i2c->adap.name),
 		 "Cavium ThunderX i2c adapter at %s", dev_name(dev));
 	i2c_set_adapdata(&i2c->adap, i2c);
-- 
2.35.1

