Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9A060A904
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233270AbiJXNOw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:14:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235776AbiJXNM5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:12:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80AA82E9CF;
        Mon, 24 Oct 2022 05:24:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD1B0612FD;
        Mon, 24 Oct 2022 12:23:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF5F3C433D6;
        Mon, 24 Oct 2022 12:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614229;
        bh=HQosdGr41cp0NFgCCjWe9LaRMBUwVhJBGCi8A5OeLws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xHCTHEeYCYSdQWKdsp/ZyRs00pGwC69xOxe237sOvVyMAXhKyuohLLRGcvk+uJo1d
         r8VHcTIOd24vrlQ9kOe77oBBtEUCL3f+i3xSU9awekAz1zRPMyZbllUtb6rPXD4Ozi
         7gRv0oubuSvk5Dp6oz5QgGTdmLK9UhLXeukMSbjs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Necip Fazil Yildiran <fazilyildiran@gmail.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 180/390] soc/tegra: fuse: Drop Kconfig dependency on TEGRA20_APB_DMA
Date:   Mon, 24 Oct 2022 13:29:37 +0200
Message-Id: <20221024113030.413695152@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
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
index 976dee036470..676807c5a215 100644
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



