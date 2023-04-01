Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6688E6D2CFA
	for <lists+stable@lfdr.de>; Sat,  1 Apr 2023 03:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233685AbjDABpm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 21:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233657AbjDABpF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 21:45:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEFDA1EFE3;
        Fri, 31 Mar 2023 18:43:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ADCB6B8331B;
        Sat,  1 Apr 2023 01:43:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A016C433D2;
        Sat,  1 Apr 2023 01:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680313433;
        bh=+CQiA2TpuPtNk29w+WbITPO+Y/iqiI7Ncoa4XcxFW/I=;
        h=From:To:Cc:Subject:Date:From;
        b=BfttM5nAReRBBPaZ6JQkvC80GgSXaoPOJVn4JyRK7XXO+Ow3ssbtljnW56CXYl/3h
         iEJKnrI1vx4tWZGmzsIHkvFHdPwUA1SxiffGPOsLxxa330MiY/oT6W1jIr/f0pHbK4
         Gd5uMql/PUiMrf8dgqELlliSEyMRa02GOYdXEe8i/ke3ng8A4A9PW5aIh9uJOGt+Gb
         oe6zgnA5fwdJ02bfjMJ4jb+ttPKaSx4YyNX7yScyGTdw5rhq4ArscQHXRlm5chupmK
         Z/jpwf+c4sF+OWOdo6ORz8UCsiOxhiLFI89KQYSTcwv09/CZ0sEOIWH/ELNc3adLgn
         mK+Y+ejXWNnmQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrew Jeffery <andrew@aj.id.au>,
        Zev Weiss <zev@bewilderbeest.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>, linux@armlinux.org.uk,
        akpm@linux-foundation.org, anshuman.khandual@arm.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 01/11] ARM: 9290/1: uaccess: Fix KASAN false-positives
Date:   Fri, 31 Mar 2023 21:43:39 -0400
Message-Id: <20230401014350.3357107-1-sashal@kernel.org>
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
index 106f83a5ea6d2..35e03f6a62127 100644
--- a/arch/arm/lib/uaccess_with_memcpy.c
+++ b/arch/arm/lib/uaccess_with_memcpy.c
@@ -121,7 +121,7 @@ __copy_to_user_memcpy(void __user *to, const void *from, unsigned long n)
 			tocopy = n;
 
 		ua_flags = uaccess_save_and_enable();
-		memcpy((void *)to, from, tocopy);
+		__memcpy((void *)to, from, tocopy);
 		uaccess_restore(ua_flags);
 		to += tocopy;
 		from += tocopy;
@@ -188,7 +188,7 @@ __clear_user_memset(void __user *addr, unsigned long n)
 			tocopy = n;
 
 		ua_flags = uaccess_save_and_enable();
-		memset((void *)addr, 0, tocopy);
+		__memset((void *)addr, 0, tocopy);
 		uaccess_restore(ua_flags);
 		addr += tocopy;
 		n -= tocopy;
-- 
2.39.2

