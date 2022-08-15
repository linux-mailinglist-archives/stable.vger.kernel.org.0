Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCB37593EF4
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345628AbiHOUwB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344794AbiHOUuH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:50:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF612B941D;
        Mon, 15 Aug 2022 12:09:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D451860ACE;
        Mon, 15 Aug 2022 19:09:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE3B5C433D7;
        Mon, 15 Aug 2022 19:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590567;
        bh=/uKj4bZT2Rz2nPV+izWAzKndVaMfU7WxZb3+M0tctJo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lhnZMuiURcUKhKWlhwRNlZMK/lkJQShhA9IC957u7Wb4pZaSD4T6s+pB3K8rDOocm
         oWreS3Mt5YgBCNty8CXJpgW/1dI6D+LuU8cjxJPA0XeH5gP0xiL/V9WzY2KFQ77hq1
         NFeKjuR2aXxdqO3CCoWip/bdXWHg35mLustLui3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0270/1095] spi: tegra20-slink: fix UAF in tegra_slink_remove()
Date:   Mon, 15 Aug 2022 19:54:29 +0200
Message-Id: <20220815180440.927393378@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 7e9984d183bb1e99e766c5c2b950ff21f7f7b6c0 ]

After calling spi_unregister_master(), the refcount of master will
be decrease to 0, and it will be freed in spi_controller_release(),
the device data also will be freed, so it will lead a UAF when using
'tspi'. To fix this, get the master before unregister and put it when
finish using it.

Fixes: 26c863418221 ("spi: tegra20-slink: Don't use resource-managed spi_register helper")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20220713094024.1508869-1-yangyingliang@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra20-slink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-tegra20-slink.c b/drivers/spi/spi-tegra20-slink.c
index 80c3787deea9..c91c226be69e 100644
--- a/drivers/spi/spi-tegra20-slink.c
+++ b/drivers/spi/spi-tegra20-slink.c
@@ -1137,7 +1137,7 @@ static int tegra_slink_probe(struct platform_device *pdev)
 
 static int tegra_slink_remove(struct platform_device *pdev)
 {
-	struct spi_master *master = platform_get_drvdata(pdev);
+	struct spi_master *master = spi_master_get(platform_get_drvdata(pdev));
 	struct tegra_slink_data	*tspi = spi_master_get_devdata(master);
 
 	spi_unregister_master(master);
@@ -1152,6 +1152,7 @@ static int tegra_slink_remove(struct platform_device *pdev)
 	if (tspi->rx_dma_chan)
 		tegra_slink_deinit_dma_param(tspi, true);
 
+	spi_master_put(master);
 	return 0;
 }
 
-- 
2.35.1



