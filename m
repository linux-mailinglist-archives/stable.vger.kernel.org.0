Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A92C6218C
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732765AbfGHPRL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:17:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:40450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732759AbfGHPRL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:17:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C685F216E3;
        Mon,  8 Jul 2019 15:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599030;
        bh=Hu1t/4h+tb7R4tQLWElMKX7KsisMy0tV2rRUWB3Rnak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1IC8X8eEWLf1srTR3SgNPjw9w9OahGb8x47qAvszLk3drsn3AogLr+H25yxoFRfUN
         nC4cIzzfzo7l2TO9mwBxe3pIcFkQZuoa3tohaXxHx8tL6aoK9QQxYKX3CTwcJOQEA/
         iGP9Rzbi10mnpFT9bhrvThQEjpyqM5WJ90V0YWLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 55/73] ARC: Assume multiplier is always present
Date:   Mon,  8 Jul 2019 17:13:05 +0200
Message-Id: <20190708150524.259535132@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150513.136580595@linuxfoundation.org>
References: <20190708150513.136580595@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 0eca6fdb3193410fbe66b6f064431cc394513e82 ]

It is unlikely that designs running Linux will not have multiplier.
Further the current support is not complete as tool don't generate a
multilib w/o multiplier.

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/Kconfig        | 8 --------
 arch/arc/Makefile       | 4 ----
 arch/arc/kernel/setup.c | 2 --
 3 files changed, 14 deletions(-)

diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index e983f410135a..a5d8bef65911 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -278,14 +278,6 @@ config ARC_DCCM_BASE
 	default "0xA0000000"
 	depends on ARC_HAS_DCCM
 
-config ARC_HAS_HW_MPY
-	bool "Use Hardware Multiplier (Normal or Faster XMAC)"
-	default y
-	help
-	  Influences how gcc generates code for MPY operations.
-	  If enabled, MPYxx insns are generated, provided by Standard/XMAC
-	  Multipler. Otherwise software multipy lib is used
-
 choice
 	prompt "MMU Version"
 	default ARC_MMU_V3 if ARC_CPU_770
diff --git a/arch/arc/Makefile b/arch/arc/Makefile
index fffaff9c7b2c..8f8d53f08141 100644
--- a/arch/arc/Makefile
+++ b/arch/arc/Makefile
@@ -72,10 +72,6 @@ ldflags-$(CONFIG_CPU_BIG_ENDIAN)	+= -EB
 # --build-id w/o "-marclinux". Default arc-elf32-ld is OK
 ldflags-$(upto_gcc44)			+= -marclinux
 
-ifndef CONFIG_ARC_HAS_HW_MPY
-	cflags-y	+= -mno-mpy
-endif
-
 LIBGCC	:= $(shell $(CC) $(cflags-y) --print-libgcc-file-name)
 
 # Modules with short calls might break for calls into builtin-kernel
diff --git a/arch/arc/kernel/setup.c b/arch/arc/kernel/setup.c
index 05131805aa33..3013f3f82b95 100644
--- a/arch/arc/kernel/setup.c
+++ b/arch/arc/kernel/setup.c
@@ -232,8 +232,6 @@ static char *arc_cpu_mumbojumbo(int cpu_id, char *buf, int len)
 
 			n += scnprintf(buf + n, len - n, "mpy[opt %d] ", opt);
 		}
-		n += scnprintf(buf + n, len - n, "%s",
-			       IS_USED_CFG(CONFIG_ARC_HAS_HW_MPY));
 	}
 
 	n += scnprintf(buf + n, len - n, "%s%s%s%s%s%s%s%s\n",
-- 
2.20.1



