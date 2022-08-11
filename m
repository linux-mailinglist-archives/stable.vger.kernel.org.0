Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3CD590293
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237432AbiHKQKF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 12:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236183AbiHKQJV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 12:09:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2866DBC826;
        Thu, 11 Aug 2022 08:54:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A210B82150;
        Thu, 11 Aug 2022 15:54:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10426C433C1;
        Thu, 11 Aug 2022 15:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660233292;
        bh=1hxkQL7v2ehXQMvyUUExDbspZDkKzYpxEOES4LzTMhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JIBRCmyiH7dwiaXJ+uipQWPXyhgM8KXguVKwJCjQibyDr/urrtZFi3fnH79//X9zy
         k4QNkTt6pqwHfBZsaRjR2ZmIoPyjEScRLSHU8HJLA87AF2X/Gbw49OYTuaoIi2/af1
         Y5gkE0IgM2mEJGHWfMeWuNtiUxgBM1Kl6FoUDO2I6V5/QhQDckzoOrl7Wuv50/+vEj
         HWMAi8ImKDtf17SmAijNrAQVchmxub7OA36846c5ptRDX+/y5+wK3wxTJ+wdIL/mwl
         rFfsHQGKvz1J3BhrJ84Zec+iWCQyN3ENTXtegkmFYvxHYDSsobxaoxzw/YMdnCTb3T
         nz7YT9+/BkncA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zijun Hu <quic_zijuhu@quicinc.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 79/93] Bluetooth: btusb: Remove HCI_QUIRK_BROKEN_ERR_DATA_REPORTING for fake CSR
Date:   Thu, 11 Aug 2022 11:42:13 -0400
Message-Id: <20220811154237.1531313-79-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811154237.1531313-1-sashal@kernel.org>
References: <20220811154237.1531313-1-sashal@kernel.org>
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

[ Upstream commit e168f690087735ad12604ee6ee2db1b93e323072 ]

Core driver addtionally checks LMP feature bit "Erroneous Data Reporting"
instead of quirk HCI_QUIRK_BROKEN_ERR_DATA_REPORTING to decide if HCI
commands HCI_Read|Write_Default_Erroneous_Data_Reporting are broken, so
remove this unnecessary quirk for fake CSR controllers.

Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 6bd642580f76..e18f5794529d 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2057,7 +2057,6 @@ static int btusb_setup_csr(struct hci_dev *hdev)
 		 * without these the controller will lock up.
 		 */
 		set_bit(HCI_QUIRK_BROKEN_STORED_LINK_KEY, &hdev->quirks);
-		set_bit(HCI_QUIRK_BROKEN_ERR_DATA_REPORTING, &hdev->quirks);
 		set_bit(HCI_QUIRK_BROKEN_FILTER_CLEAR_ALL, &hdev->quirks);
 		set_bit(HCI_QUIRK_NO_SUSPEND_NOTIFIER, &hdev->quirks);
 
-- 
2.35.1

