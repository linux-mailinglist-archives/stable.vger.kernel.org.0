Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77ED7328622
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236932AbhCAREk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:04:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:59152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236153AbhCAQ6K (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:58:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46FEF64F5B;
        Mon,  1 Mar 2021 16:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616591;
        bh=FOYkBGeqyDEKd26/v0UlNBNy5fH1sisv9RVQ0kgNT1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xdrFhcRhc4GHRJEvYliHGbQoS6vFGTN/7Is6m1rajmW0JQJRctTQl1za8CzXUnoY/
         SFEb//nY7VAmu7wCg5QzlRGZlpakbyGGBkQnkuK6QFbZizzJoTmK4WqbNTbnqv0+s9
         Qtg6CnoXo19Lov/Ac3kLBEPTeRs/8V9Nfnl7CSQw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rolf Eike Beer <eb@emlix.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 4.19 006/247] scripts: use pkg-config to locate libcrypto
Date:   Mon,  1 Mar 2021 17:10:26 +0100
Message-Id: <20210301161032.008526301@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
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
 scripts/Makefile |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -10,6 +10,9 @@
 
 HOST_EXTRACFLAGS += -I$(srctree)/tools/include
 
+CRYPTO_LIBS = $(shell pkg-config --libs libcrypto 2> /dev/null || echo -lcrypto)
+CRYPTO_CFLAGS = $(shell pkg-config --cflags libcrypto 2> /dev/null)
+
 hostprogs-$(CONFIG_BUILD_BIN2C)  += bin2c
 hostprogs-$(CONFIG_KALLSYMS)     += kallsyms
 hostprogs-$(CONFIG_LOGO)         += pnmtologo
@@ -23,8 +26,9 @@ hostprogs-$(CONFIG_SYSTEM_EXTRA_CERTIFIC
 
 HOSTCFLAGS_sortextable.o = -I$(srctree)/tools/include
 HOSTCFLAGS_asn1_compiler.o = -I$(srctree)/include
-HOSTLDLIBS_sign-file = -lcrypto
-HOSTLDLIBS_extract-cert = -lcrypto
+HOSTLDLIBS_sign-file = $(CRYPTO_LIBS)
+HOSTCFLAGS_extract-cert.o = $(CRYPTO_CFLAGS)
+HOSTLDLIBS_extract-cert = $(CRYPTO_LIBS)
 
 always		:= $(hostprogs-y) $(hostprogs-m)
 


