Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB338541848
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379368AbiFGVL6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:11:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380156AbiFGVLf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:11:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0676E1498E3;
        Tue,  7 Jun 2022 11:53:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E3D4B81FE1;
        Tue,  7 Jun 2022 18:53:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D99EAC385A2;
        Tue,  7 Jun 2022 18:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627997;
        bh=KPrctiGxlv//O7HkBngTp+QRuLCMbHbeWLwuZvRLw1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J1DxivFZTISPTZ5dAyk+9Ci2/1uQoakrb5aqj5JTbT782y40rPKllw+kgpcMeuQpn
         pzZyot3jX29CrUURNRieuVCY/JMZtI85AWmPgHVvqVfgUaT5TJv3pkvayovthJ0bd3
         orHMP35SvPLAes6BWym9Lk9ACukrDU5S8rAHVD80=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 170/879] Bluetooth: btusb: Set HCI_QUIRK_BROKEN_ENHANCED_SETUP_SYNC_CONN for QCA
Date:   Tue,  7 Jun 2022 18:54:48 +0200
Message-Id: <20220607165007.644159709@linuxfoundation.org>
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



