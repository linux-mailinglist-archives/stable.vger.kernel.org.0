Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE17635879
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:58:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235880AbiKWJ6M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:58:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236131AbiKWJ5V (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:57:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 147AE7EBC5
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:52:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4D8761B29
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:52:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0674C433D6;
        Wed, 23 Nov 2022 09:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197121;
        bh=YZ+S0vucD44X6LY7bzJAP9aj14ecwMl4oDo+xG+qMmc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uT8h6J+XEVh7E+lxru7x8n4L1i9CSIKlgMRdV6N5bvsBW5lPjjwJmXHl42n0zvdGo
         izHvUuz8cr8qXJxejTo7LO1XmF1KXvQ4mC/MThYEdLFVMl3oeYUGzvnmq1UUa4OHH9
         qs2QEwmwyzLNVGYzIWRVWPi7ag8eyUxOTKUafvXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        Shay Agroskin <shayagr@amazon.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 172/314] net: ena: Fix error handling in ena_init()
Date:   Wed, 23 Nov 2022 09:50:17 +0100
Message-Id: <20221123084633.348765766@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit d349e9be5a2c2d7588a2c4e4bfa0bb3dc1226769 ]

The ena_init() won't destroy workqueue created by
create_singlethread_workqueue() when pci_register_driver() failed.
Call destroy_workqueue() when pci_register_driver() failed to prevent the
resource leak.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Acked-by: Shay Agroskin <shayagr@amazon.com>
Link: https://lore.kernel.org/r/20221114025659.124726-1-yuancan@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 6a356a6cee15..41c821348476 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -4545,13 +4545,19 @@ static struct pci_driver ena_pci_driver = {
 
 static int __init ena_init(void)
 {
+	int ret;
+
 	ena_wq = create_singlethread_workqueue(DRV_MODULE_NAME);
 	if (!ena_wq) {
 		pr_err("Failed to create workqueue\n");
 		return -ENOMEM;
 	}
 
-	return pci_register_driver(&ena_pci_driver);
+	ret = pci_register_driver(&ena_pci_driver);
+	if (ret)
+		destroy_workqueue(ena_wq);
+
+	return ret;
 }
 
 static void __exit ena_cleanup(void)
-- 
2.35.1



