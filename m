Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 196FA657823
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:48:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233000AbiL1OsL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:48:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233077AbiL1Orn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:47:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88FE3120B9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:47:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2778461541
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:47:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35898C433EF;
        Wed, 28 Dec 2022 14:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672238840;
        bh=sVdd6W75Mu618ftxMgo0QmxEBDXvoh+LI/0etn9UcuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lgIJH7cqMP1ifZw8T1n5W289RtDxkD4KGLVvs5jYV2niu+5gzCmUIpKiqBofOh4xI
         zpz5K/QAAZf+4wZYUGq7gs6HN6XeyjFF2FAep3uvr40kpsizLOWaBPteFr9vwBwfTT
         UWxhKNC+PAiOTInMmBaYTCO2UK88gzz+swvrfD+Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhang Qilong <zhangqilong3@huawei.com>,
        Nishanth Menon <nm@ti.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 030/731] soc: ti: smartreflex: Fix PM disable depth imbalance in omap_sr_probe
Date:   Wed, 28 Dec 2022 15:32:17 +0100
Message-Id: <20221228144257.424490810@linuxfoundation.org>
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

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 69460e68eb662064ab4188d4e129ff31c1f23ed9 ]

The pm_runtime_enable will increase power disable depth. Thus
a pairing decrement is needed on the error handling path to
keep it balanced according to context.

Fixes: 984aa6dbf4ca ("OMAP3: PM: Adding smartreflex driver support.")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Link: https://lore.kernel.org/r/20221108080322.52268-3-zhangqilong3@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/ti/smartreflex.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/ti/smartreflex.c b/drivers/soc/ti/smartreflex.c
index b5b2fa538d5c..4d15587324d4 100644
--- a/drivers/soc/ti/smartreflex.c
+++ b/drivers/soc/ti/smartreflex.c
@@ -931,6 +931,7 @@ static int omap_sr_probe(struct platform_device *pdev)
 err_debugfs:
 	debugfs_remove_recursive(sr_info->dbg_dir);
 err_list_del:
+	pm_runtime_disable(&pdev->dev);
 	list_del(&sr_info->node);
 	clk_unprepare(sr_info->fck);
 
-- 
2.35.1



