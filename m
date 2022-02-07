Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE734ABB2C
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:37:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384256AbiBGL0u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:26:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356609AbiBGLNR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:13:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D39B8C0401C1;
        Mon,  7 Feb 2022 03:13:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87409611AA;
        Mon,  7 Feb 2022 11:13:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56FE1C004E1;
        Mon,  7 Feb 2022 11:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232395;
        bh=j8GhDE5h8Hapt122YqavWtJP8vnPRrRx5qAl5rxzYAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A53nI1wLLh6JPpqCGr2QA02XIpUUaEiuFJdz0TZZlyobyUlSZ/nQt1HLftngzHv18
         q9dLtAAfIV+uL1SL4+eJOjJsTeF8yFuisUKkCFamJw1XVlQWw/YdNvm/EeVE3GQaS/
         Bnd5u+KyNAq5QRd+nqfwiCSRkyHp4k2O8D5TvSt0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@collabora.com>,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 4.14 65/69] selftests: futex: Use variable MAKE instead of make
Date:   Mon,  7 Feb 2022 12:06:27 +0100
Message-Id: <20220207103757.767977963@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103755.604121441@linuxfoundation.org>
References: <20220207103755.604121441@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
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
@@ -40,6 +40,6 @@ override define CLEAN
 	@for DIR in $(SUBDIRS); do		\
 		BUILD_TARGET=$(OUTPUT)/$$DIR;	\
 		mkdir $$BUILD_TARGET  -p;	\
-		make OUTPUT=$$BUILD_TARGET -C $$DIR $@;\
+		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$DIR $@;\
 	done
 endef


