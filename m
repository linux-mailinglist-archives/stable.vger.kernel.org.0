Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 477822900D9
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 11:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405565AbgJPJJf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 05:09:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:37980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395007AbgJPJJR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Oct 2020 05:09:17 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B96AA21556;
        Fri, 16 Oct 2020 09:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602839356;
        bh=+e/uitgR3t1bG0EJ3BLVPobcveEUtzgsLVdE9SoF+5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EPA0U57ZMENhdRorNhgHX5EpSiy5HHkIHj3rFQqo9YW2TGz+aoWSLWkaq/3OYIpMU
         LIeDo+I1mZJ1oqUqosOfaOg9P6hL3w4942dTJQBXJwIVH7vw5Fla9SjBJi+nA6Tnit
         7IvFZ/gMe05diCI18baV5FsnzXiReRaSOG6gZ+MQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 04/21] ARM: 8867/1: vdso: pass --be8 to linker if necessary
Date:   Fri, 16 Oct 2020 11:07:23 +0200
Message-Id: <20201016090437.519246900@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016090437.301376476@linuxfoundation.org>
References: <20201016090437.301376476@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

[ Upstream commit c5d0e49e8d8f1a23034fdf8e935afc0c8f7ae27d ]

The commit fe00e50b2db8 ("ARM: 8858/1: vdso: use $(LD) instead of $(CC)
to link VDSO") removed the passing of CFLAGS, since ld doesn't take
those directly. However, prior, big-endian ARM was relying on gcc to
translate its -mbe8 option into ld's --be8 option. Lacking this, ld
generated be32 code, making the VDSO generate SIGILL when called by
userspace.

This commit passes --be8 if CONFIG_CPU_ENDIAN_BE8 is enabled.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/vdso/Makefile | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/vdso/Makefile b/arch/arm/vdso/Makefile
index fadf554d93917..1f5ec9741e6d4 100644
--- a/arch/arm/vdso/Makefile
+++ b/arch/arm/vdso/Makefile
@@ -10,9 +10,10 @@ obj-vdso := $(addprefix $(obj)/, $(obj-vdso))
 ccflags-y := -fPIC -fno-common -fno-builtin -fno-stack-protector
 ccflags-y += -DDISABLE_BRANCH_PROFILING
 
-ldflags-y = -Bsymbolic --no-undefined -soname=linux-vdso.so.1 \
+ldflags-$(CONFIG_CPU_ENDIAN_BE8) := --be8
+ldflags-y := -Bsymbolic --no-undefined -soname=linux-vdso.so.1 \
 	    -z max-page-size=4096 -z common-page-size=4096 \
-	    -nostdlib -shared \
+	    -nostdlib -shared $(ldflags-y) \
 	    $(call ld-option, --hash-style=sysv) \
 	    $(call ld-option, --build-id) \
 	    -T
-- 
2.25.1



