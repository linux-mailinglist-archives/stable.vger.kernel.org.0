Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D52956D2C85
	for <lists+stable@lfdr.de>; Sat,  1 Apr 2023 03:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233385AbjDABle (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 21:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233074AbjDABld (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 21:41:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46FC31D2DA;
        Fri, 31 Mar 2023 18:41:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC7F1B832F1;
        Sat,  1 Apr 2023 01:41:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76BDFC433EF;
        Sat,  1 Apr 2023 01:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680313289;
        bh=DEWe0jkc9Y6r28LdFAGOYrRGMnBiZ+L83NWmkJE1QTM=;
        h=From:To:Cc:Subject:Date:From;
        b=ocFXtJH/eHnOw5bPRiMjeHa+eP1P6nNfGNnbvcdnwz3tGC+9ibya67KoAP40fU7wv
         1tsnF/O5TI4lIRqJQJzBB5yud1pOE+lWU+8iI2zHBEmJVQs/cHMJcIT073PsiLNNgO
         COlVywzrqSBiBovio0SqflUvSddu5m9no9qGWdiCodJlyAyvugammgqBqbqSenjive
         wA8n8CREdXw7ZkyMnKZv0ehudckoOh5Kkl45XqGlLgmnzSUOs0jZp5FhwWKi78ZRTk
         76tKJDRhbWdfBf+C8jXNQIbwoEPYmPtg54+Lwtc9REkuvvIQULScL9vfwrQ4yXA0yj
         HHgtwIjSJ3FEw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrew Jeffery <andrew@aj.id.au>,
        Zev Weiss <zev@bewilderbeest.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>, linux@armlinux.org.uk,
        anshuman.khandual@arm.com, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.2 01/25] ARM: 9290/1: uaccess: Fix KASAN false-positives
Date:   Fri, 31 Mar 2023 21:40:59 -0400
Message-Id: <20230401014126.3356410-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
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

