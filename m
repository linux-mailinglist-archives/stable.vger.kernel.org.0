Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD5164D48EA
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 15:15:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243185AbiCJOPT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:15:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243141AbiCJOO6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:14:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3931154D04;
        Thu, 10 Mar 2022 06:12:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E52961BD1;
        Thu, 10 Mar 2022 14:12:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54FA0C340E8;
        Thu, 10 Mar 2022 14:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646921523;
        bh=ZwwrUYRY5dio8pDaWYDTlGOjhbR2smNpyr8q2xrywcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=POaM76sUmFmRgJ92Zw2eA6zvYeVzkUsIJzKIE6AN4+aT2FFdPkL/v92RXfA9KLNua
         WdYRYYpAmEMil7Hm+JCG5rwKGTuaK8T28GiE9bMwNVv3KwM5qfXRZ0Un02BRdE9uq+
         rp2YGyCyZWl+FbJNIzvGiX4JdljmIhiyMSUeYUcM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.16 39/53] ARM: Do not use NOCROSSREFS directive with ld.lld
Date:   Thu, 10 Mar 2022 15:09:44 +0100
Message-Id: <20220310140812.957337935@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140811.832630727@linuxfoundation.org>
References: <20220310140811.832630727@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

commit 36168e387fa7d0f1fe0cd5cf76c8cea7aee714fa upstream.

ld.lld does not support the NOCROSSREFS directive at the moment, which
breaks the build after commit b9baf5c8c5c3 ("ARM: Spectre-BHB
workaround"):

  ld.lld: error: ./arch/arm/kernel/vmlinux.lds:34: AT expected, but got NOCROSSREFS

Support for this directive will eventually be implemented, at which
point a version check can be added. To avoid breaking the build in the
meantime, just define NOCROSSREFS to nothing when using ld.lld, with a
link to the issue for tracking.

Cc: stable@vger.kernel.org
Fixes: b9baf5c8c5c3 ("ARM: Spectre-BHB workaround")
Link: https://github.com/ClangBuiltLinux/linux/issues/1609
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/include/asm/vmlinux.lds.h |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/arm/include/asm/vmlinux.lds.h
+++ b/arch/arm/include/asm/vmlinux.lds.h
@@ -26,6 +26,14 @@
 #define ARM_MMU_DISCARD(x)	x
 #endif
 
+/*
+ * ld.lld does not support NOCROSSREFS:
+ * https://github.com/ClangBuiltLinux/linux/issues/1609
+ */
+#ifdef CONFIG_LD_IS_LLD
+#define NOCROSSREFS
+#endif
+
 /* Set start/end symbol names to the LMA for the section */
 #define ARM_LMA(sym, section)						\
 	sym##_start = LOADADDR(section);				\


