Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBE96541B5B
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351803AbiFGVqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381745AbiFGVow (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:44:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31697235118;
        Tue,  7 Jun 2022 12:07:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94C42B81F6D;
        Tue,  7 Jun 2022 19:07:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1D24C385A2;
        Tue,  7 Jun 2022 19:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628841;
        bh=74S82kLFV4attk0fZoUqvtIlkJyl4CWuDDsLRNHjqLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g1Ya9QwgM6xbGXD1QsnTd70BDXXBqwUu2G1zIS7DQj3wGq12ymijsgdqXVRu5vCxa
         IvbwDU/zxEBE1z9UQ3oSVFLM/InxpSrPYMTEdIM1LcukNMdR6fMYmDqOjxG09PyRVy
         EKecRS8ZY/cRb7px1DWqm5arLuONMv9oUr26P9s4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yake Yang <yake.yang@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 458/879] Bluetooth: btmtksdio: fix the reset takes too long
Date:   Tue,  7 Jun 2022 18:59:36 +0200
Message-Id: <20220607165016.166596385@linuxfoundation.org>
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

[ Upstream commit baabb7f530e8a3f0085d12f4ea0bada4115515d3 ]

Sending WMT command during the reset in progress is invalid and would get
no response from firmware until the reset is complete, so we ignore the WMT
command here to resolve the issue which causes the whole reset process
taking too long.

Fixes: 8fafe702253d ("Bluetooth: mt7921s: support bluetooth reset mechanism")
Co-developed-by: Yake Yang <yake.yang@mediatek.com>
Signed-off-by: Yake Yang <yake.yang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtksdio.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/bluetooth/btmtksdio.c b/drivers/bluetooth/btmtksdio.c
index 5d13c1f61bd3..d6700efcfe8c 100644
--- a/drivers/bluetooth/btmtksdio.c
+++ b/drivers/bluetooth/btmtksdio.c
@@ -1189,6 +1189,10 @@ static int btmtksdio_shutdown(struct hci_dev *hdev)
 	 */
 	pm_runtime_get_sync(bdev->dev);
 
+	/* wmt command only works until the reset is complete */
+	if (test_bit(BTMTKSDIO_HW_RESET_ACTIVE, &bdev->tx_state))
+		goto ignore_wmt_cmd;
+
 	/* Disable the device */
 	wmt_params.op = BTMTK_WMT_FUNC_CTRL;
 	wmt_params.flag = 0;
@@ -1202,6 +1206,7 @@ static int btmtksdio_shutdown(struct hci_dev *hdev)
 		return err;
 	}
 
+ignore_wmt_cmd:
 	pm_runtime_put_noidle(bdev->dev);
 	pm_runtime_disable(bdev->dev);
 
-- 
2.35.1



