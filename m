Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAAA032CD97
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 08:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbhCDH3B convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 4 Mar 2021 02:29:01 -0500
Received: from mx1.emlix.com ([136.243.223.33]:49484 "EHLO mx1.emlix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231419AbhCDH2x (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 02:28:53 -0500
Received: from mailer.emlix.com (unknown [81.20.119.6])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.emlix.com (Postfix) with ESMTPS id 8FF2C5FC8D
        for <stable@vger.kernel.org>; Thu,  4 Mar 2021 08:26:39 +0100 (CET)
From:   Rolf Eike Beer <eb@emlix.com>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 / 4.9 / 4.4 1/2] scripts: use pkg-config to locate libcrypto
Date:   Thu, 04 Mar 2021 08:25:01 +0100
Message-ID: <1776617.4qmgp806CG@devpool47>
Organization: emlix GmbH
In-Reply-To: <4669336.5LvBrcZMKH@devpool47>
References: <4669336.5LvBrcZMKH@devpool47>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 2cea4a7a1885bd0c765089afc14f7ff0eb77864e upstream.

Otherwise build fails if the headers are not in the default location. While at
it also ask pkg-config for the libs, with fallback to the existing value.

Signed-off-by: Rolf Eike Beer <eb@emlix.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---
 scripts/Makefile | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/scripts/Makefile b/scripts/Makefile
index 25ab143cbe14..6a9f6db114b0 100644
--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -10,6 +10,9 @@
 
 HOST_EXTRACFLAGS += -I$(srctree)/tools/include
 
+CRYPTO_LIBS = $(shell pkg-config --libs libcrypto 2> /dev/null || echo -lcrypto)
+CRYPTO_CFLAGS = $(shell pkg-config --cflags libcrypto 2> /dev/null)
+
 hostprogs-$(CONFIG_KALLSYMS)     += kallsyms
 hostprogs-$(CONFIG_LOGO)         += pnmtologo
 hostprogs-$(CONFIG_VT)           += conmakehash
@@ -22,8 +25,9 @@ hostprogs-$(CONFIG_SYSTEM_EXTRA_CERTIFICATE) += insert-sys-cert
 
 HOSTCFLAGS_sortextable.o = -I$(srctree)/tools/include
 HOSTCFLAGS_asn1_compiler.o = -I$(srctree)/include
-HOSTLOADLIBES_sign-file = -lcrypto
-HOSTLOADLIBES_extract-cert = -lcrypto
+HOSTLOADLIBES_sign-file = $(CRYPTO_LIBS)
+HOSTCFLAGS_extract-cert.o = $(CRYPTO_CFLAGS)
+HOSTLOADLIBES_extract-cert = $(CRYPTO_LIBS)
 
 always		:= $(hostprogs-y) $(hostprogs-m)
 
-- 
2.30.1

-- 
Rolf Eike Beer, emlix GmbH, http://www.emlix.com
Fon +49 551 30664-0, Fax +49 551 30664-11
Gothaer Platz 3, 37083 Göttingen, Germany
Sitz der Gesellschaft: Göttingen, Amtsgericht Göttingen HR B 3160
Geschäftsführung: Heike Jordan, Dr. Uwe Kracke – Ust-IdNr.: DE 205 198 055

emlix - smart embedded open source



