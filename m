Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3393E45C245
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343631AbhKXN0r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:26:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:48376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348970AbhKXNYn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:24:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A723610E9;
        Wed, 24 Nov 2021 12:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758145;
        bh=E3DFdjxnYwIRd6pWwC2vdVQ7BW6SGIlrFdxNjDJwNVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FalqUpFyEI5bsjBSLgH+YwusDW+u5WrdjxvhF9q3QiTg5czFGERlNbj+0Nr+xpaPC
         s6llh9al4eVvP5roc1UD8PhnwUd/53UDVnDVqfg86otKCdrBC73RY7bXWT27QRSOzR
         gdcWNCtgCSof/5jo1HaBHWPR/2uAMys6LtAgRO+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Matt Fleming <matt@console-pimps.org>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Rich Felker <dalias@libc.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 033/100] sh: fix kconfig unmet dependency warning for FRAME_POINTER
Date:   Wed, 24 Nov 2021 12:57:49 +0100
Message-Id: <20211124115655.945939875@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115654.849735859@linuxfoundation.org>
References: <20211124115654.849735859@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit fda1bc533094a7db68b11e7503d2c6c73993d12a ]

FRAME_POINTER depends on DEBUG_KERNEL so DWARF_UNWINDER should
depend on DEBUG_KERNEL before selecting FRAME_POINTER.

WARNING: unmet direct dependencies detected for FRAME_POINTER
  Depends on [n]: DEBUG_KERNEL [=n] && (M68K || UML || SUPERH [=y]) || ARCH_WANT_FRAME_POINTERS [=n]
  Selected by [y]:
  - DWARF_UNWINDER [=y]

Fixes: bd353861c735 ("sh: dwarf unwinder support.")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Rich Felker <dalias@libc.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sh/Kconfig.debug | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/sh/Kconfig.debug b/arch/sh/Kconfig.debug
index 010b6c33bbba2..71acd3d9b9e83 100644
--- a/arch/sh/Kconfig.debug
+++ b/arch/sh/Kconfig.debug
@@ -58,6 +58,7 @@ config DUMP_CODE
 
 config DWARF_UNWINDER
 	bool "Enable the DWARF unwinder for stacktraces"
+	depends on DEBUG_KERNEL
 	select FRAME_POINTER
 	depends on SUPERH32
 	default n
-- 
2.33.0



