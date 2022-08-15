Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4CD6593FA7
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233428AbiHOVOd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:14:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231867AbiHOVMy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:12:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E02D9E88;
        Mon, 15 Aug 2022 12:19:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3F5860FAD;
        Mon, 15 Aug 2022 19:19:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE307C433C1;
        Mon, 15 Aug 2022 19:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591177;
        bh=8TplkGd97N18pN9xdr3NQUO0P7WdvSM5cJZ6n9xVWmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dco02L137gEjscKqSamDkC9myKKXkcfGKh2vsojkonO+5/VvbOa4Em3Z+OwMliZq0
         q7ieW99x9K/lG8qV94xsNT2Jsyq/CCEe2VDiBiBI9KhWcIW3r/IU4kT39hK7VfXxkG
         b7xbn9iW3fyOTUVfgHhwCh6vOlYkFFCzolTYajJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0495/1095] Bluetooth: hci_intel: Add check for platform_driver_register
Date:   Mon, 15 Aug 2022 19:58:14 +0200
Message-Id: <20220815180450.002752306@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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



