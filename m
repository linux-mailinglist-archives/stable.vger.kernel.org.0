Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34D33537DA6
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 15:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232778AbiE3Nhh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238223AbiE3Nge (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:36:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCD4C986F4;
        Mon, 30 May 2022 06:29:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C93CD60DD5;
        Mon, 30 May 2022 13:29:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5668DC385B8;
        Mon, 30 May 2022 13:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917396;
        bh=ZY+9bOivnNwE6I+fPAkFM/4luhtBKoOnJATkvk/5Qi4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LKWDdkmAmuXEdbYEdtWJ7BjE2gNyK3EfmK93fRYvCWgjp4djLMJxvw1LEnoqNqC9C
         PfiYXvYMRzYZ7KVmQC45GgpwT5uCzAUbQuoXK/RQgV2O9ugyptLSxzMXQpK62JJfwc
         50jgguIRnERIkYzV4D4DiCqgkqnE984cOWI/J59t+m1mVAg1fGGds3wIUnl10m4NcB
         UqvMO3UgynGKtmjqEPKuvKB+q1RlX1w+SO4B/I6u4FqGtiNLE2pcScSIHlwVUM5CH7
         QQmo5pS5koX3XForG1U3GNjITbkOGOT+anmMOyYSJbo8m0qi0Hme1M7Qn3v8zL441A
         aqFsZCgDgCaVg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zijun Hu <quic_zijuhu@quicinc.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>, johan.hedberg@gmail.com,
        luiz.dentz@gmail.com, linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 121/159] Bluetooth: btusb: Set HCI_QUIRK_BROKEN_ERR_DATA_REPORTING for QCA
Date:   Mon, 30 May 2022 09:23:46 -0400
Message-Id: <20220530132425.1929512-121-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530132425.1929512-1-sashal@kernel.org>
References: <20220530132425.1929512-1-sashal@kernel.org>
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

[ Upstream commit 247f226adadfb7be09dd537f177429f4415aef8e ]

Set HCI_QUIRK_BROKEN_ERR_DATA_REPORTING for QCA controllers since
they answer HCI_OP_READ_DEF_ERR_DATA_REPORTING with error code
"UNKNOWN HCI COMMAND" as shown below:

[  580.517552] Bluetooth: hci0: unexpected cc 0x0c5a length: 1 < 2
[  580.517660] Bluetooth: hci0: Opcode 0x c5a failed: -38

hcitool -i hci0 cmd 0x03 0x5a
< HCI Command: ogf 0x03, ocf 0x005a, plen 0
> HCI Event: 0x0e plen 4
  01 5A 0C 01

btmon log:
< HCI Command: Read Default Erroneous Data Reporting (0x03|0x005a) plen 0
> HCI Event: Command Complete (0x0e) plen 4
      Read Default Erroneous Data Reporting (0x03|0x005a) ncmd 1
        Status: Unknown HCI Command (0x01)

Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 06a854a2507e..e48c3ad069bb 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -3339,6 +3339,7 @@ static int btusb_setup_qca(struct hci_dev *hdev)
 	 * work with the likes of HSP/HFP mSBC.
 	 */
 	set_bit(HCI_QUIRK_BROKEN_ENHANCED_SETUP_SYNC_CONN, &hdev->quirks);
+	set_bit(HCI_QUIRK_BROKEN_ERR_DATA_REPORTING, &hdev->quirks);
 
 	return 0;
 }
-- 
2.35.1

