Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6C113147C4
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 06:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbhBIFCO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 00:02:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbhBIFCN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Feb 2021 00:02:13 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D4CFC061786
        for <stable@vger.kernel.org>; Mon,  8 Feb 2021 21:01:33 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id s107so16375748otb.8
        for <stable@vger.kernel.org>; Mon, 08 Feb 2021 21:01:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fPCpkVfjovuH2xLzjNVIxVsQ7nWqp6967gETifn4yFs=;
        b=jkkHHFNNSBV/BmiP/s2hQdSjYrydl3P2pNC2VeHDwm1yhKAjgxIEgrJG1dlEU/p1E0
         PoKFBHEvt1yK1Dzk6zwoMXEv8Kovl0MVm1a1VKR242c/OE/sgqN4wV8DY6e0to7KK9KH
         MOm8jpmXs39ZPeNNDRCjM1eUwBQjgD3V7sqTGEaKsYltPIS37T2bX8sJF0pSO6huK2ei
         CQYH3Or4S9ZbCSb9os1F559uylmPUH5PeJEKrbQBCrvOfKHAaA268Rg5bNOqAFun2dn8
         1EmzBgwO2VDp6orPXbfXT2QWu1wRW/BIn/ZV9enmI0dS0e25rZovR7BXwJTBZ4jxyT5T
         TmVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fPCpkVfjovuH2xLzjNVIxVsQ7nWqp6967gETifn4yFs=;
        b=sQq0BIrhhjW0OkPg5Ma/8IazKErSTvQRDjRvEY2AjHg4hCZmkllOIZSCUmAuAynv1d
         pNBr2lNdEuEBpPS3uoSYJPPCY2Vt1quQloX9y52pGQ7QoGlCNwu3/P57voYac7Xk0GOF
         vbuG+0+nJeAvDY46RoxHQUkj0umooMuyCUz2VURRIqrZSvdHC9UAaPnD4labpEBdtLqM
         oTj6esk2p0QO9KrDfTkoL/xi4lE5lhUvXamRNhGsynjsm/Kc8RJ750WbOv4Vch+dtCoi
         wrrw2WEONW1TL/NvCpXWLjclOa0zkvpbzoYTnwhOC8ZTDR3iC2EPmNXdTwh+gPjoD/Sq
         Jz2g==
X-Gm-Message-State: AOAM530qAwHoqRCkiFhZNoAiwmknMQ+Sa6x8KuTT7joPuG7x6/KluoGD
        AsuiHcDZA2m/EOskUUYwfKxA3A==
X-Google-Smtp-Source: ABdhPJx7LAMxCgyYafmO+tqrCg4OiyhIKIMStx1wd2Jc0UfhSVchmsvBakWI7k5MCXJL/3XVD7EuDA==
X-Received: by 2002:a05:6830:1110:: with SMTP id w16mr14772313otq.326.1612846892406;
        Mon, 08 Feb 2021 21:01:32 -0800 (PST)
Received: from alago.cortijodelrio.net (CableLink-189-219-72-83.Hosts.InterCable.net. [189.219.72.83])
        by smtp.googlemail.com with ESMTPSA id o14sm3338831otl.68.2021.02.08.21.01.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 21:01:31 -0800 (PST)
From:   =?UTF-8?q?Daniel=20D=C3=ADaz?= <daniel.diaz@linaro.org>
To:     Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Rolf Eike Beer <eb@emlix.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org (open list)
Cc:     =?UTF-8?q?Daniel=20D=C3=ADaz?= <daniel.diaz@linaro.org>,
        stable@vger.kernel.org, Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: [PATCH] scripts: Fix linking extract-cert against libcrypto
Date:   Mon,  8 Feb 2021 22:59:56 -0600
Message-Id: <20210209050047.1958473-1-daniel.diaz@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When compiling under OpenEmbedded, the following error is seen
as of recently:

  /srv/oe/build/tmp/hosttools/ld: cannot find /lib/libc.so.6 inside /
  /srv/oe/build/tmp/hosttools/ld: cannot find /usr/lib/libc_nonshared.a inside /
  /srv/oe/build/tmp/hosttools/ld: cannot find /lib/ld-linux-x86-64.so.2 inside /
  collect2: error: ld returned 1 exit status
  make[2]: *** [scripts/Makefile.host:95: scripts/extract-cert] Error 1

This is because 2cea4a7a1885 ("scripts: use pkg-config to
locate libcrypto") now calls for `pkg-config --libs libcrypto`
and inserts that into the Makefile rules as LDLIBS when
building extract-cert.c.

The problem is that --libs will include both -l and -L, which
will be out of order when compiling/linking.

This (very ugly) command is what's produced with OpenEmbedded:

  gcc -Wp,-MMD,scripts/.extract-cert.d -Wall -Wmissing-prototypes -Wstrict-prototypes \
    -O2 -fomit-frame-pointer -std=gnu89 \
    -isystem/oe/build/tmp/work/MACHINE/linux/5.10+gitAUTOINC+b01f250d83-r0/recipe-sysroot-native/usr/include \
    -O2 -pipe -L/oe/build/tmp/work/MACHINE/linux/5.10+gitAUTOINC+b01f250d83-r0/recipe-sysroot-native/usr/lib \
    -L/oe/build/tmp/work/MACHINE/linux/5.10+gitAUTOINC+b01f250d83-r0/recipe-sysroot-native/lib \
    -Wl,-rpath-link,/oe/build/tmp/work/MACHINE/linux/5.10+gitAUTOINC+b01f250d83-r0/recipe-sysroot-native/usr/lib \
    -Wl,-rpath-link,/oe/build/tmp/work/MACHINE/linux/5.10+gitAUTOINC+b01f250d83-r0/recipe-sysroot-native/lib \
    -Wl,-rpath,/oe/build/tmp/work/MACHINE/linux/5.10+gitAUTOINC+b01f250d83-r0/recipe-sysroot-native/usr/lib \
    -Wl,-rpath,/oe/build/tmp/work/MACHINE/linux/5.10+gitAUTOINC+b01f250d83-r0/recipe-sysroot-native/lib \
    -Wl,-O1 -I/oe/build/tmp/work/MACHINE/linux/5.10+gitAUTOINC+b01f250d83-r0/recipe-sysroot-native/usr/include \
    -I ./scripts -o scripts/extract-cert \
    /oe/build/tmp/work-shared/intel-corei7-64/kernel-source/scripts/extract-cert.c \
    -L/oe/build/tmp/work/MACHINE/linux/5.10+gitAUTOINC+b01f250d83-r0/recipe-sysroot/usr//lib \
    -lcrypto

As per `make`'s documentation:

  LDFLAGS
    Extra flags to give to compilers when they are supposed to
    invoke the linker, ‘ld’, such as -L. Libraries (-lfoo)
    should be added to the LDLIBS variable instead.

  LDLIBS
    Library flags or names given to compilers when they are
    supposed to invoke the linker, ‘ld’. LOADLIBES is a
    deprecated (but still supported) alternative to LDLIBS.
    Non-library linker flags, such as -L, should go in the
    LDFLAGS variable.

Fixes: 2cea4a7a1885 ("scripts: use pkg-config to locate libcrypto")
Cc: stable@vger.kernel.org # 5.6.x
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Daniel Díaz <daniel.diaz@linaro.org>
---
 scripts/Makefile | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/scripts/Makefile b/scripts/Makefile
index 9de3c03b94aa..4b4e938b4ba7 100644
--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -3,7 +3,8 @@
 # scripts contains sources for various helper programs used throughout
 # the kernel for the build process.
 
-CRYPTO_LIBS = $(shell pkg-config --libs libcrypto 2> /dev/null || echo -lcrypto)
+CRYPTO_LDFLAGS = $(shell pkg-config --libs-only-L libcrypto 2> /dev/null)
+CRYPTO_LDLIBS = $(shell pkg-config --libs-only-l libcrypto 2> /dev/null || echo -lcrypto)
 CRYPTO_CFLAGS = $(shell pkg-config --cflags libcrypto 2> /dev/null)
 
 hostprogs-always-$(CONFIG_BUILD_BIN2C)			+= bin2c
@@ -17,9 +18,11 @@ hostprogs-always-$(CONFIG_SYSTEM_EXTRA_CERTIFICATE)	+= insert-sys-cert
 
 HOSTCFLAGS_sorttable.o = -I$(srctree)/tools/include
 HOSTCFLAGS_asn1_compiler.o = -I$(srctree)/include
-HOSTLDLIBS_sign-file = $(CRYPTO_LIBS)
+HOSTLDFLAGS_sign-file = $(CRYPTO_LDFLAGS)
+HOSTLDLIBS_sign-file = $(CRYPTO_LDLIBS)
 HOSTCFLAGS_extract-cert.o = $(CRYPTO_CFLAGS)
-HOSTLDLIBS_extract-cert = $(CRYPTO_LIBS)
+HOSTLDFLAGS_extract-cert = $(CRYPTO_LDFLAGS)
+HOSTLDLIBS_extract-cert = $(CRYPTO_LDLIBS)
 
 ifdef CONFIG_UNWINDER_ORC
 ifeq ($(ARCH),x86_64)
-- 
2.25.1

