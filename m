Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8256581A2
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234683AbiL1QaQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:30:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234674AbiL1Q3v (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:29:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC7141B798
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:26:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6732A6157A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:26:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75B88C433EF;
        Wed, 28 Dec 2022 16:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244769;
        bh=HuhbE6NE4mxiR3nqkrr9+D4M4gR4/rGw8e7UU0+8XNQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XH9CKxPwv4ytwchbCw2KXqCf24iEV9a6voeGzE8btS2RaIBnDDYI1N6bhj0mebsK4
         vQavwvp0i2nrC32p5Hx+2OBbd4xeVEm6o7Bdpfga+2cbUIkb/oTioDew8dy85HzPbc
         9hnh2iiZHyeipXG+K3DThoZ0E7BmFS7Vmk1cPhTE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Johannes Thumshirn <jth@kernel.org>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0733/1146] mcb: mcb-parse: fix error handing in chameleon_parse_gdd()
Date:   Wed, 28 Dec 2022 15:37:52 +0100
Message-Id: <20221228144350.056205462@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

[ Upstream commit 728ac3389296caf68638628c987aeae6c8851e2d ]

If mcb_device_register() returns error in chameleon_parse_gdd(), the refcount
of bus and device name are leaked. Fix this by calling put_device() to give up
the reference, so they can be released in mcb_release_dev() and kobject_cleanup().

Fixes: 3764e82e5150 ("drivers: Introduce MEN Chameleon Bus")
Reviewed-by: Johannes Thumshirn <jth@kernel.org>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Johannes Thumshirn <jth@kernel.org>
Link: https://lore.kernel.org/r/ebfb06e39b19272f0197fa9136b5e4b6f34ad732.1669624063.git.johannes.thumshirn@wdc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mcb/mcb-parse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mcb/mcb-parse.c b/drivers/mcb/mcb-parse.c
index 0266bfddfbe2..aa6938da0db8 100644
--- a/drivers/mcb/mcb-parse.c
+++ b/drivers/mcb/mcb-parse.c
@@ -108,7 +108,7 @@ static int chameleon_parse_gdd(struct mcb_bus *bus,
 	return 0;
 
 err:
-	mcb_free_dev(mdev);
+	put_device(&mdev->dev);
 
 	return ret;
 }
-- 
2.35.1



