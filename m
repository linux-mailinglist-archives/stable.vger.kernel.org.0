Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96DB154187C
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359199AbiFGVMg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380181AbiFGVLk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:11:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD3E218A86;
        Tue,  7 Jun 2022 11:53:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B1AFB82018;
        Tue,  7 Jun 2022 18:53:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 807E5C385A5;
        Tue,  7 Jun 2022 18:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628002;
        bh=ZY+9bOivnNwE6I+fPAkFM/4luhtBKoOnJATkvk/5Qi4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mgpHxWMjXGYlaEPKef5OYDzfFk66eShA5ewj8JzNRyOa3N6nosmn3wmNjKO43Rj8v
         MXzBAMm+DTuhxlrlw7AmlIVuEgCrMhcqPzMPhUDOInh8XbnSzYMt3/ia81N1VE5Zal
         Dinnehu9kjAKiNJLX/frdMm8+EwEz1piYY3/bRn8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zijun Hu <quic_zijuhu@quicinc.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 171/879] Bluetooth: btusb: Set HCI_QUIRK_BROKEN_ERR_DATA_REPORTING for QCA
Date:   Tue,  7 Jun 2022 18:54:49 +0200
Message-Id: <20220607165007.675903937@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



