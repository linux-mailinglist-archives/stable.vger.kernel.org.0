Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A12A5532E58
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 18:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239548AbiEXQCm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 12:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239488AbiEXQCD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 12:02:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3BFD10BA;
        Tue, 24 May 2022 09:01:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A37AEB819DC;
        Tue, 24 May 2022 16:01:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7013BC34116;
        Tue, 24 May 2022 16:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653408061;
        bh=UIvOGU9ezNqd/V+eh1/mLYA2MyU4xUyFduSUC7Zg0Ms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uyB/ewAblBrYAoTZxXWVqxKfhZNkAheoeoeFv7TJyzlEt6QB4HsWqzLRBXx5KAAK+
         Wo5B+1dtebAJOugl3c7OEJkIT7BiOqeDUBX2BmkGxj5v6K+4XYlLS4XvL8BHkZHTwz
         xXskrCcWqi9sq65noE5g2ILuvjVn5+Q85PulH551D4F2woNgUY8Im3+869jpdd9PGO
         wemf7DEdhr/ZYPolwoY7o/2BK7zpxB8D8nqBvazj/A457My49vzOZA3OrIWW+hT6Mn
         PPaC7w00Gr0c6vaCrjCdyP3Xy4hsJdsdjfBsG5dYLyR8MSsAHH2kDTHvgjcWnU4UzD
         w3ct/CPFaWMvQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Piyush Malgujar <pmalgujar@marvell.com>,
        Szymon Balcerak <sbalcerak@marvell.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        rric@kernel.org, linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 8/8] drivers: i2c: thunderx: Allow driver to work with ACPI defined TWSI controllers
Date:   Tue, 24 May 2022 12:00:35 -0400
Message-Id: <20220524160035.827109-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220524160035.827109-1-sashal@kernel.org>
References: <20220524160035.827109-1-sashal@kernel.org>
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

