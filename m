Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF413657CF6
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:37:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233501AbiL1Phy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:37:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233505AbiL1Phw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:37:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A626A1658C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:37:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42B416155B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:37:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51909C433EF;
        Wed, 28 Dec 2022 15:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241870;
        bh=7ljlnLcKf9jbkj65tY/z1q7swUbRQNxZMhQJK4+O5Pw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ytwdHkz++0qJyRwqf0HzI51PmXBfKJVGVR043WUN98zod7Tx7o+IzH0zegSpJBgOe
         pmz4UnOfxwhEH6vMa4Ut6Hv1T1RcEp9gyzLM59dpsKWKQC3xbDAu2sR0c2WHaL3khg
         WVFyho1FuZa+l7fi/6G+rKNZWXJHV7OtMAYEwSxE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hui Tang <tanghui20@huawei.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0338/1073] mtd: lpddr2_nvm: Fix possible null-ptr-deref
Date:   Wed, 28 Dec 2022 15:32:06 +0100
Message-Id: <20221228144337.185888238@linuxfoundation.org>
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

From: Hui Tang <tanghui20@huawei.com>

[ Upstream commit 6bdd45d795adf9e73b38ced5e7f750cd199499ff ]

It will cause null-ptr-deref when resource_size(add_range) invoked,
if platform_get_resource() returns NULL.

Fixes: 96ba9dd65788 ("mtd: lpddr: add driver for LPDDR2-NVM PCM memories")
Signed-off-by: Hui Tang <tanghui20@huawei.com>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20221114090240.244172-1-tanghui20@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/lpddr/lpddr2_nvm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mtd/lpddr/lpddr2_nvm.c b/drivers/mtd/lpddr/lpddr2_nvm.c
index 367e2d906de0..e71af4c49096 100644
--- a/drivers/mtd/lpddr/lpddr2_nvm.c
+++ b/drivers/mtd/lpddr/lpddr2_nvm.c
@@ -433,6 +433,8 @@ static int lpddr2_nvm_probe(struct platform_device *pdev)
 
 	/* lpddr2_nvm address range */
 	add_range = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!add_range)
+		return -ENODEV;
 
 	/* Populate map_info data structure */
 	*map = (struct map_info) {
-- 
2.35.1



