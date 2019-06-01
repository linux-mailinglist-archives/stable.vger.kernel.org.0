Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1CE31F44
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728029AbfFANnI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:43:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:45592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727833AbfFANSe (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:18:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C026E272AA;
        Sat,  1 Jun 2019 13:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395113;
        bh=cj/IQ77HXq6PLhUf2CGtPUKkuQrgVntohc1tmQxxOjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VJqS7q3mj+MAm0nfGhNrKyewbwxESjIs1ikN+G008LpxUy/pS6GO5OoNCJKrzMWcY
         BsvM1xxTTZ2K45fHGw5b/7sWhJRTvce2Wh+XOr8h678Lvt61xuPMR4XzKDtpsUDtJd
         buQ6XW0lgAguR+lJVbNhmtajR+iifjzlxR8e4sw8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Borislav Petkov <bp@suse.de>,
        Johannes Thumshirn <jth@kernel.org>,
        James Morse <james.morse@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-edac <linux-edac@vger.kernel.org>, linuxppc-dev@ozlabs.org,
        morbidrsa@gmail.com, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.1 038/186] EDAC/mpc85xx: Prevent building as a module
Date:   Sat,  1 Jun 2019 09:14:14 -0400
Message-Id: <20190601131653.24205-38-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601131653.24205-1-sashal@kernel.org>
References: <20190601131653.24205-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 2b8358a951b1e2a534a54924cd8245e58a1c5fb8 ]

The mpc85xx EDAC driver can be configured as a module but then fails to
build because it uses two unexported symbols:

  ERROR: ".pci_find_hose_for_OF_device" [drivers/edac/mpc85xx_edac_mod.ko] undefined!
  ERROR: ".early_find_capability" [drivers/edac/mpc85xx_edac_mod.ko] undefined!

We don't want to export those symbols just for this driver, so make the
driver only configurable as a built-in.

This seems to have been broken since at least

  c92132f59806 ("edac/85xx: Add PCIe error interrupt edac support")

(Nov 2013).

 [ bp: make it depend on EDAC=y so that the EDAC core doesn't get built
   as a module. ]

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Johannes Thumshirn <jth@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-edac <linux-edac@vger.kernel.org>
Cc: linuxppc-dev@ozlabs.org
Cc: morbidrsa@gmail.com
Link: https://lkml.kernel.org/r/20190502141941.12927-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index 47eb4d13ed5f8..5e2e0348d460f 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -263,8 +263,8 @@ config EDAC_PND2
 	  micro-server but may appear on others in the future.
 
 config EDAC_MPC85XX
-	tristate "Freescale MPC83xx / MPC85xx"
-	depends on FSL_SOC
+	bool "Freescale MPC83xx / MPC85xx"
+	depends on FSL_SOC && EDAC=y
 	help
 	  Support for error detection and correction on the Freescale
 	  MPC8349, MPC8560, MPC8540, MPC8548, T4240
-- 
2.20.1

