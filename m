Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D38D76AEEC0
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:15:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232550AbjCGSP4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:15:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232607AbjCGSO4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:14:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 697E0A6BE6
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:10:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C465614DF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:10:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CA56C4339C;
        Tue,  7 Mar 2023 18:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212629;
        bh=ikaPOVkBs20x7SKIdRC3nkcYptCk9juuj1IYP3FYGPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ntCiocsDpQ7J/wGdqBpLNz/QmrbmJFrtEycA29Okm1JSvGaySlRG154XiVaxEPZRO
         W8b5PKlJtr39Od73+orNj0xZms7u/n2YGxAThKy89rihRLzjrYzlW2uUZe6hYsiiNp
         1JUkBXaCJLstguSlTYBfFKcaD+Zj20YNvrlhwySE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengping Jiang <jiangzp@google.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 215/885] Bluetooth: hci_qca: get wakeup status from serdev device handle
Date:   Tue,  7 Mar 2023 17:52:29 +0100
Message-Id: <20230307170011.428748410@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhengping Jiang <jiangzp@google.com>

[ Upstream commit 03b0093f7b310493bc944a20f725228cfe0d3fea ]

Bluetooth controller attached via the UART is handled by the serdev driver.
Get the wakeup status from the device handle through serdev, instead of the
parent path.

Fixes: c1a74160eaf1 ("Bluetooth: hci_qca: Add device_may_wakeup support")
Signed-off-by: Zhengping Jiang <jiangzp@google.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_qca.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index e4398590b0edc..7b9fd5f104335 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -1582,10 +1582,11 @@ static bool qca_wakeup(struct hci_dev *hdev)
 	struct hci_uart *hu = hci_get_drvdata(hdev);
 	bool wakeup;
 
-	/* UART driver handles the interrupt from BT SoC.So we need to use
-	 * device handle of UART driver to get the status of device may wakeup.
+	/* BT SoC attached through the serial bus is handled by the serdev driver.
+	 * So we need to use the device handle of the serdev driver to get the
+	 * status of device may wakeup.
 	 */
-	wakeup = device_may_wakeup(hu->serdev->ctrl->dev.parent);
+	wakeup = device_may_wakeup(&hu->serdev->ctrl->dev);
 	bt_dev_dbg(hu->hdev, "wakeup status : %d", wakeup);
 
 	return wakeup;
-- 
2.39.2



