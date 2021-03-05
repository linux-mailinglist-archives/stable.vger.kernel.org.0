Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C33D32EB75
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:45:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232981AbhCEMo0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:44:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:60936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233889AbhCEMng (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:43:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A57965022;
        Fri,  5 Mar 2021 12:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614948214;
        bh=qVnZWZAaKO3b/42kEtZeI3omEsv1jobP5LLTF08RteI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bN3QC12EslrdcVoPGMrJsGAbKQgWJY5vFSjgyU+T5+x9XKoH9XM0ISvxGcodTZlVy
         u3mhnFNWSQjEtPAGWmFhqY+YkS2P/9jQLBm2ZPrfjBzrO7WhZcLEnpGni3zB7R7qZK
         nFDD2mg0yymgL1RcsUtaOzjNxo7iuHNWoa8tzdus=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rolf Eike Beer <eb@emlix.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 4.4 05/30] scripts: use pkg-config to locate libcrypto
Date:   Fri,  5 Mar 2021 13:22:34 +0100
Message-Id: <20210305120849.665989810@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120849.381261651@linuxfoundation.org>
References: <20210305120849.381261651@linuxfoundation.org>
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
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/Makefile |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -11,6 +11,9 @@
 
 HOST_EXTRACFLAGS += -I$(srctree)/tools/include
 
+CRYPTO_LIBS = $(shell pkg-config --libs libcrypto 2> /dev/null || echo -lcrypto)
+CRYPTO_CFLAGS = $(shell pkg-config --cflags libcrypto 2> /dev/null)
+
 hostprogs-$(CONFIG_KALLSYMS)     += kallsyms
 hostprogs-$(CONFIG_LOGO)         += pnmtologo
 hostprogs-$(CONFIG_VT)           += conmakehash
@@ -22,8 +25,9 @@ hostprogs-$(CONFIG_SYSTEM_TRUSTED_KEYRIN
 
 HOSTCFLAGS_sortextable.o = -I$(srctree)/tools/include
 HOSTCFLAGS_asn1_compiler.o = -I$(srctree)/include
-HOSTLOADLIBES_sign-file = -lcrypto
-HOSTLOADLIBES_extract-cert = -lcrypto
+HOSTLOADLIBES_sign-file = $(CRYPTO_LIBS)
+HOSTCFLAGS_extract-cert.o = $(CRYPTO_CFLAGS)
+HOSTLOADLIBES_extract-cert = $(CRYPTO_LIBS)
 
 always		:= $(hostprogs-y) $(hostprogs-m)
 


