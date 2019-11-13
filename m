Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE8A4FA3C5
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730471AbfKMCMW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:12:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:52096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730006AbfKMB6X (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:58:23 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 112B82245A;
        Wed, 13 Nov 2019 01:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610302;
        bh=PsgG2G08UykoSKpvOhRLvUJtYY5s7r6XwXM22km+Nwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cd3Y/8+wCnzE3ePWjlgAbdeHQQL98aHymtmUn7KlFOLKMwxEBxCiZiFtBzQg1iaiT
         FiXWFhhDXaHyHv0H8J9Ao4jWE7m4/cFVdQBScCtd1q7wTGUBIyVRYVBzJj3qqmuDNe
         /GP4MKhGnMGmDVdieiH5gzDg+tU7izk319V88Pdg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Borislav Petkov <bp@suse.de>, Lubomir Rintel <lkundrak@v3.sk>,
        x86@kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 073/115] x86/olpc: Fix build error with CONFIG_MFD_CS5535=m
Date:   Tue, 12 Nov 2019 20:55:40 -0500
Message-Id: <20191113015622.11592-73-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015622.11592-1-sashal@kernel.org>
References: <20191113015622.11592-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 8fec1585ac7ab..ce147c0e76f0d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2671,8 +2671,7 @@ config OLPC
 
 config OLPC_XO1_PM
 	bool "OLPC XO-1 Power Management"
-	depends on OLPC && MFD_CS5535 && PM_SLEEP
-	select MFD_CORE
+	depends on OLPC && MFD_CS5535=y && PM_SLEEP
 	---help---
 	  Add support for poweroff and suspend of the OLPC XO-1 laptop.
 
-- 
2.20.1

