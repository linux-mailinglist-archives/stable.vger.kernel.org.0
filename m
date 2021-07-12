Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30A133C454E
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234665AbhGLGZB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:25:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:38866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234874AbhGLGYO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:24:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 532A661179;
        Mon, 12 Jul 2021 06:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070831;
        bh=KGv6zYHQWRjhWrUuCL2HdlRhrCRqjGtaSEImkPAzrWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=acMc7o6wiWibh1Eb8qGtvdDCcIZPhDR/PnfDD4mgf9Ll4qZFoqV+7c0z3PD9AwXtC
         csiGQKb4jhHM6zg/ZG2Gu/GkPPrWgb6QIutS9LxowX+7KWnMZCbW7hyz+Huvck8N3a
         zULREqO03GSntHwXExzYtwWY44s+D9Bsh5euardQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 157/348] m68k: atari: Fix ATARI_KBD_CORE kconfig unmet dependency warning
Date:   Mon, 12 Jul 2021 08:09:01 +0200
Message-Id: <20210712060721.862315384@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit c1367ee016e3550745315fb9a2dd1e4ce02cdcf6 ]

Since the code for ATARI_KBD_CORE does not use drivers/input/keyboard/
code, just move ATARI_KBD_CORE to arch/m68k/Kconfig.machine to remove
the dependency on INPUT_KEYBOARD.

Removes this kconfig warning:

    WARNING: unmet direct dependencies detected for ATARI_KBD_CORE
      Depends on [n]: !UML && INPUT [=y] && INPUT_KEYBOARD [=n]
      Selected by [y]:
      - MOUSE_ATARI [=y] && !UML && INPUT [=y] && INPUT_MOUSE [=y] && ATARI [=y]

Fixes: c04cb856e20a ("m68k: Atari keyboard and mouse support.")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Suggested-by: Michael Schmitz <schmitzmic@gmail.com>
Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Link: https://lore.kernel.org/r/20210527001251.8529-1-rdunlap@infradead.org
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/Kconfig.machine      | 3 +++
 drivers/input/keyboard/Kconfig | 3 ---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/m68k/Kconfig.machine b/arch/m68k/Kconfig.machine
index c01e103492fd..1bbe0dd0c4fe 100644
--- a/arch/m68k/Kconfig.machine
+++ b/arch/m68k/Kconfig.machine
@@ -23,6 +23,9 @@ config ATARI
 	  this kernel on an Atari, say Y here and browse the material
 	  available in <file:Documentation/m68k>; otherwise say N.
 
+config ATARI_KBD_CORE
+	bool
+
 config MAC
 	bool "Macintosh support"
 	depends on MMU
diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index 8911bc2ec42a..ae0bdc439105 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -68,9 +68,6 @@ config KEYBOARD_AMIGA
 	  To compile this driver as a module, choose M here: the
 	  module will be called amikbd.
 
-config ATARI_KBD_CORE
-	bool
-
 config KEYBOARD_APPLESPI
 	tristate "Apple SPI keyboard and trackpad"
 	depends on ACPI && EFI
-- 
2.30.2



