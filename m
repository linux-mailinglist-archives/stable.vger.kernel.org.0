Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BECC54EF178
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 16:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348093AbiDAOh1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347583AbiDAOdN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:33:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD7A521592E;
        Fri,  1 Apr 2022 07:29:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E293B82505;
        Fri,  1 Apr 2022 14:29:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48058C34117;
        Fri,  1 Apr 2022 14:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823391;
        bh=BajCV1XP1yu2fNsxTPAu527PA7vDUg5dFLjTlsjP+bE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MNQBaLi1BDv4m+14KN/FDCEAMPa0bCa6U+nZYM4bSApM8oi0Z8yCSvks3XGKb/6DZ
         SrCpaiiCa5M/OO9Kb8PhJiRUmkrSowcxPqGxwPGT3jhynscUZpc07W63l3npcEvzgN
         ljaGI4XxzatQ4JKd3VkWJPuLhqSunmeGhJVsMmq9Dd/xzlfyQpri9AQNwh7Y0h+Wft
         1PjUNH5MMEuhOyc39Ovmyvoh7FKKtTn2HoN8rxFUOH6iSAfMQM6Yb34uf+icxgKOFN
         ZIj9UBo4Ax7NAMJuPcgGgoGeH38TfNEsi3xr7sUbrwrQMDxt6aL0g6GeDiJ1bIHcCS
         3pcia6Fuykupg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, balbi@kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 077/149] usb: dwc3: pci: Set the swnode from inside dwc3_pci_quirks()
Date:   Fri,  1 Apr 2022 10:24:24 -0400
Message-Id: <20220401142536.1948161-77-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit e285cb403994419e997749c9a52b9370884ae0c8 ]

The quirk handling may need to set some different properties
which means using a different swnode, move the setting of the swnode
to inside dwc3_pci_quirks() so that the quirk handling can choose
a different swnode.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20220213130524.18748-4-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/dwc3-pci.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index 06d0e88ec8af..4d9608cc55f7 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -185,7 +185,8 @@ static const struct software_node dwc3_pci_amd_mr_swnode = {
 	.properties = dwc3_pci_mr_properties,
 };
 
-static int dwc3_pci_quirks(struct dwc3_pci *dwc)
+static int dwc3_pci_quirks(struct dwc3_pci *dwc,
+			   const struct software_node *swnode)
 {
 	struct pci_dev			*pdev = dwc->pci;
 
@@ -242,7 +243,7 @@ static int dwc3_pci_quirks(struct dwc3_pci *dwc)
 		}
 	}
 
-	return 0;
+	return device_add_software_node(&dwc->dwc3->dev, swnode);
 }
 
 #ifdef CONFIG_PM
@@ -307,11 +308,7 @@ static int dwc3_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 	dwc->dwc3->dev.parent = dev;
 	ACPI_COMPANION_SET(&dwc->dwc3->dev, ACPI_COMPANION(dev));
 
-	ret = device_add_software_node(&dwc->dwc3->dev, (void *)id->driver_data);
-	if (ret < 0)
-		goto err;
-
-	ret = dwc3_pci_quirks(dwc);
+	ret = dwc3_pci_quirks(dwc, (void *)id->driver_data);
 	if (ret)
 		goto err;
 
-- 
2.34.1

