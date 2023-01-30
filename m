Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47788680F7B
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 14:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233646AbjA3NyP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 08:54:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236403AbjA3NyM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 08:54:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 628DC39B86
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 05:54:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8A68B81145
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 13:54:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA51C4339B;
        Mon, 30 Jan 2023 13:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675086842;
        bh=IeMU8JGyTMzZtKLeO4BXdxx9J/jgz73Fm+lDrDPI1t0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vh0gwnUR3DiWbCxTqe9PKg99YGvZoRfXGGYAPgBG9892SbLmLfWIVZOMAbIho+qmF
         5U6j3xvEarkAUS8basee1Kmoz7F4UfpT6kT+jdecHhnP0A3b4kHmlm3wordh40ZRzJ
         Q9A0QnPJok1KxUP04NFYJp4u5U5sqDiKrFiUqhfI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        Fabio Estevam <festevam@gmail.com>,
        Martin Kaiser <martin@kaiser.cx>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 016/313] ARM: imx: add missing of_node_put()
Date:   Mon, 30 Jan 2023 14:47:31 +0100
Message-Id: <20230130134337.422324419@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index 3e63445cde06..cc86977d0a34 100644
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



