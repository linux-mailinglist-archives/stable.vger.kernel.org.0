Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6AB4F279B
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233476AbiDEIHk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236064AbiDEIBO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:01:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E1749FB3;
        Tue,  5 Apr 2022 00:59:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49AC9B81B14;
        Tue,  5 Apr 2022 07:59:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAF54C340EE;
        Tue,  5 Apr 2022 07:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145554;
        bh=oArQntQ2xK9uXGxSl7HUbf1gsJ4VFCTOgbBBaJnSz1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s9i/wjugkXQ8q5yEqTs1gEQhcUYfMgo/8HWVke2pnZ450/Y/Z1KxyXK1D+VTvldqe
         lo8UNpmdnT5pUFovwtFw13zwkxXGUzrcfFwqgYiRrcN6kRK8dPx8X1GlF70jcNygfk
         Yn8WvGg0CdR5j6PkISitr+h+bTsrV2Uta++r9NIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Mark Chen <mark-yw.chen@mediatek.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0447/1126] Bluetooth: mt7921s: fix bus hang with wrong privilege
Date:   Tue,  5 Apr 2022 09:19:54 +0200
Message-Id: <20220405070420.744521088@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Mark Chen <mark-yw.chen@mediatek.com>

[ Upstream commit 752aea58489fd42f5c54dc50cb098d19e486ae61 ]

According to chip hw flow, mt7921s need to re-acquire privilege
again before normal running. Otherwise, the bus may be stuck in
an abnormal status.

Fixes: c603bf1f94d0 ("Bluetooth: btmtksdio: add MT7921s Bluetooth support")
Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Mark Chen <mark-yw.chen@mediatek.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtksdio.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/bluetooth/btmtksdio.c b/drivers/bluetooth/btmtksdio.c
index d4e2541a4873..c05578b52d33 100644
--- a/drivers/bluetooth/btmtksdio.c
+++ b/drivers/bluetooth/btmtksdio.c
@@ -872,6 +872,15 @@ static int btmtksdio_setup(struct hci_dev *hdev)
 		err = mt79xx_setup(hdev, fwname);
 		if (err < 0)
 			return err;
+
+		err = btmtksdio_fw_pmctrl(bdev);
+		if (err < 0)
+			return err;
+
+		err = btmtksdio_drv_pmctrl(bdev);
+		if (err < 0)
+			return err;
+
 		break;
 	case 0x7663:
 	case 0x7668:
-- 
2.34.1



