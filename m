Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76E4B65810A
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233310AbiL1QYi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:24:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234738AbiL1QXz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:23:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DA701AA1E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:20:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3F32B817AC
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:20:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 104BBC433EF;
        Wed, 28 Dec 2022 16:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244438;
        bh=HuhbE6NE4mxiR3nqkrr9+D4M4gR4/rGw8e7UU0+8XNQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NEMBKiGqaifZGhhiANP8gwAVAQd9dRDp0AINGMKKyBCBCMhGRO2EjTqVK5FPFXvE7
         LdmcYfSRVjVzBLrbyM9ZibcBDM/oyKmbXmMIa0t1BAUd/h/TXXKHUzZRgo7Izh3fxH
         XPrVUgBEKVPkYHFCzD2bkByV1yY8wOPXKtDQ1B2g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Johannes Thumshirn <jth@kernel.org>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0710/1073] mcb: mcb-parse: fix error handing in chameleon_parse_gdd()
Date:   Wed, 28 Dec 2022 15:38:18 +0100
Message-Id: <20221228144347.316787998@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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



