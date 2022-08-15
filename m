Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75AEE594973
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355467AbiHOX4O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356138AbiHOXxt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:53:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5921E15DFB8;
        Mon, 15 Aug 2022 13:18:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C80EEB81181;
        Mon, 15 Aug 2022 20:18:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21197C433D6;
        Mon, 15 Aug 2022 20:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594705;
        bh=rrQeGSVgnu2T3cpBdnktpWmYUw4Kt7wbOPiN/PrBLLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iiAekdqioJsN9giKbMfpp9yYY16U7A5Lt1fhw5v45B87G73kIn+wMUCx0aEhoE2MK
         3Ssreyv56PphyDmc+8hWHVtPW48iNWn1fRGQQQnXXd7GEw0x6B6XxFIsZAeqVnP517
         dZgEogwzg4/+X12rVv4m2cgLHM2oFnxCc7LsSlYM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ying Hsu <yinghsu@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0532/1157] Bluetooth: Add default wakeup callback for HCI UART driver
Date:   Mon, 15 Aug 2022 19:58:08 +0200
Message-Id: <20220815180500.931122485@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Ying Hsu <yinghsu@chromium.org>

[ Upstream commit bee5395ced44c5a312348557eb2dfb0c2a7bfaa2 ]

Bluetooth HCI devices indicate if they are able to wakeup in the wakeup
callback since 'commit 4539ca67fe8e ("Bluetooth: Rename driver
.prevent_wake to .wakeup")'. This patch adds a default wakeup callback
for Bluetooth HCI UAR devices. It assumes Bluetooth HCI UART devices are
wakeable for backward compatibility. For those who need a customized
behavior, one can override it before calling hci_uart_register_device().

Fixes: 4539ca67fe8e ("Bluetooth: Rename driver .prevent_wake to .wakeup")
Signed-off-by: Ying Hsu <yinghsu@chromium.org>
Reviewed-by: Alain Michaud <alainm@chromium.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_serdev.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/bluetooth/hci_serdev.c b/drivers/bluetooth/hci_serdev.c
index 4cda890ce647..c0e5f42ec6b7 100644
--- a/drivers/bluetooth/hci_serdev.c
+++ b/drivers/bluetooth/hci_serdev.c
@@ -231,6 +231,15 @@ static int hci_uart_setup(struct hci_dev *hdev)
 	return 0;
 }
 
+/* Check if the device is wakeable */
+static bool hci_uart_wakeup(struct hci_dev *hdev)
+{
+	/* HCI UART devices are assumed to be wakeable by default.
+	 * Implement wakeup callback to override this behavior.
+	 */
+	return true;
+}
+
 /** hci_uart_write_wakeup - transmit buffer wakeup
  * @serdev: serial device
  *
@@ -342,6 +351,8 @@ int hci_uart_register_device(struct hci_uart *hu,
 	hdev->flush = hci_uart_flush;
 	hdev->send  = hci_uart_send_frame;
 	hdev->setup = hci_uart_setup;
+	if (!hdev->wakeup)
+		hdev->wakeup = hci_uart_wakeup;
 	SET_HCIDEV_DEV(hdev, &hu->serdev->dev);
 
 	if (test_bit(HCI_UART_NO_SUSPEND_NOTIFIER, &hu->flags))
-- 
2.35.1



