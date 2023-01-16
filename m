Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF1E66C93F
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233884AbjAPQrR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:47:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233885AbjAPQqi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:46:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED32729E29
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:34:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BE0E6104D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:34:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1B3AC433F0;
        Mon, 16 Jan 2023 16:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886881;
        bh=D8VCu5XfzvY2eONbKg3wH65azwDdtbojeCpGAiI1RVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VFqhVdUonAIFApEWZeAkzav7Ou6GDM5jH56UGrF/RNQ5QJGM9C5w5y4oewjYCmUMn
         cc8j8s0SnpW341A+naX7Fa5rEILT8XXuD8sI1hkgqCoowHZz7P41UIb77PwQ+SOrYq
         69jKEg2C1f8Av5qETBUTg3BKJk8upYxDfvqJHx4Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shuah Khan <skhan@linuxfoundation.org>,
        "Tyler Hicks (Microsoft)" <code@tyhicks.com>
Subject: [PATCH 5.4 597/658] selftests: Fix kselftest O=objdir build from cluttering top level objdir
Date:   Mon, 16 Jan 2023 16:51:25 +0100
Message-Id: <20230116154936.778261547@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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

From: Shuah Khan <skhan@linuxfoundation.org>

commit 29e911ef7b706215caf02a82b0d3076611d6abe8 upstream.

make kselftest-all O=objdir builds create generated objects in objdir.
This clutters the top level directory with kselftest objects. Fix it
to create sub-directory under objdir for kselftest objects.

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Tyler Hicks (Microsoft) <code@tyhicks.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -78,7 +78,7 @@ override LDFLAGS =
 override MAKEFLAGS =
 endif
 
-# Append kselftest to KBUILD_OUTPUT to avoid cluttering
+# Append kselftest to KBUILD_OUTPUT and O to avoid cluttering
 # KBUILD_OUTPUT with selftest objects and headers installed
 # by selftests Makefile or lib.mk.
 ifdef building_out_of_srctree
@@ -86,7 +86,7 @@ override LDFLAGS =
 endif
 
 ifneq ($(O),)
-	BUILD := $(O)
+	BUILD := $(O)/kselftest
 else
 	ifneq ($(KBUILD_OUTPUT),)
 		BUILD := $(KBUILD_OUTPUT)/kselftest


