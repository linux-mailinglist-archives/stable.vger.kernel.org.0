Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E90465133A
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 20:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232533AbiLST2t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 14:28:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232757AbiLST0u (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 14:26:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1425A140E5
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 11:26:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3AA46111A
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 19:26:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6F3FC433EF;
        Mon, 19 Dec 2022 19:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671477988;
        bh=m9R7HzOlcyUwmlTPlzZteTx97LlJagKzKH9uLyQ8PMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hSp4D9oV4XeuClbwvPlbyf8agdVzGo62jrr2ppDPFW6lvvgw9fC9RAujqdH+l2cNa
         N9K2HCcgGOP+PVZKMP+gbI+P9Xx55gaaMWIUKWbyFZpYnM5P9s9st2JWIheOPKhNuu
         IYuT2DHfSidMfTtS2cMLWzrluVkmOpofJMO6vR1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        John Thomson <git@johnthomson.fastmail.com.au>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>
Subject: [PATCH 6.0 01/28] PCI: mt7621: Add sentinel to quirks table
Date:   Mon, 19 Dec 2022 20:22:48 +0100
Message-Id: <20221219182944.245075142@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221219182944.179389009@linuxfoundation.org>
References: <20221219182944.179389009@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
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

commit 19098934f910b4d47cb30251dd39ffa57bef9523 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pcie-mt7621.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/pci/controller/pcie-mt7621.c
+++ b/drivers/pci/controller/pcie-mt7621.c
@@ -471,7 +471,8 @@ static int mt7621_pcie_register_host(str
 }
 
 static const struct soc_device_attribute mt7621_pcie_quirks_match[] = {
-	{ .soc_id = "mt7621", .revision = "E2" }
+	{ .soc_id = "mt7621", .revision = "E2" },
+	{ /* sentinel */ }
 };
 
 static int mt7621_pcie_probe(struct platform_device *pdev)


