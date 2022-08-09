Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83CD358DE93
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 20:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345860AbiHISTZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 14:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346565AbiHISRJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 14:17:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 404822E691;
        Tue,  9 Aug 2022 11:06:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18CD5B818C9;
        Tue,  9 Aug 2022 18:06:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67F3DC433D7;
        Tue,  9 Aug 2022 18:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660068375;
        bh=Hw4pzzLd0H6uAutoVrmjO0vf0SfnwAPU/bjzRGD23m8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EUINnB7pTBUYBOGDmi7LyrU273Qs4WXjemDo5lYfQ6fm5go8qSToulVECC0dRGtsm
         oqmasT/LJdjcqV5eBkAMtPneM6u/j7CLfDNS9zXGu12F+kAy+ITZZui8t6QjDpAM9H
         0qomcptbwSDWJer5L81q4go9rLVkzAcnku0nJwd4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.18 01/35] x86/speculation: Make all RETbleed mitigations 64-bit only
Date:   Tue,  9 Aug 2022 20:00:30 +0200
Message-Id: <20220809175515.095853601@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809175515.046484486@linuxfoundation.org>
References: <20220809175515.046484486@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
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

commit b648ab487f31bc4c38941bc770ea97fe394304bb upstream.

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
[bwh: Backported to 5.10/5.15/5.18: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/Kconfig |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2469,7 +2469,7 @@ config RETPOLINE
 config RETHUNK
 	bool "Enable return-thunks"
 	depends on RETPOLINE && CC_HAS_RETURN_THUNK
-	default y
+	default y if X86_64
 	help
 	  Compile the kernel with the return-thunks compiler option to guard
 	  against kernel-to-user data leaks by avoiding return speculation.
@@ -2478,21 +2478,21 @@ config RETHUNK
 
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


