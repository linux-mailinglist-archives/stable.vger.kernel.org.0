Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8C286896A6
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233643AbjBCK0V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:26:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233571AbjBCK0D (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:26:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 122CA9F9C9
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:25:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84B5161E6D
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:25:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5255AC433EF;
        Fri,  3 Feb 2023 10:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419946;
        bh=ZvNd/KxaOzgRoooH6eLzGvmFmVsPkO5m0CcR66gwZnw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RTQM6prC7HpXsWh7cUvRu6A20oXJw9A3XAFbLdsyYRYTqY5DFyPM6u4xJps3+mMD7
         //YcXVgVVnxoroL6Ma8j9IL7femzqoifl4lzSHVgdnae6d35Kn+2WiXT5ZWTqvhIzH
         tFpnhynggefJ13JE9yHyv7OQxaSshA2Wi1NBJ5aY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        Fabio Estevam <festevam@gmail.com>,
        Martin Kaiser <martin@kaiser.cx>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 009/134] ARM: imx: add missing of_node_put()
Date:   Fri,  3 Feb 2023 11:11:54 +0100
Message-Id: <20230203101024.265386862@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
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

From: Dario Binacchi <dario.binacchi@amarulasolutions.com>

[ Upstream commit 87b30c4b0efb6a194a7b8eac2568a3da520d905f ]

Calling of_find_compatible_node() returns a node pointer with refcount
incremented. Use of_node_put() on it when done.
The patch fixes the same problem on different i.MX platforms.

Fixes: 8b88f7ef31dde ("ARM: mx25: Retrieve IIM base from dt")
Fixes: 94b2bec1b0e05 ("ARM: imx27: Retrieve the SYSCTRL base address from devicetree")
Fixes: 3172225d45bd9 ("ARM: imx31: Retrieve the IIM base address from devicetree")
Fixes: f68ea682d1da7 ("ARM: imx35: Retrieve the IIM base address from devicetree")
Fixes: ee18a7154ee08 ("ARM: imx5: retrieve iim base from device tree")
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Reviewed-by: Martin Kaiser <martin@kaiser.cx>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-imx/cpu-imx25.c | 1 +
 arch/arm/mach-imx/cpu-imx27.c | 1 +
 arch/arm/mach-imx/cpu-imx31.c | 1 +
 arch/arm/mach-imx/cpu-imx35.c | 1 +
 arch/arm/mach-imx/cpu-imx5.c  | 1 +
 5 files changed, 5 insertions(+)

diff --git a/arch/arm/mach-imx/cpu-imx25.c b/arch/arm/mach-imx/cpu-imx25.c
index b2e1963f473d..2ee2d2813d57 100644
--- a/arch/arm/mach-imx/cpu-imx25.c
+++ b/arch/arm/mach-imx/cpu-imx25.c
@@ -23,6 +23,7 @@ static int mx25_read_cpu_rev(void)
 
 	np = of_find_compatible_node(NULL, NULL, "fsl,imx25-iim");
 	iim_base = of_iomap(np, 0);
+	of_node_put(np);
 	BUG_ON(!iim_base);
 	rev = readl(iim_base + MXC_IIMSREV);
 	iounmap(iim_base);
diff --git a/arch/arm/mach-imx/cpu-imx27.c b/arch/arm/mach-imx/cpu-imx27.c
index bf70e13bbe9e..1d2893908368 100644
--- a/arch/arm/mach-imx/cpu-imx27.c
+++ b/arch/arm/mach-imx/cpu-imx27.c
@@ -28,6 +28,7 @@ static int mx27_read_cpu_rev(void)
 
 	np = of_find_compatible_node(NULL, NULL, "fsl,imx27-ccm");
 	ccm_base = of_iomap(np, 0);
+	of_node_put(np);
 	BUG_ON(!ccm_base);
 	/*
 	 * now we have access to the IO registers. As we need
diff --git a/arch/arm/mach-imx/cpu-imx31.c b/arch/arm/mach-imx/cpu-imx31.c
index b9c24b851d1a..35c544924e50 100644
--- a/arch/arm/mach-imx/cpu-imx31.c
+++ b/arch/arm/mach-imx/cpu-imx31.c
@@ -39,6 +39,7 @@ static int mx31_read_cpu_rev(void)
 
 	np = of_find_compatible_node(NULL, NULL, "fsl,imx31-iim");
 	iim_base = of_iomap(np, 0);
+	of_node_put(np);
 	BUG_ON(!iim_base);
 
 	/* read SREV register from IIM module */
diff --git a/arch/arm/mach-imx/cpu-imx35.c b/arch/arm/mach-imx/cpu-imx35.c
index 80e7d8ab9f1b..1fe75b39c2d9 100644
--- a/arch/arm/mach-imx/cpu-imx35.c
+++ b/arch/arm/mach-imx/cpu-imx35.c
@@ -21,6 +21,7 @@ static int mx35_read_cpu_rev(void)
 
 	np = of_find_compatible_node(NULL, NULL, "fsl,imx35-iim");
 	iim_base = of_iomap(np, 0);
+	of_node_put(np);
 	BUG_ON(!iim_base);
 
 	rev = imx_readl(iim_base + MXC_IIMSREV);
diff --git a/arch/arm/mach-imx/cpu-imx5.c b/arch/arm/mach-imx/cpu-imx5.c
index ad56263778f9..a67c89bf155d 100644
--- a/arch/arm/mach-imx/cpu-imx5.c
+++ b/arch/arm/mach-imx/cpu-imx5.c
@@ -28,6 +28,7 @@ static u32 imx5_read_srev_reg(const char *compat)
 
 	np = of_find_compatible_node(NULL, NULL, compat);
 	iim_base = of_iomap(np, 0);
+	of_node_put(np);
 	WARN_ON(!iim_base);
 
 	srev = readl(iim_base + IIM_SREV) & 0xff;
-- 
2.39.0



