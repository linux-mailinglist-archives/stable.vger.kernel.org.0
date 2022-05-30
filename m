Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF6D537D80
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 15:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237302AbiE3Njo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238238AbiE3Ngg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:36:36 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6564F986F8;
        Mon, 30 May 2022 06:29:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 970E5CE1020;
        Mon, 30 May 2022 13:29:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3BB3C3411A;
        Mon, 30 May 2022 13:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917394;
        bh=KPrctiGxlv//O7HkBngTp+QRuLCMbHbeWLwuZvRLw1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JktOk9xfP22wCjk5uS1MNvvsVASEguUo89ZVs1u7q3EbIQbjNP4MGxH7ByQe2xZ60
         G04F84hZkmShew66Q56O3gCcAONO9Xt8SRaMyV0tttNiqrcTcK5gPRkVA7N905hTvF
         QtPpvbGbWuuauOoRKZzcTI0g+1l2Tf3Pi+e1cQVDBeZAs1NVYvDEk72M4Sm0vayMcS
         k8hLX/SwuTqYmB/zby0xCmYRcUlTnFKAirBFXc9YrdnYjHO7oYcqIW6b2mpcCzBrxI
         XC1vBR1l+mePhPdMf4aSNIWc3AEGc9LOzeDeKC+ILItfMHgzmc1um8pFVY+9y04REx
         LUlzceanZ54pg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>, johan.hedberg@gmail.com,
        luiz.dentz@gmail.com, linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 120/159] Bluetooth: btusb: Set HCI_QUIRK_BROKEN_ENHANCED_SETUP_SYNC_CONN for QCA
Date:   Mon, 30 May 2022 09:23:45 -0400
Message-Id: <20220530132425.1929512-120-sashal@kernel.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit d44e1dbda36fff5d7c2586683c4adc0963aef908 ]

This sets HCI_QUIRK_BROKEN_ENHANCED_SETUP_SYNC_CONN for QCA controllers
since SCO appear to not work when using HCI_OP_ENHANCED_SETUP_SYNC_CONN.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=215576
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 50df417207af..06a854a2507e 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -3335,6 +3335,11 @@ static int btusb_setup_qca(struct hci_dev *hdev)
 			msleep(QCA_BT_RESET_WAIT_MS);
 	}
 
+	/* Mark HCI_OP_ENHANCED_SETUP_SYNC_CONN as broken as it doesn't seem to
+	 * work with the likes of HSP/HFP mSBC.
+	 */
+	set_bit(HCI_QUIRK_BROKEN_ENHANCED_SETUP_SYNC_CONN, &hdev->quirks);
+
 	return 0;
 }
 
-- 
2.35.1

