Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8758A66782B
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240107AbjALOxl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:53:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240026AbjALOwy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:52:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A78658310
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:39:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39F996204D
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:39:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30637C433F2;
        Thu, 12 Jan 2023 14:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673534373;
        bh=X6AO+ICyUAhRroz7wx/JyDHPT450INcFtYz4yqLOU2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aQsCdpKG4+cjqkQNRJKnu28skiDNtbl5XUTd1WWI832F892PRPf3kRH/PNRwIpn1l
         gfi4cNJQAcfOlAlbGX5XRci4gBwfeQn6WN/wNKuou7E2ifta/8+XYadk7j0TqBVHvX
         OIYJpYTaGVJ+pJLz+QV+8kw8X24sFV+vwYQ4KUEM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        "Tyler Hicks (Microsoft)" <code@tyhicks.com>
Subject: [PATCH 5.10 767/783] selftests: set the BUILD variable to absolute path
Date:   Thu, 12 Jan 2023 14:58:03 +0100
Message-Id: <20230112135559.921437710@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muhammad Usama Anjum <usama.anjum@collabora.com>

commit 5ad51ab618de5d05f4e692ebabeb6fe6289aaa57 upstream.

The build of kselftests fails if relative path is specified through
KBUILD_OUTPUT or O=<path> method. BUILD variable is used to determine
the path of the output objects. When make is run from other directories
with relative paths, the exact path of the build objects is ambiguous
and build fails.

	make[1]: Entering directory '/home/usama/repos/kernel/linux_mainline2/tools/testing/selftests/alsa'
	gcc     mixer-test.c -L/usr/lib/x86_64-linux-gnu -lasound  -o build/kselftest/alsa/mixer-test
	/usr/bin/ld: cannot open output file build/kselftest/alsa/mixer-test

Set the BUILD variable to the absolute path of the output directory.
Make the logic readable and easy to follow. Use spaces instead of tabs
for indentation as if with tab indentation is considered recipe in make.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Tyler Hicks (Microsoft) <code@tyhicks.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/Makefile |   26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -103,19 +103,27 @@ ifdef building_out_of_srctree
 override LDFLAGS =
 endif
 
-ifneq ($(O),)
-	BUILD := $(O)/kselftest
+top_srcdir ?= ../../..
+
+ifeq ("$(origin O)", "command line")
+  KBUILD_OUTPUT := $(O)
+endif
+
+ifneq ($(KBUILD_OUTPUT),)
+  # Make's built-in functions such as $(abspath ...), $(realpath ...) cannot
+  # expand a shell special character '~'. We use a somewhat tedious way here.
+  abs_objtree := $(shell cd $(top_srcdir) && mkdir -p $(KBUILD_OUTPUT) && cd $(KBUILD_OUTPUT) && pwd)
+  $(if $(abs_objtree),, \
+    $(error failed to create output directory "$(KBUILD_OUTPUT)"))
+  # $(realpath ...) resolves symlinks
+  abs_objtree := $(realpath $(abs_objtree))
+  BUILD := $(abs_objtree)/kselftest
 else
-	ifneq ($(KBUILD_OUTPUT),)
-		BUILD := $(KBUILD_OUTPUT)/kselftest
-	else
-		BUILD := $(shell pwd)
-		DEFAULT_INSTALL_HDR_PATH := 1
-	endif
+  BUILD := $(CURDIR)
+  DEFAULT_INSTALL_HDR_PATH := 1
 endif
 
 # Prepare for headers install
-top_srcdir ?= ../../..
 include $(top_srcdir)/scripts/subarch.include
 ARCH           ?= $(SUBARCH)
 export KSFT_KHDR_INSTALL_DONE := 1


