Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8A557EE06
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 12:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238418AbiGWKF4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 06:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238424AbiGWKFY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 06:05:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B9DF54;
        Sat, 23 Jul 2022 03:00:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45B4361277;
        Sat, 23 Jul 2022 10:00:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 535F3C341C0;
        Sat, 23 Jul 2022 10:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570424;
        bh=NDj9XORo/OeKYd/gw/mw/rUhZ8m5yMraNTBvIwn97J8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hshp7uoDoAvtbQZXVy6eyy/D+FRgdPmDqbolii/RQbF5/pyv3n/u6h/P4rFbCrnRA
         5uqwv5/oVKHMzoFmzjwjKL7OeHKKSrHqoFiJzfQYWjyjrryRcwOuezFkC4OlPnxnXz
         H0mnN87elrS4MSLtGT1JT+xVFPAzjgMZt7/zqe7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 082/148] Makefile: Set retpoline cflags based on CONFIG_CC_IS_{CLANG,GCC}
Date:   Sat, 23 Jul 2022 11:54:54 +0200
Message-Id: <20220723095247.327282663@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220723095224.302504400@linuxfoundation.org>
References: <20220723095224.302504400@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
 


