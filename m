Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77EF36212CC
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234072AbiKHNm4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:42:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234196AbiKHNmy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:42:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1162A554C0
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:42:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9420AB81AEC
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:42:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4605C433D6;
        Tue,  8 Nov 2022 13:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667914971;
        bh=ORE1VBL094YYWOIbM24hZi4n6+8NKpf8AcfpBdF8J7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R0EioWqEa7fbDZkyR6siQSjMt0KO6UP3xxZW35M53YOblNavD6O0PxT95H0FQMnz5
         onwHUwo/4psP7RYWdUYzkfk71NPnBhBcV+0+Qxgz9pU3HTD9jSW9P74sMxqA5Ho8XC
         ROnNb5wTSSra3GrwW+d6/aQSUq4FXenYNc0YDyI8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 13/40] isdn: mISDN: netjet: fix wrong check of device registration
Date:   Tue,  8 Nov 2022 14:38:58 +0100
Message-Id: <20221108133328.911317411@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133328.351887714@linuxfoundation.org>
References: <20221108133328.351887714@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit bf00f5426074249058a106a6edbb89e4b25a4d79 ]

The class is set in mISDN_register_device(), but if device_add() returns
error, it will lead to delete a device without added, fix this by using
device_is_registered() to check if the device is registered.

Fixes: a900845e5661 ("mISDN: Add support for Traverse Technologies NETJet PCI cards")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/hardware/mISDN/netjet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/isdn/hardware/mISDN/netjet.c b/drivers/isdn/hardware/mISDN/netjet.c
index 56b54aab51f9..88d380e00b51 100644
--- a/drivers/isdn/hardware/mISDN/netjet.c
+++ b/drivers/isdn/hardware/mISDN/netjet.c
@@ -970,7 +970,7 @@ nj_release(struct tiger_hw *card)
 	}
 	if (card->irq > 0)
 		free_irq(card->irq, card);
-	if (card->isac.dch.dev.dev.class)
+	if (device_is_registered(&card->isac.dch.dev.dev))
 		mISDN_unregister_device(&card->isac.dch.dev);
 
 	for (i = 0; i < 2; i++) {
-- 
2.35.1



