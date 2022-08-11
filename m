Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59C045900E9
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 17:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235922AbiHKPrr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236831AbiHKPqX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:46:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7E0D832EE;
        Thu, 11 Aug 2022 08:41:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52E94616CF;
        Thu, 11 Aug 2022 15:41:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A109FC433B5;
        Thu, 11 Aug 2022 15:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232460;
        bh=vq/WTahCdt6OsZzbqDWCYNt3jglxlfkumLa9I9uSH8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JIE5S2HgBF/KHt5NkbzqHeDtEHzW3P4SsNJ8ByMUlS0P+pLfFyMQufGMc+DwLNQ8V
         5KiLuR/n57oU7yL2kYDcdfDTnc5QTaCUmHX4kEae4x4mFK9ckyARcKqXr35BN9GIis
         OAWuPuXsjxblxgFY4PF9hiI8myF+AekfqyATkx0u2sPx3EGZvQgfAJlxU8uy9h8/Yx
         7rR5ZlhFNgWwMDz3voTtouy+cadB86Ut2eWPrgJmciL3af4/NqF2sBkpVTzJMHMzOF
         y38F0B3knb41ew/UsY/qA7cE6VSBjiVlgVRXKBzcZy3pUCh9D/X8tP0YBuhPCNhYv8
         z4ZyHwhdgtLjg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zijun Hu <quic_zijuhu@quicinc.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 087/105] Bluetooth: btusb: Remove HCI_QUIRK_BROKEN_ERR_DATA_REPORTING for fake CSR
Date:   Thu, 11 Aug 2022 11:28:11 -0400
Message-Id: <20220811152851.1520029-87-sashal@kernel.org>
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
index 53deca7b86c9..ad27119334fb 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2069,7 +2069,6 @@ static int btusb_setup_csr(struct hci_dev *hdev)
 		 * without these the controller will lock up.
 		 */
 		set_bit(HCI_QUIRK_BROKEN_STORED_LINK_KEY, &hdev->quirks);
-		set_bit(HCI_QUIRK_BROKEN_ERR_DATA_REPORTING, &hdev->quirks);
 		set_bit(HCI_QUIRK_BROKEN_FILTER_CLEAR_ALL, &hdev->quirks);
 		set_bit(HCI_QUIRK_NO_SUSPEND_NOTIFIER, &hdev->quirks);
 
-- 
2.35.1

