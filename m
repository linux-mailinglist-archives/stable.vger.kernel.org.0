Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0227953CE7D
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238609AbiFCRnJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344941AbiFCRmo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:42:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90229544F1;
        Fri,  3 Jun 2022 10:41:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99F8161B11;
        Fri,  3 Jun 2022 17:41:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1BB5C385B8;
        Fri,  3 Jun 2022 17:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278101;
        bh=1+z+sNbxT56SjlBQgUUIv3b78tcRXKNXzlTy+NZVN0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dXHpDBJjd1CO1thxF7VW6NmOE7x/7EzzhqlLNa68DKiTnPl9U4STuOCZ8y3Ga49hN
         ILI5Nbl3pSNQVrndGHWi22sdlu4eLqMLvzNbeXT9bzPYDYn6ujOD9uAiqqAUeCe9EG
         d6iyjLXRIpzqiEe/BrQOy3yKjblZWVWItLgE5mHk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Szymon Balcerak <sbalcerak@marvell.com>,
        Piyush Malgujar <pmalgujar@marvell.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 10/30] drivers: i2c: thunderx: Allow driver to work with ACPI defined TWSI controllers
Date:   Fri,  3 Jun 2022 19:39:38 +0200
Message-Id: <20220603173815.396728920@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173815.088143764@linuxfoundation.org>
References: <20220603173815.088143764@linuxfoundation.org>
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
index 19f8eec38717..107aeb8b54da 100644
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



