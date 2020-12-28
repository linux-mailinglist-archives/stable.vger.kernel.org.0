Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D61082E6963
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:49:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbgL1Mx0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 07:53:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:49800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728092AbgL1MxZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 07:53:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9D5921D94;
        Mon, 28 Dec 2020 12:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609159990;
        bh=pTvif6N61dk2LqyTuqvqgcraYYX9lXCcL5IFWOtqYGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OvamTBkoDDK0TMy9wFgsJYp1g6N2tC54n81dsGP5vuoSjAXevw+O5oFUXNs8opmqn
         fO/05rsuzQWmUDiQeUpqAnJ6t6iua/8MvfXVvtyw2Rf65gvcb0M1plbx9euQ1WBna6
         kYD04n2pkbTWeSpmJLN8SLJkZRfQ3Gc6XMERto0M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Necip Fazil Yildiran <fazilyildiran@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 045/132] MIPS: BCM47XX: fix kconfig dependency bug for BCM47XX_BCMA
Date:   Mon, 28 Dec 2020 13:48:49 +0100
Message-Id: <20201228124848.604885251@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124846.409999325@linuxfoundation.org>
References: <20201228124846.409999325@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Necip Fazil Yildiran <fazilyildiran@gmail.com>

[ Upstream commit 3a5fe2fb9635c43359c9729352f45044f3c8df6b ]

When BCM47XX_BCMA is enabled and BCMA_DRIVER_PCI is disabled, it results
in the following Kbuild warning:

WARNING: unmet direct dependencies detected for BCMA_DRIVER_PCI_HOSTMODE
  Depends on [n]: MIPS [=y] && BCMA_DRIVER_PCI [=n] && PCI_DRIVERS_LEGACY [=y] && BCMA [=y]=y
  Selected by [y]:
  - BCM47XX_BCMA [=y] && BCM47XX [=y] && PCI [=y]

The reason is that BCM47XX_BCMA selects BCMA_DRIVER_PCI_HOSTMODE without
depending on or selecting BCMA_DRIVER_PCI while BCMA_DRIVER_PCI_HOSTMODE
depends on BCMA_DRIVER_PCI. This can also fail building the kernel.

Honor the kconfig dependency to remove unmet direct dependency warnings
and avoid any potential build failures.

Fixes: c1d1c5d4213e ("bcm47xx: add support for bcma bus")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=209879
Signed-off-by: Necip Fazil Yildiran <fazilyildiran@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/bcm47xx/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/bcm47xx/Kconfig b/arch/mips/bcm47xx/Kconfig
index e970fd9cf7693..7ca7384fd5c9d 100644
--- a/arch/mips/bcm47xx/Kconfig
+++ b/arch/mips/bcm47xx/Kconfig
@@ -26,6 +26,7 @@ config BCM47XX_BCMA
 	select BCMA
 	select BCMA_HOST_SOC
 	select BCMA_DRIVER_MIPS
+	select BCMA_DRIVER_PCI if PCI
 	select BCMA_DRIVER_PCI_HOSTMODE if PCI
 	select BCMA_DRIVER_GPIO
 	default y
-- 
2.27.0



