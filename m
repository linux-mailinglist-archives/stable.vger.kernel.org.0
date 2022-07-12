Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31ACF5723E2
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 20:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234880AbiGLSzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 14:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234322AbiGLSya (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:54:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BADCE95EB;
        Tue, 12 Jul 2022 11:45:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E53060AC3;
        Tue, 12 Jul 2022 18:45:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DCA1C3411E;
        Tue, 12 Jul 2022 18:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651556;
        bh=NDj9XORo/OeKYd/gw/mw/rUhZ8m5yMraNTBvIwn97J8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KJL3fTMuPcsBo8vXOLsvNG0u5K7QNWJD6OXYMV/r6N9mjzW8WKJYtslRMUmBl3dIa
         Sxi/huCEL4238RU1Xu0NTMlh3Pu3zrM1/KCR9jyDX8pmAu30NymoSVCgeA5bgE8tm/
         KLHoxP38g0e9F+QEG7fcDYbtcVrrNXRMAK+GQwVM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 082/130] Makefile: Set retpoline cflags based on CONFIG_CC_IS_{CLANG,GCC}
Date:   Tue, 12 Jul 2022 20:38:48 +0200
Message-Id: <20220712183250.241424402@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220712183246.394947160@linuxfoundation.org>
References: <20220712183246.394947160@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

This was done as part of commit 7d73c3e9c51400d3e0e755488050804e4d44737a
"Makefile: remove stale cc-option checks" upstream, and is needed to
support backporting further retpoline changes.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -670,12 +670,14 @@ ifdef CONFIG_FUNCTION_TRACER
   CC_FLAGS_FTRACE := -pg
 endif
 
-RETPOLINE_CFLAGS_GCC := -mindirect-branch=thunk-extern -mindirect-branch-register
-RETPOLINE_VDSO_CFLAGS_GCC := -mindirect-branch=thunk-inline -mindirect-branch-register
-RETPOLINE_CFLAGS_CLANG := -mretpoline-external-thunk
-RETPOLINE_VDSO_CFLAGS_CLANG := -mretpoline
-RETPOLINE_CFLAGS := $(call cc-option,$(RETPOLINE_CFLAGS_GCC),$(call cc-option,$(RETPOLINE_CFLAGS_CLANG)))
-RETPOLINE_VDSO_CFLAGS := $(call cc-option,$(RETPOLINE_VDSO_CFLAGS_GCC),$(call cc-option,$(RETPOLINE_VDSO_CFLAGS_CLANG)))
+ifdef CONFIG_CC_IS_GCC
+RETPOLINE_CFLAGS	:= $(call cc-option,-mindirect-branch=thunk-extern -mindirect-branch-register)
+RETPOLINE_VDSO_CFLAGS	:= $(call cc-option,-mindirect-branch=thunk-inline -mindirect-branch-register)
+endif
+ifdef CONFIG_CC_IS_CLANG
+RETPOLINE_CFLAGS	:= -mretpoline-external-thunk
+RETPOLINE_VDSO_CFLAGS	:= -mretpoline
+endif
 export RETPOLINE_CFLAGS
 export RETPOLINE_VDSO_CFLAGS
 


