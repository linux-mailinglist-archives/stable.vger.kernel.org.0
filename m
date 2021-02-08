Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC4553137EB
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:33:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234016AbhBHPdF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:33:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:36948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232797AbhBHP3W (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:29:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F67864E7B;
        Mon,  8 Feb 2021 15:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797411;
        bh=bKf7T6mmPxUfY1fC+UjC4N3ca6t+7g/1b14q9UtgwOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OgW5VtYhrHW8o/9A/wWN6SraJEvU7RsLANtf6LuPwaqxUuKQDHgndrAF+pXMgU4X+
         enqSe0RoWVzEwE7QcYIhMFwgPlN1TMwIUqaMAezuRjlmNkAicGT2xV+w7wiZlHEzTS
         kiPyaoZdGKZun/bMXGAV9u/5x3gXxl6SdUvlvNH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rolf Eike Beer <eb@emlix.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.10 068/120] scripts: use pkg-config to locate libcrypto
Date:   Mon,  8 Feb 2021 16:00:55 +0100
Message-Id: <20210208145821.125748275@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rolf Eike Beer <eb@emlix.com>

commit 2cea4a7a1885bd0c765089afc14f7ff0eb77864e upstream.

Otherwise build fails if the headers are not in the default location. While at
it also ask pkg-config for the libs, with fallback to the existing value.

Signed-off-by: Rolf Eike Beer <eb@emlix.com>
Cc: stable@vger.kernel.org # 5.6.x
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/Makefile | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/scripts/Makefile b/scripts/Makefile
index b5418ec587fb..9de3c03b94aa 100644
--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -3,6 +3,9 @@
 # scripts contains sources for various helper programs used throughout
 # the kernel for the build process.
 
+CRYPTO_LIBS = $(shell pkg-config --libs libcrypto 2> /dev/null || echo -lcrypto)
+CRYPTO_CFLAGS = $(shell pkg-config --cflags libcrypto 2> /dev/null)
+
 hostprogs-always-$(CONFIG_BUILD_BIN2C)			+= bin2c
 hostprogs-always-$(CONFIG_KALLSYMS)			+= kallsyms
 hostprogs-always-$(BUILD_C_RECORDMCOUNT)		+= recordmcount
@@ -14,8 +17,9 @@ hostprogs-always-$(CONFIG_SYSTEM_EXTRA_CERTIFICATE)	+= insert-sys-cert
 
 HOSTCFLAGS_sorttable.o = -I$(srctree)/tools/include
 HOSTCFLAGS_asn1_compiler.o = -I$(srctree)/include
-HOSTLDLIBS_sign-file = -lcrypto
-HOSTLDLIBS_extract-cert = -lcrypto
+HOSTLDLIBS_sign-file = $(CRYPTO_LIBS)
+HOSTCFLAGS_extract-cert.o = $(CRYPTO_CFLAGS)
+HOSTLDLIBS_extract-cert = $(CRYPTO_LIBS)
 
 ifdef CONFIG_UNWINDER_ORC
 ifeq ($(ARCH),x86_64)
-- 
2.30.0



