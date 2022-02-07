Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77FC74ABC29
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384930AbiBGLar (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:30:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384031AbiBGLYb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:24:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D79ABC043189;
        Mon,  7 Feb 2022 03:24:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 74B4B6077B;
        Mon,  7 Feb 2022 11:24:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FC23C004E1;
        Mon,  7 Feb 2022 11:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233069;
        bh=72vwZ6kvzEMAGleLWY/VTPiDOeZhPnE8/1zmPpNqG64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xt2JQdoGnFpQscZ72AkhVW5CGKRM4kz4NkPogvCnxExUetizq4pB2VITPe9gwrBee
         zrHjsiWrDquxcy08ffIcW+UG5k10QAaVx/rWVLTOHfp7tm8Hhpuy6B2+8eb7qXjvN5
         fytYdovV1CJ5NPlUURz9eTtwUhPbCvgwsgTNYVnc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@collabora.com>,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 5.10 57/74] selftests: futex: Use variable MAKE instead of make
Date:   Mon,  7 Feb 2022 12:06:55 +0100
Message-Id: <20220207103759.093487968@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103757.232676988@linuxfoundation.org>
References: <20220207103757.232676988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muhammad Usama Anjum <usama.anjum@collabora.com>

commit b9199181a9ef8252e47e207be8c23e1f50662620 upstream.

Recursive make commands should always use the variable MAKE, not the
explicit command name ‘make’. This has benefits and removes the
following warning when multiple jobs are used for the build:

make[2]: warning: jobserver unavailable: using -j1.  Add '+' to parent make rule.

Fixes: a8ba798bc8ec ("selftests: enable O and KBUILD_OUTPUT")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Reviewed-by: André Almeida <andrealmeid@collabora.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/futex/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/futex/Makefile
+++ b/tools/testing/selftests/futex/Makefile
@@ -11,7 +11,7 @@ all:
 	@for DIR in $(SUBDIRS); do		\
 		BUILD_TARGET=$(OUTPUT)/$$DIR;	\
 		mkdir $$BUILD_TARGET  -p;	\
-		make OUTPUT=$$BUILD_TARGET -C $$DIR $@;\
+		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$DIR $@;\
 		if [ -e $$DIR/$(TEST_PROGS) ]; then \
 			rsync -a $$DIR/$(TEST_PROGS) $$BUILD_TARGET/; \
 		fi \
@@ -32,6 +32,6 @@ override define CLEAN
 	@for DIR in $(SUBDIRS); do		\
 		BUILD_TARGET=$(OUTPUT)/$$DIR;	\
 		mkdir $$BUILD_TARGET  -p;	\
-		make OUTPUT=$$BUILD_TARGET -C $$DIR $@;\
+		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$DIR $@;\
 	done
 endef


