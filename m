Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBB57106EA3
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbfKVLKW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:10:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:55594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731272AbfKVLCM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:02:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19C1B2073F;
        Fri, 22 Nov 2019 11:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420531;
        bh=/m2tMlF68FQUk5TXO90MJJASaUNp9Hetv7PQDKvV1RA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bH9SnZUuI0QE1QikDBFB3tntkNTEv32pUaUH0TXHxjDiUfhKDzY0Ct3iyqzYJMswn
         KPOsbI33V/VzksoQG2jGKTfc6EJ2tFeKiLKyfWu1jkIAJ+knJu2EAVT6OHen8ewTYC
         2sRnNyym7G3wglFjhqhEbuTM/CLhRuUQDdy941gU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Lubomir Rintel <lkundrak@v3.sk>, x86@kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 139/220] x86/olpc: Fix build error with CONFIG_MFD_CS5535=m
Date:   Fri, 22 Nov 2019 11:28:24 +0100
Message-Id: <20191122100922.794101374@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
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
index 5726b264036ff..af35f5caadbe5 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2771,8 +2771,7 @@ config OLPC
 
 config OLPC_XO1_PM
 	bool "OLPC XO-1 Power Management"
-	depends on OLPC && MFD_CS5535 && PM_SLEEP
-	select MFD_CORE
+	depends on OLPC && MFD_CS5535=y && PM_SLEEP
 	---help---
 	  Add support for poweroff and suspend of the OLPC XO-1 laptop.
 
-- 
2.20.1



