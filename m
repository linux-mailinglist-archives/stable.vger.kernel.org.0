Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40F78541B03
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378398AbiFGVmZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381413AbiFGVkm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:40:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B8E23281B;
        Tue,  7 Jun 2022 12:06:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BA9A6184D;
        Tue,  7 Jun 2022 19:06:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 811E4C385A2;
        Tue,  7 Jun 2022 19:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628810;
        bh=WEl8kOHUEiPWdwBDQUAps0GyCtZmVnhXRwz9neMn+oc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ws5kc7DwCwjMiztbcTMwetGxL1v/Ez5RQ4z57KLarbf7mDC355H7Tfz8SDahrVmzD
         m6Icd2UOmYfA01XjO0Nyuj0GVkakOIBKOlcAezyznbqaWtwqVCtH7cshbnTI7itIX2
         BvnQLtPkQo3O8j6cMsZVV6jALcfaKiBUbQtOJYf0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yake Yang <yake.yang@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 457/879] Bluetooth: btmtksdio: fix possible FW initialization failure
Date:   Tue,  7 Jun 2022 18:59:35 +0200
Message-Id: <20220607165016.136929533@linuxfoundation.org>
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

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit 7469720563e01f479ec5afe06bd6f440f965d523 ]

According to FW advised sequence, mt7921s need to re-acquire privilege
immediately after the firmware download is complete before normal running.
Otherwise, it is still possible the bus may be stuck in an abnormal status
that causes FW initialization failure in the current driver.

Fixes: 752aea58489f ("Bluetooth: mt7921s: fix bus hang with wrong privilege")
Co-developed-by: Yake Yang <yake.yang@mediatek.com>
Signed-off-by: Yake Yang <yake.yang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtksdio.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/bluetooth/btmtksdio.c b/drivers/bluetooth/btmtksdio.c
index 4ae6631a7c29..5d13c1f61bd3 100644
--- a/drivers/bluetooth/btmtksdio.c
+++ b/drivers/bluetooth/btmtksdio.c
@@ -864,6 +864,14 @@ static int mt79xx_setup(struct hci_dev *hdev, const char *fwname)
 		return err;
 	}
 
+	err = btmtksdio_fw_pmctrl(bdev);
+	if (err < 0)
+		return err;
+
+	err = btmtksdio_drv_pmctrl(bdev);
+	if (err < 0)
+		return err;
+
 	/* Enable Bluetooth protocol */
 	wmt_params.op = BTMTK_WMT_FUNC_CTRL;
 	wmt_params.flag = 0;
@@ -1109,14 +1117,6 @@ static int btmtksdio_setup(struct hci_dev *hdev)
 		if (err < 0)
 			return err;
 
-		err = btmtksdio_fw_pmctrl(bdev);
-		if (err < 0)
-			return err;
-
-		err = btmtksdio_drv_pmctrl(bdev);
-		if (err < 0)
-			return err;
-
 		/* Enable SCO over I2S/PCM */
 		err = btmtksdio_sco_setting(hdev);
 		if (err < 0) {
-- 
2.35.1



