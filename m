Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF154E7790
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 16:28:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376464AbiCYP2s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 11:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377385AbiCYPYG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 11:24:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2853DFD6E;
        Fri, 25 Mar 2022 08:17:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3407F60AD0;
        Fri, 25 Mar 2022 15:17:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42BADC340E9;
        Fri, 25 Mar 2022 15:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648221475;
        bh=2Y7SEJ45GUxU9Jc1FeEiiIgPS7sVZVqp/nNW4EwEPk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hDnG8asAjKW1J5W3sjgsZcrsEKYJ+37uqh4GjfB2XxQc0N365grZsdAmNlHMrBGnT
         EWKhxzVT1kOfZvZxWmWIkoTvmNMv/eoBhX/RW7Rct/mVwUYS6xWaMU8e75sE9uqlG0
         8cGL5igEZuETJcAm/tlHtwmmSJyyO6HDZTJMdGfA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.16 36/37] m68k: fix access_ok for coldfire
Date:   Fri, 25 Mar 2022 16:14:46 +0100
Message-Id: <20220325150421.078633953@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220325150420.046488912@linuxfoundation.org>
References: <20220325150420.046488912@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 26509034bef198525d5936c116cbd0c3fa491c0b upstream.

While most m68k platforms use separate address spaces for user
and kernel space, at least coldfire does not, and the other
ones have a TASK_SIZE that is less than the entire 4GB address
range.

Using the default implementation of __access_ok() stops coldfire
user space from trivially accessing kernel memory.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/m68k/include/asm/uaccess.h |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/arch/m68k/include/asm/uaccess.h
+++ b/arch/m68k/include/asm/uaccess.h
@@ -12,14 +12,17 @@
 #include <asm/extable.h>
 
 /* We let the MMU do all checking */
-static inline int access_ok(const void __user *addr,
+static inline int access_ok(const void __user *ptr,
 			    unsigned long size)
 {
-	/*
-	 * XXX: for !CONFIG_CPU_HAS_ADDRESS_SPACES this really needs to check
-	 * for TASK_SIZE!
-	 */
-	return 1;
+	unsigned long limit = TASK_SIZE;
+	unsigned long addr = (unsigned long)ptr;
+
+	if (IS_ENABLED(CONFIG_CPU_HAS_ADDRESS_SPACES) ||
+	    !IS_ENABLED(CONFIG_MMU))
+		return 1;
+
+	return (size <= limit) && (addr <= (limit - size));
 }
 
 /*


