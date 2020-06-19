Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0253B200F56
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392455AbgFSPQF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:16:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:46534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392451AbgFSPP7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:15:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D81242184D;
        Fri, 19 Jun 2020 15:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579759;
        bh=5hSc+i7R6HUFUXmaUtMDJxodRMsEDfKC53KLvuOO6t8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CxfLaRxL57TvSrwMfoaabiNIoGmI5qzcDxd0LBsfAJjVhcZN6HHXJdxRLhO2HZDrk
         pT9X+ubxn/673/j4btGPL4mlVDMIb2hoXzgn1lUmYYN9wqE3Akg1VGwIrQMif7rzRz
         NIQvPVoW04kPkilh6Coy+rmQBhZTjVlOMbtsWmaU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Nicolas Chauvet <kwizart@gmail.com>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH 5.4 225/261] ARM: tegra: Correct PL310 Auxiliary Control Register initialization
Date:   Fri, 19 Jun 2020 16:33:56 +0200
Message-Id: <20200619141700.643109020@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

commit 35509737c8f958944e059d501255a0bf18361ba0 upstream.

The PL310 Auxiliary Control Register shouldn't have the "Full line of
zero" optimization bit being set before L2 cache is enabled. The L2X0
driver takes care of enabling the optimization by itself.

This patch fixes a noisy error message on Tegra20 and Tegra30 telling
that cache optimization is erroneously enabled without enabling it for
the CPU:

	L2C-310: enabling full line of zeros but not enabled in Cortex-A9

Cc: <stable@vger.kernel.org>
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Tested-by: Nicolas Chauvet <kwizart@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-tegra/tegra.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/mach-tegra/tegra.c
+++ b/arch/arm/mach-tegra/tegra.c
@@ -106,8 +106,8 @@ static const char * const tegra_dt_board
 };
 
 DT_MACHINE_START(TEGRA_DT, "NVIDIA Tegra SoC (Flattened Device Tree)")
-	.l2c_aux_val	= 0x3c400001,
-	.l2c_aux_mask	= 0xc20fc3fe,
+	.l2c_aux_val	= 0x3c400000,
+	.l2c_aux_mask	= 0xc20fc3ff,
 	.smp		= smp_ops(tegra_smp_ops),
 	.map_io		= tegra_map_common_io,
 	.init_early	= tegra_init_early,


