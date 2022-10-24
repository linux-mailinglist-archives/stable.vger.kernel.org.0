Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8796360BACF
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 22:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234741AbiJXUlb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 16:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234749AbiJXUkg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 16:40:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68D0E633C;
        Mon, 24 Oct 2022 11:50:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B38FB819AE;
        Mon, 24 Oct 2022 12:44:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C110EC433C1;
        Mon, 24 Oct 2022 12:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615455;
        bh=MTNv8JnE6MiRzxARwECZGU+i0VFrs3+sQWe2gpwpDN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bRKiszhBnZWFOkw6cYZ3pzoFlFnOTXSDDj/q/5u5DBvuS6lL1E/hUOziPn3OkN6MO
         BTuQp0r4l5qaGxTJuJN6YRCX0gCbK+wMHB3bYutoJl2e/W7yio3H00LXoDPoBsCCN4
         2Ui7PeDSNQ7MnJc+vGloPoNBVZKCH837iSkLnMdg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Necip Fazil Yildiran <fazilyildiran@gmail.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 257/530] soc/tegra: fuse: Drop Kconfig dependency on TEGRA20_APB_DMA
Date:   Mon, 24 Oct 2022 13:30:01 +0200
Message-Id: <20221024113056.698007590@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit 2254182807fc09ba9dec9a42ef239e373796f1b2 ]

The DMA subsystem could be entirely disabled in Kconfig and then the
TEGRA20_APB_DMA option isn't available too. Hence kernel configuration
fails if DMADEVICES Kconfig option is disabled due to the unsatisfiable
dependency.

The FUSE driver isn't a critical driver and currently it only provides
NVMEM interface to userspace which isn't known to be widely used, and
thus, it's fine if FUSE driver fails to load.

Let's remove the erroneous Kconfig dependency and let the FUSE driver to
fail the probing if DMA is unavailable.

Fixes: 19d41e5e9c68 ("soc/tegra: fuse: Add APB DMA dependency for Tegra20")
Reported-by: Necip Fazil Yildiran <fazilyildiran@gmail.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=209301
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/tegra/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/soc/tegra/Kconfig b/drivers/soc/tegra/Kconfig
index 8b53ed1cc67e..1224e1c8c2c9 100644
--- a/drivers/soc/tegra/Kconfig
+++ b/drivers/soc/tegra/Kconfig
@@ -136,7 +136,6 @@ config SOC_TEGRA_FUSE
 	def_bool y
 	depends on ARCH_TEGRA
 	select SOC_BUS
-	select TEGRA20_APB_DMA if ARCH_TEGRA_2x_SOC
 
 config SOC_TEGRA_FLOWCTRL
 	bool
-- 
2.35.1



