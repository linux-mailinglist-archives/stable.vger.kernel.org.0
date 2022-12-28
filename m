Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE346657B9C
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233700AbiL1PXg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:23:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233692AbiL1PXb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:23:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 187C113FAC
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:23:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96F4561544
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:23:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5FE2C433D2;
        Wed, 28 Dec 2022 15:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241010;
        bh=vuLFL31CGgFpwrTJE2ZDeXdrPmuVfzUQ0rkFUZOnICE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MMmUMm7ldOKnqLvu7+vuf2ZgRPXXugX78oC3w1Pa9niqwa9JxYN/cXwH/teBTIBJO
         VStLJad2Er+93SmwyxbX6frgvrYhJSct4eVEFitwEVI7JM7LcWjvXs3nZ4udf5jtoy
         2/4/ZwBPPcGuzPSe6qzGhcB9ewNUYvatiUJnwNXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        John Thomson <git@johnthomson.fastmail.com.au>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 427/731] PCI: mt7621: Add sentinel to quirks table
Date:   Wed, 28 Dec 2022 15:38:54 +0100
Message-Id: <20221228144308.944618181@linuxfoundation.org>
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

From: John Thomson <git@johnthomson.fastmail.com.au>

[ Upstream commit 19098934f910b4d47cb30251dd39ffa57bef9523 ]

Current driver is missing a sentinel in the struct soc_device_attribute
array, which causes an oops when assessed by the
soc_device_match(mt7621_pcie_quirks_match) call.

This was only exposed once the CONFIG_SOC_MT7621 mt7621 soc_dev_attr
was fixed to register the SOC as a device, in:

commit 7c18b64bba3b ("mips: ralink: mt7621: do not use kzalloc too early")

Fix it by adding the required sentinel.

Link: https://lore.kernel.org/lkml/26ebbed1-0fe9-4af9-8466-65f841d0b382@app.fastmail.com
Link: https://lore.kernel.org/r/20221205204645.301301-1-git@johnthomson.fastmail.com.au
Fixes: b483b4e4d3f6 ("staging: mt7621-pci: add quirks for 'E2' revision using 'soc_device_attribute'")
Signed-off-by: John Thomson <git@johnthomson.fastmail.com.au>
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Acked-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/mt7621-pci/pci-mt7621.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/mt7621-pci/pci-mt7621.c b/drivers/staging/mt7621-pci/pci-mt7621.c
index c4f57bb63482..b520d1e0edd1 100644
--- a/drivers/staging/mt7621-pci/pci-mt7621.c
+++ b/drivers/staging/mt7621-pci/pci-mt7621.c
@@ -511,7 +511,8 @@ static int mt7621_pcie_register_host(struct pci_host_bridge *host)
 }
 
 static const struct soc_device_attribute mt7621_pcie_quirks_match[] = {
-	{ .soc_id = "mt7621", .revision = "E2" }
+	{ .soc_id = "mt7621", .revision = "E2" },
+	{ /* sentinel */ }
 };
 
 static int mt7621_pcie_probe(struct platform_device *pdev)
-- 
2.35.1



