Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37404657EE2
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234164AbiL1P6q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:58:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234216AbiL1P6p (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:58:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154AA183AB
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:58:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A66706155B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:58:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFCC5C433F0;
        Wed, 28 Dec 2022 15:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243124;
        bh=AskKKRRcQqzLYBTMTG/5uzaH5GQVZxK81UJLrVlqNPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U94V8iPekX+6J/ifH42GOHOuqB6ZaSdj75f9+xVRF5SZ4kNrY3GhaEcdAMu+Oj2Ht
         mQzo7zmdbIJl1OVCWhW7ZvGHzVzj2n8kb4MbxGJ2QZqBJPxX0Ks0kZw6Rj2UtM3+8W
         8lbftay5I9GwiLHavUI7kzhMghf3KNMjhPVjFidY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0492/1073] mmc: wbsd: fix return value check of mmc_add_host()
Date:   Wed, 28 Dec 2022 15:34:40 +0100
Message-Id: <20221228144341.397955710@linuxfoundation.org>
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

[ Upstream commit dc5b9b50fc9d1334407e316e6e29a5097ef833bd ]

mmc_add_host() may return error, if we ignore its return value,
it will lead two issues:
1. The memory that allocated in mmc_alloc_host() is leaked.
2. In the remove() path, mmc_remove_host() will be called to
   delete device, but it's not added yet, it will lead a kernel
   crash because of null-ptr-deref in device_del().

So fix this by checking the return value and goto error path which
will call mmc_free_host(), besides, other resources also need be
released.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221109133237.3273558-1-yangyingliang@huawei.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/wbsd.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/wbsd.c b/drivers/mmc/host/wbsd.c
index 67ecd342fe5f..7c7ec8d10232 100644
--- a/drivers/mmc/host/wbsd.c
+++ b/drivers/mmc/host/wbsd.c
@@ -1698,7 +1698,17 @@ static int wbsd_init(struct device *dev, int base, int irq, int dma,
 	 */
 	wbsd_init_device(host);
 
-	mmc_add_host(mmc);
+	ret = mmc_add_host(mmc);
+	if (ret) {
+		if (!pnp)
+			wbsd_chip_poweroff(host);
+
+		wbsd_release_resources(host);
+		wbsd_free_mmc(dev);
+
+		mmc_free_host(mmc);
+		return ret;
+	}
 
 	pr_info("%s: W83L51xD", mmc_hostname(mmc));
 	if (host->chip_id != 0)
-- 
2.35.1



