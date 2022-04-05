Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 744634F2795
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233454AbiDEIHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236113AbiDEIB1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:01:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B44C449FB3;
        Tue,  5 Apr 2022 00:59:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61CB0B81B14;
        Tue,  5 Apr 2022 07:59:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C767DC340EE;
        Tue,  5 Apr 2022 07:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145567;
        bh=k/Nu6HhUs1n1eK9fQ7ZoaxUfQreYqehxzCU7JsCIUBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vmxYCJbAMT19yLHVlhapoVd59spJo/7ke5E8/L18yryWaq9eynTpJq+cj+/CRoZMI
         PtRF2g8+25nSCOJN/w1S2H7yfnO55Ax91gjF519sRxk76G0zGnu184FOgKCA8RUXd4
         sl8dAg8vGvzW/s8LWB4Mp5l5cYxJfec2JZEKJJ5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0450/1126] Bluetooth: btmtksdio: mask out interrupt status
Date:   Tue,  5 Apr 2022 09:19:57 +0200
Message-Id: <20220405070420.833130061@linuxfoundation.org>
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

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit db3f1f9b5d88d8d7f9eaa486f71784dd319285ff ]

Currently, there is a loop in btmtksdio_txrx_work() which iteratively
executes until the variable int_status is zero.

But the variable int_status should be masked out with the actual interrupt
sources (MTK_REG_CHISR bit 0-15) before we check the loop condition.
Otherwise, RX_PKT_LEN (MTK_REG_CHISR bit 16-31) which is read-only and
unclearable would cause the loop to get stuck on some chipsets like
MT7663s.

Fixes: 26270bc189ea ("Bluetooth: btmtksdio: move interrupt service to work")
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtksdio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btmtksdio.c b/drivers/bluetooth/btmtksdio.c
index 72e00264d9f1..86a52eb77e01 100644
--- a/drivers/bluetooth/btmtksdio.c
+++ b/drivers/bluetooth/btmtksdio.c
@@ -92,6 +92,7 @@ MODULE_DEVICE_TABLE(sdio, btmtksdio_table);
 #define TX_EMPTY		BIT(2)
 #define TX_FIFO_OVERFLOW	BIT(8)
 #define FW_MAILBOX_INT		BIT(15)
+#define INT_MASK		GENMASK(15, 0)
 #define RX_PKT_LEN		GENMASK(31, 16)
 
 #define MTK_REG_CSICR		0xc0
@@ -565,6 +566,7 @@ static void btmtksdio_txrx_work(struct work_struct *work)
 		 * FIFO.
 		 */
 		sdio_writel(bdev->func, int_status, MTK_REG_CHISR, NULL);
+		int_status &= INT_MASK;
 
 		if ((int_status & FW_MAILBOX_INT) &&
 		    bdev->data->chipid == 0x7921) {
-- 
2.34.1



