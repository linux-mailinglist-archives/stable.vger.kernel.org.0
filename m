Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0AF5900EE
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 17:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236673AbiHKPrt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236832AbiHKPqX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:46:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E180481689;
        Thu, 11 Aug 2022 08:41:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96C65B82165;
        Thu, 11 Aug 2022 15:40:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F28BC433D6;
        Thu, 11 Aug 2022 15:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232458;
        bh=ZwCCf4M4BhQG3d5wIP7toS4k0WBnqNEynTPkLh0le1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rGDqm7K9Gqs/YCkzkUjZOrINuQA+EhFP+95qhT2yjx4jcKas9Nxix2oUCp+D7nJ2m
         bhKZ572c78CGTMX5je1YNe82p080pxwspk8T6HXjUXvBlCDK5gqWsaZ+C8Jhm/Ai4k
         z9ouUhtLva5QXH3npJoCESX1s2G1cxWhzlbOON9l7QZoOsrd8b55OG1a/HSggcMtNK
         hWGPDpVOgATwJ2vnUT84vsLe2YRU7aPZOlPgFzcICPdKhymi5yYcR2UXIfXACSABc3
         mmNtL2fj5v9kiQ+6QIXuDDTuRp3fR5DHNuViqj4dfR6ZetG4JEnT5RHB5b8zvslkc5
         ATOIoQwB14GXQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zijun Hu <quic_zijuhu@quicinc.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 086/105] Bluetooth: btusb: Remove HCI_QUIRK_BROKEN_ERR_DATA_REPORTING for QCA
Date:   Thu, 11 Aug 2022 11:28:10 -0400
Message-Id: <20220811152851.1520029-86-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811152851.1520029-1-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit 1172c59f451f524a14bac5e7b047781883dfe441 ]

Core driver addtionally checks LMP feature bit "Erroneous Data Reporting"
instead of quirk HCI_QUIRK_BROKEN_ERR_DATA_REPORTING to decide if HCI
commands HCI_Read|Write_Default_Erroneous_Data_Reporting are broken, so
remove this unnecessary quirk for QCA controllers.

The reason why these two HCI commands are broken for QCA controllers is
that feature "Erroneous Data Reporting" is not enabled by their firmware
as shown by below log:

@ RAW Open: hcitool (privileged) version 2.22
< HCI Command: Read Local Supported Commands (0x04|0x0002) plen 0
> HCI Event: Command Complete (0x0e) plen 68
  Read Local Supported Commands (0x04|0x0002) ncmd 1
    Status: Success (0x00)
    Commands: 288 entries
......
      Read Default Erroneous Data Reporting (Octet 18 - Bit 2)
      Write Default Erroneous Data Reporting (Octet 18 - Bit 3)
......

< HCI Command: Read Default Erroneous Data Reporting (0x03|0x005a) plen 0
> HCI Event: Command Complete (0x0e) plen 4
  Read Default Erroneous Data Reporting (0x03|0x005a) ncmd 1
    Status: Unknown HCI Command (0x01)

< HCI Command: Read Local Supported Features (0x04|0x0003) plen 0
> HCI Event: Command Complete (0x0e) plen 12
  Read Local Supported Features (0x04|0x0003) ncmd 1
    Status: Success (0x00)
    Features: 0xff 0xfe 0x0f 0xfe 0xd8 0x3f 0x5b 0x87
      3 slot packets
......

Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Tested-by: Zijun Hu <quic_zijuhu@quicinc.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index d5da862fabaf..53deca7b86c9 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -3352,7 +3352,6 @@ static int btusb_setup_qca(struct hci_dev *hdev)
 	 * work with the likes of HSP/HFP mSBC.
 	 */
 	set_bit(HCI_QUIRK_BROKEN_ENHANCED_SETUP_SYNC_CONN, &hdev->quirks);
-	set_bit(HCI_QUIRK_BROKEN_ERR_DATA_REPORTING, &hdev->quirks);
 
 	return 0;
 }
-- 
2.35.1

