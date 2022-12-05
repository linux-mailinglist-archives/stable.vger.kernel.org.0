Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 419816434A7
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235120AbiLETsR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:48:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235113AbiLETrq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:47:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0181B5D
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:44:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EF4E612EA
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:44:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58F66C433C1;
        Mon,  5 Dec 2022 19:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670269458;
        bh=+273FMoA2A3cnFUJPZN9nHqfDczJFAX8TsvDawqFNzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OE6hKk/QLQ7Nv8ikvfR6U4BjzQMl0678uLpKpn/bMyfu6IEHMFdK1vOgeaWNsuU6T
         6k1ju/Ho4RpkecFRkJdve2tRdVLVK/5DmUSU/boz9jSbOOA3Gf3BUK0POXl9JgznGm
         kY2hKUxOMVD0FVFziLWZCAxzr7bcoq5NXDctP6gM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Guenter Roeck <linux@roeck-us.net>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Chris Zankel <chris@zankel.net>,
        David Laight <David.Laight@ACULAB.COM>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 134/153] xtensa: increase size of gcc stack frame check
Date:   Mon,  5 Dec 2022 20:10:58 +0100
Message-Id: <20221205190812.507148215@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 867050247e295cf20fce046a92a7e6491fcfe066 ]

xtensa frame size is larger than the frame size for almost all other
architectures.  This results in more than 50 "the frame size of <n> is
larger than 1024 bytes" errors when trying to build xtensa:allmodconfig.

Increase frame size for xtensa to 1536 bytes to avoid compile errors due
to frame size limits.

Link: https://lkml.kernel.org/r/20210912025235.3514761-1-linux@roeck-us.net
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Max Filippov <jcmvbkbc@gmail.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: 152fe65f300e ("Kconfig.debug: provide a little extra FRAME_WARN leeway when KASAN is enabled")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/Kconfig.debug | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index f610b47b74cc..42b6fff962b7 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -253,7 +253,7 @@ config FRAME_WARN
 	int "Warn for stack frames larger than (needs gcc 4.4)"
 	range 0 8192
 	default 2048 if GCC_PLUGIN_LATENT_ENTROPY
-	default 1536 if (!64BIT && PARISC)
+	default 1536 if (!64BIT && (PARISC || XTENSA))
 	default 1024 if (!64BIT && !PARISC)
 	default 2048 if 64BIT
 	help
-- 
2.35.1



