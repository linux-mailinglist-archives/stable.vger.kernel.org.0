Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE3257F11A
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 21:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238748AbiGWTDB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 15:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234408AbiGWTDB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 15:03:01 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D8E1836A;
        Sat, 23 Jul 2022 12:03:00 -0700 (PDT)
Date:   Sat, 23 Jul 2022 19:02:56 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1658602977;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KVhvayUCuLUwx0cDpVyHzUhQXQXy9a7YeCjQCfFqYT0=;
        b=SRuxErA1NYjv4s6GKmTUGHlJabtLaz74O3s1TaDcYu7yurBcl0XISOMrO1c48aKc5JbA7l
        FfD+bnIobLgDXN9nOCrBkRExxCMf2SpDJvcwYuwjUE2ythl2qwDUA4sFlAKyqmPZ8ELjYy
        g/uB/In9wzYwOTSrcrjMMy9X2yy7uOXXrwMlAY25fzNyKJXvWnuDzoirKMVVC6vAMIdIWA
        Jqn4Wso0/XRbWAWwrK1EwTiTPwc8g7DAY/u+jBK5vMoNqefr96ETvO5P8JEBZoKn1JniZh
        xnzkdoolnhOFdF/An2dVQ6WMkv+VRm+gzWvROWLluy65laJ4gGljaXvVrbA1rA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1658602977;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KVhvayUCuLUwx0cDpVyHzUhQXQXy9a7YeCjQCfFqYT0=;
        b=JI9qW77DzmozqRoY4VkO0t1MNyNkCjWnf4sT7uG7zVrQPHdbCuRRH38etVn7/WzkhKsIHJ
        oTp9qjUYOeNwAUBA==
From:   "tip-bot2 for Ben Hutchings" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/speculation: Make all RETbleed mitigations 64-bit only
Cc:     Ben Hutchings <ben@decadent.org.uk>, Borislav Petkov <bp@suse.de>,
        <stable@vger.kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <YtwSR3NNsWp1ohfV@decadent.org.uk>
References: <YtwSR3NNsWp1ohfV@decadent.org.uk>
MIME-Version: 1.0
Message-ID: <165860297629.15455.8257113023400800621.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     b648ab487f31bc4c38941bc770ea97fe394304bb
Gitweb:        https://git.kernel.org/tip/b648ab487f31bc4c38941bc770ea97fe394304bb
Author:        Ben Hutchings <ben@decadent.org.uk>
AuthorDate:    Sat, 23 Jul 2022 17:22:47 +02:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Sat, 23 Jul 2022 18:45:11 +02:00

x86/speculation: Make all RETbleed mitigations 64-bit only

The mitigations for RETBleed are currently ineffective on x86_32 since
entry_32.S does not use the required macros.  However, for an x86_32
target, the kconfig symbols for them are still enabled by default and
/sys/devices/system/cpu/vulnerabilities/retbleed will wrongly report
that mitigations are in place.

Make all of these symbols depend on X86_64, and only enable RETHUNK by
default on X86_64.

Fixes: f43b9876e857 ("x86/retbleed: Add fine grained Kconfig knobs")
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/YtwSR3NNsWp1ohfV@decadent.org.uk
---
 arch/x86/Kconfig | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e58798f..1670a3f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2473,7 +2473,7 @@ config RETHUNK
 	bool "Enable return-thunks"
 	depends on RETPOLINE && CC_HAS_RETURN_THUNK
 	select OBJTOOL if HAVE_OBJTOOL
-	default y
+	default y if X86_64
 	help
 	  Compile the kernel with the return-thunks compiler option to guard
 	  against kernel-to-user data leaks by avoiding return speculation.
@@ -2482,21 +2482,21 @@ config RETHUNK
 
 config CPU_UNRET_ENTRY
 	bool "Enable UNRET on kernel entry"
-	depends on CPU_SUP_AMD && RETHUNK
+	depends on CPU_SUP_AMD && RETHUNK && X86_64
 	default y
 	help
 	  Compile the kernel with support for the retbleed=unret mitigation.
 
 config CPU_IBPB_ENTRY
 	bool "Enable IBPB on kernel entry"
-	depends on CPU_SUP_AMD
+	depends on CPU_SUP_AMD && X86_64
 	default y
 	help
 	  Compile the kernel with support for the retbleed=ibpb mitigation.
 
 config CPU_IBRS_ENTRY
 	bool "Enable IBRS on kernel entry"
-	depends on CPU_SUP_INTEL
+	depends on CPU_SUP_INTEL && X86_64
 	default y
 	help
 	  Compile the kernel with support for the spectre_v2=ibrs mitigation.
