Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC61020651A
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389060AbgFWUNM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:13:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:55186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389055AbgFWUNJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:13:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EEB2206C3;
        Tue, 23 Jun 2020 20:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943189;
        bh=26gGaC9u131zB3s3LfDROaWRuKIY6rXvRpVX975VO7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=liOJZd7mHljqx5QXnDVNx+S2QaTOcCjCHXf4dU5SuXAOQBPsqVKrU1Kf4HHmwp3U4
         ZJUVlQRGy5IGnkVZ7h7JG5eVgrhlUXUDo3z86O9A7PmxbNlgiBQdbbG/GUSYUlhgtF
         mZkQLpp8bQlggzQQ90CM8x2Tu7rCK2Vl8ljP11G0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 294/477] input: i8042 - Remove special PowerPC handling
Date:   Tue, 23 Jun 2020 21:54:51 +0200
Message-Id: <20200623195421.454847875@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit e4f4ffa8a98c24a4ab482669b1e2b4cfce3f52f4 ]

This causes a build error with CONFIG_WALNUT because kb_cs and kb_data
were removed in commit 917f0af9e5a9 ("powerpc: Remove arch/ppc and
include/asm-ppc").

ld.lld: error: undefined symbol: kb_cs
> referenced by i8042-ppcio.h:28 (drivers/input/serio/i8042-ppcio.h:28)
> input/serio/i8042.o:(__i8042_command) in archive drivers/built-in.a
> referenced by i8042-ppcio.h:28 (drivers/input/serio/i8042-ppcio.h:28)
> input/serio/i8042.o:(__i8042_command) in archive drivers/built-in.a
> referenced by i8042-ppcio.h:28 (drivers/input/serio/i8042-ppcio.h:28)
> input/serio/i8042.o:(__i8042_command) in archive drivers/built-in.a

ld.lld: error: undefined symbol: kb_data
> referenced by i8042.c:309 (drivers/input/serio/i8042.c:309)
> input/serio/i8042.o:(__i8042_command) in archive drivers/built-in.a
> referenced by i8042-ppcio.h:33 (drivers/input/serio/i8042-ppcio.h:33)
> input/serio/i8042.o:(__i8042_command) in archive drivers/built-in.a
> referenced by i8042.c:319 (drivers/input/serio/i8042.c:319)
> input/serio/i8042.o:(__i8042_command) in archive drivers/built-in.a
> referenced 15 more times

Presumably since nobody has noticed this for the last 12 years, there is
not anyone actually trying to use this driver so we can just remove this
special walnut code and use the generic header so it builds for all
configurations.

Fixes: 917f0af9e5a9 ("powerpc: Remove arch/ppc and include/asm-ppc")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Link: https://lore.kernel.org/r/20200518181043.3363953-1-natechancellor@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/serio/i8042-ppcio.h | 57 -------------------------------
 drivers/input/serio/i8042.h       |  2 --
 2 files changed, 59 deletions(-)
 delete mode 100644 drivers/input/serio/i8042-ppcio.h

diff --git a/drivers/input/serio/i8042-ppcio.h b/drivers/input/serio/i8042-ppcio.h
deleted file mode 100644
index 391f94d9e47da..0000000000000
--- a/drivers/input/serio/i8042-ppcio.h
+++ /dev/null
@@ -1,57 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-#ifndef _I8042_PPCIO_H
-#define _I8042_PPCIO_H
-
-
-#if defined(CONFIG_WALNUT)
-
-#define I8042_KBD_IRQ 25
-#define I8042_AUX_IRQ 26
-
-#define I8042_KBD_PHYS_DESC "walnutps2/serio0"
-#define I8042_AUX_PHYS_DESC "walnutps2/serio1"
-#define I8042_MUX_PHYS_DESC "walnutps2/serio%d"
-
-extern void *kb_cs;
-extern void *kb_data;
-
-#define I8042_COMMAND_REG (*(int *)kb_cs)
-#define I8042_DATA_REG (*(int *)kb_data)
-
-static inline int i8042_read_data(void)
-{
-	return readb(kb_data);
-}
-
-static inline int i8042_read_status(void)
-{
-	return readb(kb_cs);
-}
-
-static inline void i8042_write_data(int val)
-{
-	writeb(val, kb_data);
-}
-
-static inline void i8042_write_command(int val)
-{
-	writeb(val, kb_cs);
-}
-
-static inline int i8042_platform_init(void)
-{
-	i8042_reset = I8042_RESET_ALWAYS;
-	return 0;
-}
-
-static inline void i8042_platform_exit(void)
-{
-}
-
-#else
-
-#include "i8042-io.h"
-
-#endif
-
-#endif /* _I8042_PPCIO_H */
diff --git a/drivers/input/serio/i8042.h b/drivers/input/serio/i8042.h
index 38dc27ad3c18f..eb376700dfffd 100644
--- a/drivers/input/serio/i8042.h
+++ b/drivers/input/serio/i8042.h
@@ -17,8 +17,6 @@
 #include "i8042-ip22io.h"
 #elif defined(CONFIG_SNI_RM)
 #include "i8042-snirm.h"
-#elif defined(CONFIG_PPC)
-#include "i8042-ppcio.h"
 #elif defined(CONFIG_SPARC)
 #include "i8042-sparcio.h"
 #elif defined(CONFIG_X86) || defined(CONFIG_IA64)
-- 
2.25.1



