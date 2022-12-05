Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A77EF643276
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233385AbiLET0k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:26:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234060AbiLET0P (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:26:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D0C4B76
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:22:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BB22B81201
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:22:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A654C4347C;
        Mon,  5 Dec 2022 19:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268161;
        bh=J9ytkmt0aDs0PRsYNxaPyLbK6dU3PFHYq+1koA8bbJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G4hcCLehMSSH+TxiHwj0kAW/j54g06ehbZs7obDAIwU0lu15Ce5EC5SUNokZaeKFI
         jx1cTpUrQdE22IkNsCmUzgZjEtFvAsq6MeVBQmRwFdCiaDM0P7h/Ql7BRoVaEGA8rR
         wcP/DDssXYUYvg6VsrZMkglGGM3y8a4FfWpV6Xyw=
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
Subject: [PATCH 4.19 095/105] xtensa: increase size of gcc stack frame check
Date:   Mon,  5 Dec 2022 20:10:07 +0100
Message-Id: <20221205190806.328319187@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.124472741@linuxfoundation.org>
References: <20221205190803.124472741@linuxfoundation.org>
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
index 556aae95d69b..12fc801811d3 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -224,7 +224,7 @@ config FRAME_WARN
 	range 0 8192
 	default 3072 if KASAN_EXTRA
 	default 2048 if GCC_PLUGIN_LATENT_ENTROPY
-	default 1536 if (!64BIT && PARISC)
+	default 1536 if (!64BIT && (PARISC || XTENSA))
 	default 1024 if (!64BIT && !PARISC)
 	default 2048 if 64BIT
 	help
-- 
2.35.1



