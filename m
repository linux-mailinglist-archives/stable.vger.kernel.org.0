Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B43932EAF6
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233214AbhCEMlV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:41:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:56224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229591AbhCEMkt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:40:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D00FC64EE8;
        Fri,  5 Mar 2021 12:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614948048;
        bh=MjHykEdtMrXOALV9k3gyfg8rgd/q7Qtas/JBrySBsA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YX4q3bSniRyb5E2cNqoGNcpkHLNtUSEIqULRN5scq+Wq6T7BL/RC/lbWMzJ8/GwJU
         3BzrTlvMYbW0UADFUeCIHbQE4ak4wiDvfo2o/e9Kr/DbLe7eRrGoffFsK6OqB+mlGc
         wpjM17xUiIZGgd9EbYDDkxX8jxWXQgTBXoVNw41k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rolf Eike Beer <eb@emlix.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 4.9 10/41] scripts: use pkg-config to locate libcrypto
Date:   Fri,  5 Mar 2021 13:22:17 +0100
Message-Id: <20210305120851.788098177@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120851.255002428@linuxfoundation.org>
References: <20210305120851.255002428@linuxfoundation.org>
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
@@ -23,8 +26,9 @@ hostprogs-$(CONFIG_SYSTEM_EXTRA_CERTIFIC
 
 HOSTCFLAGS_sortextable.o = -I$(srctree)/tools/include
 HOSTCFLAGS_asn1_compiler.o = -I$(srctree)/include
-HOSTLOADLIBES_sign-file = -lcrypto
-HOSTLOADLIBES_extract-cert = -lcrypto
+HOSTLOADLIBES_sign-file = $(CRYPTO_LIBS)
+HOSTCFLAGS_extract-cert.o = $(CRYPTO_CFLAGS)
+HOSTLOADLIBES_extract-cert = $(CRYPTO_LIBS)
 
 always		:= $(hostprogs-y) $(hostprogs-m)
 


