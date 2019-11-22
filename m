Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 952DC106AB6
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbfKVKhW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:37:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:38798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727961AbfKVKhW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:37:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A69A20656;
        Fri, 22 Nov 2019 10:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419041;
        bh=oSAhrCRzD2BWjJZwDHSujEj55xZunQv1Nx/ZyUztI+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YTfmiQzKvUxSpRdt4X5oSW/vVRpuOuAOMtLq9txTVt0zAi5MoYtiUENAj5BreZU5e
         dt6no2lnw2ntyFiU00CdYiz68GbHX1gr7ZsU/kJJ/BVbIHbiTQtdmXwoEte41FRYUP
         uvN3VeLr2uKqSsX2ZYi1zxTTlh+XKg8SLzkaBTko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Lubomir Rintel <lkundrak@v3.sk>, x86@kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 138/159] x86/olpc: Fix build error with CONFIG_MFD_CS5535=m
Date:   Fri, 22 Nov 2019 11:28:49 +0100
Message-Id: <20191122100836.416013239@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100704.194776704@linuxfoundation.org>
References: <20191122100704.194776704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

[ Upstream commit fa112cf1e8bc693d5a666b1c479a2859c8b6e0f1 ]

When building a 32-bit config which has the above MFD item as module
but OLPC_XO1_PM is enabled =y - which is bool, btw - the kernel fails
building with:

  ld: arch/x86/platform/olpc/olpc-xo1-pm.o: in function `xo1_pm_remove':
  /home/boris/kernel/linux/arch/x86/platform/olpc/olpc-xo1-pm.c:159: undefined reference to `mfd_cell_disable'
  ld: arch/x86/platform/olpc/olpc-xo1-pm.o: in function `xo1_pm_probe':
  /home/boris/kernel/linux/arch/x86/platform/olpc/olpc-xo1-pm.c:133: undefined reference to `mfd_cell_enable'
  make: *** [Makefile:1030: vmlinux] Error 1

Force MFD_CS5535 to y if OLPC_XO1_PM is enabled.

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Lubomir Rintel <lkundrak@v3.sk>
Cc: x86@kernel.org
Link: http://lkml.kernel.org/r/20181005131750.GA5366@zn.tnic
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/Kconfig | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 53b429811aef0..1bee1c6a9891b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2526,8 +2526,7 @@ config OLPC
 
 config OLPC_XO1_PM
 	bool "OLPC XO-1 Power Management"
-	depends on OLPC && MFD_CS5535 && PM_SLEEP
-	select MFD_CORE
+	depends on OLPC && MFD_CS5535=y && PM_SLEEP
 	---help---
 	  Add support for poweroff and suspend of the OLPC XO-1 laptop.
 
-- 
2.20.1



