Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDC326433F2
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234737AbiLETlO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:41:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234453AbiLETkr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:40:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B3F425E98
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:38:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4FCE4B811E3
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:38:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA303C433C1;
        Mon,  5 Dec 2022 19:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670269092;
        bh=Ogndp6nQiho47cNepyN4MEXpBoNwyEqQj1W99YIIH5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ovRHOWTbCUyGhq+Wu5n+FRQDHKhetKss0nnWaBVqtXiJ/mSs/n9RJOYV3RrH3q+w1
         Ku4g4B7sD1J6B5wbnuv9eHA5UflBLFBTnFo6KrKOF82lk9innGwMMiNQbZKLloaaN5
         5oPlYcKK8yMWFFg2TuXDoTpx9zsVxAH5L/aF66No=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 105/120] parisc: Increase FRAME_WARN to 2048 bytes on parisc
Date:   Mon,  5 Dec 2022 20:10:45 +0100
Message-Id: <20221205190809.699223225@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
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

From: Helge Deller <deller@gmx.de>

[ Upstream commit 8d192bec534bd5b778135769a12e5f04580771f7 ]

PA-RISC uses a much bigger frame size for functions than other
architectures. So increase it to 2048 for 32- and 64-bit kernels.
This fixes e.g. a warning in lib/xxhash.c.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Stable-dep-of: 152fe65f300e ("Kconfig.debug: provide a little extra FRAME_WARN leeway when KASAN is enabled")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/Kconfig.debug | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 027ab190796f..23b7b1fccc54 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -352,8 +352,9 @@ config FRAME_WARN
 	int "Warn for stack frames larger than"
 	range 0 8192
 	default 2048 if GCC_PLUGIN_LATENT_ENTROPY
-	default 1536 if (!64BIT && (PARISC || XTENSA))
-	default 1024 if (!64BIT && !PARISC)
+	default 2048 if PARISC
+	default 1536 if (!64BIT && XTENSA)
+	default 1024 if !64BIT
 	default 2048 if 64BIT
 	help
 	  Tell gcc to warn at build time for stack frames larger than this.
-- 
2.35.1



