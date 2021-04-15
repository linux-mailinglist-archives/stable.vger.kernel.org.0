Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28E2F360DD4
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234390AbhDOPGH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 11:06:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:48596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234615AbhDOPEa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 11:04:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 274F3613F9;
        Thu, 15 Apr 2021 14:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498722;
        bh=q+3hsxCREjU5gbs99CyxzJjEAajNjc0NDEIHHluz71U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ABbNxtAhgSr8NbbJycJpycumg/gTAjvvj7+WHX6Eai172NlPIbBciw0SNgpGKTbyP
         mqNyO8e+G+ij6QxSmgm7VSxbWWZ+idkKQUnVnQitxPZDIJm26oYsBhSjL4U55YakDp
         kjQ6oavAlB912CZDAy2ugD6FuB1XKMK0JROMtTNU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Anders Roxell <anders.roxell@linaro.org>
Subject: [PATCH 5.11 22/23] perf map: Tighten snprintf() string precision to pass gcc check on some 32-bit arches
Date:   Thu, 15 Apr 2021 16:48:29 +0200
Message-Id: <20210415144413.845922274@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144413.146131392@linuxfoundation.org>
References: <20210415144413.146131392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

commit 77d02bd00cea9f1a87afe58113fa75b983d6c23a upstream.

Noticed on a debian:experimental mips and mipsel cross build build
environment:

  perfbuilder@ec265a086e9b:~$ mips-linux-gnu-gcc --version | head -1
  mips-linux-gnu-gcc (Debian 10.2.1-3) 10.2.1 20201224
  perfbuilder@ec265a086e9b:~$

    CC       /tmp/build/perf/util/map.o
  util/map.c: In function 'map__new':
  util/map.c:109:5: error: '%s' directive output may be truncated writing between 1 and 2147483645 bytes into a region of size 4096 [-Werror=format-truncation=]
    109 |    "%s/platforms/%s/arch-%s/usr/lib/%s",
        |     ^~
  In file included from /usr/mips-linux-gnu/include/stdio.h:867,
                   from util/symbol.h:11,
                   from util/map.c:2:
  /usr/mips-linux-gnu/include/bits/stdio2.h:67:10: note: '__builtin___snprintf_chk' output 32 or more bytes (assuming 4294967321) into a destination of size 4096
     67 |   return __builtin___snprintf_chk (__s, __n, __USE_FORTIFY_LEVEL - 1,
        |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     68 |        __bos (__s), __fmt, __va_arg_pack ());
        |        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  cc1: all warnings being treated as errors

Since we have the lenghts for what lands in that place, use it to give
the compiler more info and make it happy.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Anders Roxell <anders.roxell@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/map.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -77,8 +77,7 @@ static inline bool replace_android_lib(c
 	if (strstarts(filename, "/system/lib/")) {
 		char *ndk, *app;
 		const char *arch;
-		size_t ndk_length;
-		size_t app_length;
+		int ndk_length, app_length;
 
 		ndk = getenv("NDK_ROOT");
 		app = getenv("APP_PLATFORM");
@@ -106,8 +105,8 @@ static inline bool replace_android_lib(c
 		if (new_length > PATH_MAX)
 			return false;
 		snprintf(newfilename, new_length,
-			"%s/platforms/%s/arch-%s/usr/lib/%s",
-			ndk, app, arch, libname);
+			"%.*s/platforms/%.*s/arch-%s/usr/lib/%s",
+			ndk_length, ndk, app_length, app, arch, libname);
 
 		return true;
 	}


