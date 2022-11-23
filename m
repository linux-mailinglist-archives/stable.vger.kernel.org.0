Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0B96353F5
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:02:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236845AbiKWJAY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:00:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236826AbiKWJAW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:00:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC08872097
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:00:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BD1D61B10
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6748EC433C1;
        Wed, 23 Nov 2022 09:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194019;
        bh=BUm0QnloEu5jTmCS/qr9CvSCsce7s8EsWk/BKN/eiN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iO5CXQL+mbpTzoJ60i/ej8SINcwtPzfzEG1nkUUQMACKcGHJZW6ncV2n75jQQfD4n
         Bxaxysx7kaP+knNyg5h+zKgjzxPFNUAK53eypCkQ3GaTDYHuiHYXV5ByV6IivycP5k
         j1v0IGXa9f2T7AGzbSUPmDURW/5POXHanORfSMZg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wang ShaoBo <bobo.shaobowang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 47/88] mISDN: fix misuse of put_device() in mISDN_register_device()
Date:   Wed, 23 Nov 2022 09:50:44 +0100
Message-Id: <20221123084550.154734683@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084548.535439312@linuxfoundation.org>
References: <20221123084548.535439312@linuxfoundation.org>
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
index 5cd53b2c47c7..e542439f4950 100644
--- a/drivers/isdn/mISDN/core.c
+++ b/drivers/isdn/mISDN/core.c
@@ -231,7 +231,7 @@ mISDN_register_device(struct mISDNdevice *dev,
 
 	err = get_free_devid();
 	if (err < 0)
-		goto error1;
+		return err;
 	dev->id = err;
 
 	device_initialize(&dev->dev);
-- 
2.35.1



