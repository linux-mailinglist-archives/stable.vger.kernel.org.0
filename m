Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86B1445C13A
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346022AbhKXNPs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:15:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:60242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348676AbhKXNNq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:13:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED11261AA6;
        Wed, 24 Nov 2021 12:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757805;
        bh=E3DFdjxnYwIRd6pWwC2vdVQ7BW6SGIlrFdxNjDJwNVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I2e4zB+yo3eO5rOTlaeH3gnhd6gBiDvgFudUCvH1wvdM3aVxYnTi6jeIzAK7bL3F4
         oNOh3dJD9oxeLZak/EXiMyuuBSn1HjA/jwAje7LDtAWUjHYyw7yTmSZWNX5enU8yCv
         M4Jt9/x5Ggym+ZOmKeftlxzEiM/ZOAY5k9nRrCkM=
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
Subject: [PATCH 4.19 282/323] sh: fix kconfig unmet dependency warning for FRAME_POINTER
Date:   Wed, 24 Nov 2021 12:57:52 +0100
Message-Id: <20211124115728.412985371@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
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



