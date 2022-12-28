Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACD87657C48
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233816AbiL1Paz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:30:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233832AbiL1Pat (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:30:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22AD310E5
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:30:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4C256154D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:30:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9825C433D2;
        Wed, 28 Dec 2022 15:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241448;
        bh=Lo+z/ksi6TJW+4fOI3/ioxvulWTy79WUrGww0ha3Hlo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OPU1Fi+/64UQJzxKOK9FMnqO+6cnJePVA5r/oJiYL0WcLsP6ImJl3xw73AdiHsvgt
         3IhbaNOIocjYLUsdpZ5BlSl/dew6Im5WFmriwBhSImkkHqtoC0kYq1i2sZSxzb1pVQ
         OMhvvgkCyzu91pc4eyN66Aa6x0ToZtt2QJWal8UE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        Johannes Thumshirn <jth@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 483/731] drivers: mcb: fix resource leak in mcb_probe()
Date:   Wed, 28 Dec 2022 15:39:50 +0100
Message-Id: <20221228144310.551485686@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit d7237462561fcd224fa687c56ccb68629f50fc0d ]

When probe hook function failed in mcb_probe(), it doesn't put the device.
Compiled test only.

Fixes: 7bc364097a89 ("mcb: Acquire reference to device in probe")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Signed-off-by: Johannes Thumshirn <jth@kernel.org>
Link: https://lore.kernel.org/r/9f87de36bfb85158b506cb78c6fc9db3f6a3bad1.1669624063.git.johannes.thumshirn@wdc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mcb/mcb-core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mcb/mcb-core.c b/drivers/mcb/mcb-core.c
index cf128b3471d7..0530db548231 100644
--- a/drivers/mcb/mcb-core.c
+++ b/drivers/mcb/mcb-core.c
@@ -71,8 +71,10 @@ static int mcb_probe(struct device *dev)
 
 	get_device(dev);
 	ret = mdrv->probe(mdev, found_id);
-	if (ret)
+	if (ret) {
 		module_put(carrier_mod);
+		put_device(dev);
+	}
 
 	return ret;
 }
-- 
2.35.1



