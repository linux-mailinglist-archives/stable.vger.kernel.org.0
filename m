Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05C206D2D02
	for <lists+stable@lfdr.de>; Sat,  1 Apr 2023 03:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233682AbjDABpE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 21:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233467AbjDABoW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 21:44:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3F4822EBE;
        Fri, 31 Mar 2023 18:43:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33BCFB8330B;
        Sat,  1 Apr 2023 01:42:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B90E4C4339B;
        Sat,  1 Apr 2023 01:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680313364;
        bh=DEWe0jkc9Y6r28LdFAGOYrRGMnBiZ+L83NWmkJE1QTM=;
        h=From:To:Cc:Subject:Date:From;
        b=asZjXLGiDmJAsd72cA+rkXBw9WYAzv7z1F9mmGYNBWZKBvoaWW2kG7Hs9d2jWgRoq
         5NnnBtNjavw7wsAYBJ/nh0/F0H9nkGZUvCII3+X/N0bXY6iXucjbXQ9NdGLkcg1kgH
         IBFZsQXMayP0J/12qswcsTgiKrkFPDnl8djMZvXWf2qSILzz3OUdC4PLGVn9CUoTUE
         WJtoHtFYsBp+qVuM8/wPGPh9XuIup1efLRbuJykSFfFvqXBQuj3msSI+MCWnlZafkl
         Y9V8a7FZyJAD8N7nXaZ91AGEv/5r4HmvgxGwjoGSIB3LX9Enm75UACJaS0HNlTH164
         S3LtF6OWaA5GQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrew Jeffery <andrew@aj.id.au>,
        Zev Weiss <zev@bewilderbeest.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>, linux@armlinux.org.uk,
        akpm@linux-foundation.org, anshuman.khandual@arm.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.1 01/24] ARM: 9290/1: uaccess: Fix KASAN false-positives
Date:   Fri, 31 Mar 2023 21:42:17 -0400
Message-Id: <20230401014242.3356780-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Jeffery <andrew@aj.id.au>

[ Upstream commit ceac10c83b330680cc01ceaaab86cd49f4f30d81 ]

__copy_to_user_memcpy() and __clear_user_memset() had been calling
memcpy() and memset() respectively, leading to false-positive KASAN
reports when starting userspace:

    [   10.707901] Run /init as init process
    [   10.731892] process '/bin/busybox' started with executable stack
    [   10.745234] ==================================================================
    [   10.745796] BUG: KASAN: user-memory-access in __clear_user_memset+0x258/0x3ac
    [   10.747260] Write of size 2687 at addr 000de581 by task init/1

Use __memcpy() and __memset() instead to allow userspace access, which
is of course the intent of these functions.

Signed-off-by: Andrew Jeffery <andrew@aj.id.au>
Signed-off-by: Zev Weiss <zev@bewilderbeest.net>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/lib/uaccess_with_memcpy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/lib/uaccess_with_memcpy.c b/arch/arm/lib/uaccess_with_memcpy.c
index 14eecaaf295fa..e4c2677cc1e9e 100644
--- a/arch/arm/lib/uaccess_with_memcpy.c
+++ b/arch/arm/lib/uaccess_with_memcpy.c
@@ -116,7 +116,7 @@ __copy_to_user_memcpy(void __user *to, const void *from, unsigned long n)
 			tocopy = n;
 
 		ua_flags = uaccess_save_and_enable();
-		memcpy((void *)to, from, tocopy);
+		__memcpy((void *)to, from, tocopy);
 		uaccess_restore(ua_flags);
 		to += tocopy;
 		from += tocopy;
@@ -178,7 +178,7 @@ __clear_user_memset(void __user *addr, unsigned long n)
 			tocopy = n;
 
 		ua_flags = uaccess_save_and_enable();
-		memset((void *)addr, 0, tocopy);
+		__memset((void *)addr, 0, tocopy);
 		uaccess_restore(ua_flags);
 		addr += tocopy;
 		n -= tocopy;
-- 
2.39.2

