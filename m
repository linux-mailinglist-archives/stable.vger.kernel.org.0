Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D073859D774
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241460AbiHWJmT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352120AbiHWJk4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:40:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 214327A50E;
        Tue, 23 Aug 2022 01:41:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D713761257;
        Tue, 23 Aug 2022 08:41:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCBB0C433C1;
        Tue, 23 Aug 2022 08:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244108;
        bh=i6FXr4E8XnfuMt9Ll0SUB8OusLyDbQ0jV4V7ZXzwMAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qsJjY1fjncRyJXOgFCWKU762V10KhkpguGxo/6vMJLo7m3ENUWoTkS/y3CJ7j6odr
         tq7MspQvSYhaThC99z5ZyZJpdVjZEpCAz/tyYneCy0dpRvyv2e27ZcEXOlH1XTg/2k
         SVJXKhy0mVxQrENYNrylSX9riHnZK5ohzvFne/d0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 087/229] Bluetooth: hci_intel: Add check for platform_driver_register
Date:   Tue, 23 Aug 2022 10:24:08 +0200
Message-Id: <20220823080056.829750151@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
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

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit ab2d2a982ff721f4b029282d9a40602ea46a745e ]

As platform_driver_register() could fail, it should be better
to deal with the return value in order to maintain the code
consisitency.

Fixes: 1ab1f239bf17 ("Bluetooth: hci_intel: Add support for platform driver")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_intel.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/hci_intel.c b/drivers/bluetooth/hci_intel.c
index c75311d4dd31..cbe4a2159d43 100644
--- a/drivers/bluetooth/hci_intel.c
+++ b/drivers/bluetooth/hci_intel.c
@@ -1303,7 +1303,11 @@ static struct platform_driver intel_driver = {
 
 int __init intel_init(void)
 {
-	platform_driver_register(&intel_driver);
+	int err;
+
+	err = platform_driver_register(&intel_driver);
+	if (err)
+		return err;
 
 	return hci_uart_register_proto(&intel_proto);
 }
-- 
2.35.1



