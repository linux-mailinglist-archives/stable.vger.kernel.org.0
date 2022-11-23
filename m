Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A182A635553
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237422AbiKWJSG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:18:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237338AbiKWJRh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:17:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D53310AD0A
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:17:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20711B81E50
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:17:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6569FC433D6;
        Wed, 23 Nov 2022 09:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195040;
        bh=6RZWYC1vgxe9Pqj4chLkaY/6M7VYNi4xgg2j5+MALRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AMwLSS2rAugh3gC86KOnGwVN8E/6zi1K6UmkzSNUeQXwfzz4ipBTajB0ti1wpT4pm
         71G9OrFDRd5kVrutWLLbkUW0US1udv5I9DRZwtJwgQc7usskaZyn4wNwYCIIHI7ZBp
         CdKxUTJxKgpZ7I7x9NRhnMnLnx0D63gewTgsS0wM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wang ShaoBo <bobo.shaobowang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 100/156] mISDN: fix misuse of put_device() in mISDN_register_device()
Date:   Wed, 23 Nov 2022 09:50:57 +0100
Message-Id: <20221123084601.603902782@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
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

From: Wang ShaoBo <bobo.shaobowang@huawei.com>

[ Upstream commit 2d25107e111a85c56f601a5470f1780ec054e6ac ]

We should not release reference by put_device() before calling device_initialize().

Fixes: e7d1d4d9ac0d ("mISDN: fix possible memory leak in mISDN_register_device()")
Signed-off-by: Wang ShaoBo <bobo.shaobowang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/mISDN/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/isdn/mISDN/core.c b/drivers/isdn/mISDN/core.c
index 7ea0100f218a..90ee56d07a6e 100644
--- a/drivers/isdn/mISDN/core.c
+++ b/drivers/isdn/mISDN/core.c
@@ -222,7 +222,7 @@ mISDN_register_device(struct mISDNdevice *dev,
 
 	err = get_free_devid();
 	if (err < 0)
-		goto error1;
+		return err;
 	dev->id = err;
 
 	device_initialize(&dev->dev);
-- 
2.35.1



