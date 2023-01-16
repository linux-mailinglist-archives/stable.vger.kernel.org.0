Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB26B66CA53
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233789AbjAPRCS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:02:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234173AbjAPRBv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:01:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 479545AB66
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:43:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04F73B81095
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:43:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E80C433EF;
        Mon, 16 Jan 2023 16:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887420;
        bh=6zh/GSs8S8a6sbIlE4/O3foUDAhbqIq1HKEl9JwpHc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dCC4hfnzJtPY2ARahad+sr7dtWxIWJI8LkOg6m/DDquKl0GmkJDElMjzZzTN7FHJ2
         SvrbcUHxzXWbcF33V4EQm+nNhwJOgpvsJOg2KBBP4yfTyT829XBYWchtfLjXnoKYEF
         TPMUuqrNRAIjz1IztJw921lm2TIzzB4piKJbTWjQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 143/521] mmc: meson-gx: fix return value check of mmc_add_host()
Date:   Mon, 16 Jan 2023 16:46:45 +0100
Message-Id: <20230116154853.670446967@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

[ Upstream commit 90935f16f2650ab7416fa2ffbe5c28cb39cf3f1e ]

mmc_add_host() may return error, if we ignore its return value,
it will lead two issues:
1. The memory that allocated in mmc_alloc_host() is leaked.
2. In the remove() path, mmc_remove_host() will be called to
   delete device, but it's not added yet, it will lead a kernel
   crash because of null-ptr-deref in device_del().

Fix this by checking the return value and goto error path which
will call mmc_free_host().

Fixes: 51c5d8447bd7 ("MMC: meson: initial support for GX platforms")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20221108123417.479045-1-yangyingliang@huawei.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/meson-gx-mmc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/meson-gx-mmc.c b/drivers/mmc/host/meson-gx-mmc.c
index 72f34a58928c..dba98c2886f2 100644
--- a/drivers/mmc/host/meson-gx-mmc.c
+++ b/drivers/mmc/host/meson-gx-mmc.c
@@ -1370,7 +1370,9 @@ static int meson_mmc_probe(struct platform_device *pdev)
 	}
 
 	mmc->ops = &meson_mmc_ops;
-	mmc_add_host(mmc);
+	ret = mmc_add_host(mmc);
+	if (ret)
+		goto err_free_irq;
 
 	return 0;
 
-- 
2.35.1



