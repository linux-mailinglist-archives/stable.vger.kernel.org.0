Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED8D0658108
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbiL1QYg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:24:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234730AbiL1QXa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:23:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 238DC1C410
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:20:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B002161568
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:20:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C41C2C433D2;
        Wed, 28 Dec 2022 16:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244433;
        bh=+bIk7tjtpkCEUlTW6HpqU00Mn2Wm+piJqHLtGfLD+A8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kLEarbVaqqLC6yj0camWivh8BpOyXmdQqHjNKMChbjJqKeEZ+IMREwwaKK58ANsuA
         K5oYLHOZ4am2Vl0C2SjPL6LmXLXBYDm8IQ9q04kQjCZA4+abAZgZ62vsBSHx2G7itH
         z7qGeSCrJxM1YghtWtXqndNbwSUeo1OI1/qCq8hw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        Johannes Thumshirn <jth@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0709/1073] drivers: mcb: fix resource leak in mcb_probe()
Date:   Wed, 28 Dec 2022 15:38:17 +0100
Message-Id: <20221228144347.290189372@linuxfoundation.org>
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
index 338fc889b357..b8ad4f16b4ac 100644
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



