Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4C1F59392E
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244853AbiHOTCy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245526AbiHOTCR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:02:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E4E933E30;
        Mon, 15 Aug 2022 11:33:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2748CB8105C;
        Mon, 15 Aug 2022 18:33:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AB3DC433C1;
        Mon, 15 Aug 2022 18:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588401;
        bh=8TplkGd97N18pN9xdr3NQUO0P7WdvSM5cJZ6n9xVWmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Up/1Vk+9BU1uphqQM/iS3u5520owWz1j/5mJk3FK5dkSRdzAlteylCMUVZKbYYHbB
         3okI4YZy96YFMUAqTV7U1U5Zk41N/sUhrNmImuGHH43VfW+hiCPQ5fjGGhFjuH6tZt
         8K9Bb0pc9ztXBpaf50e7FW8J8qHhefDZ7hDE7Dy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 361/779] Bluetooth: hci_intel: Add check for platform_driver_register
Date:   Mon, 15 Aug 2022 20:00:05 +0200
Message-Id: <20220815180352.668150891@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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
index 7249b91d9b91..78afb9a348e7 100644
--- a/drivers/bluetooth/hci_intel.c
+++ b/drivers/bluetooth/hci_intel.c
@@ -1217,7 +1217,11 @@ static struct platform_driver intel_driver = {
 
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



