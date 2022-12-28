Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94CD4658205
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234809AbiL1Qcw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:32:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234792AbiL1QcX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:32:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A438B183B2
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:29:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58A77B8171E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:29:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C6DC433F0;
        Wed, 28 Dec 2022 16:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244949;
        bh=mdITFTjbfwPjSDJMbCZ1ox/jw4uwrTLdaTJS8sxrtvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NK9ky7SsWs4WvoTUUylK6xXUEChAbLcL3ceornjogyR2BSBcfcyEfhNSZSyMLbrz6
         mqzqMljbAw2e6QHjWZCWOv8QmxkDnHJMesnnkD8VHUKCQ4xHHuScfKk52PIjDgihcB
         WLkLDWNNV0r6nbZO2po/OHcl9ovZ0PqMPuDvTIII=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0767/1146] HSI: omap_ssi_core: fix possible memory leak in ssi_probe()
Date:   Wed, 28 Dec 2022 15:38:26 +0100
Message-Id: <20221228144350.983451262@linuxfoundation.org>
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

[ Upstream commit 1aff514e1d2bd47854dbbdf867970b9d463d4c57 ]

If ssi_add_controller() returns error, it should call hsi_put_controller()
to give up the reference that was set in hsi_alloc_controller(), so that
it can call hsi_controller_release() to free controller and ports that
allocated in hsi_alloc_controller().

Fixes: b209e047bc74 ("HSI: Introduce OMAP SSI driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hsi/controllers/omap_ssi_core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hsi/controllers/omap_ssi_core.c b/drivers/hsi/controllers/omap_ssi_core.c
index b23a576ed88a..052cf3e92dd6 100644
--- a/drivers/hsi/controllers/omap_ssi_core.c
+++ b/drivers/hsi/controllers/omap_ssi_core.c
@@ -502,8 +502,10 @@ static int ssi_probe(struct platform_device *pd)
 	platform_set_drvdata(pd, ssi);
 
 	err = ssi_add_controller(ssi, pd);
-	if (err < 0)
+	if (err < 0) {
+		hsi_put_controller(ssi);
 		goto out1;
+	}
 
 	pm_runtime_enable(&pd->dev);
 
-- 
2.35.1



