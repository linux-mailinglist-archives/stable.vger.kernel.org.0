Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72B724FD18A
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242583AbiDLG7B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352513AbiDLGz4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:55:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A979641337;
        Mon, 11 Apr 2022 23:45:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B575DB818C8;
        Tue, 12 Apr 2022 06:45:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F19DC385A1;
        Tue, 12 Apr 2022 06:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745950;
        bh=tu0v6OA/f0IhRi7ITV468r8y59OEfqWosZdsp4d1ZN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Ho142AK/oUWGz6aiNTl6StMgNlDqhV2zax2ZMJju5LJlvxUw/+o7JVsNAyAvr5T6
         iC5Ii0/8VywbDwQni8OAIXZnghFzpOoZ78vlkJVMnOyuXQz4SvwKCjAc3xR2u+GhqP
         rXhxjdJYm9j0SK6LqgnxXVPBytShErArbb86XgbI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Feng Tang <feng.tang@intel.com>, Guo Ren <guoren@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 107/277] lib/Kconfig.debug: add ARCH dependency for FUNCTION_ALIGN option
Date:   Tue, 12 Apr 2022 08:28:30 +0200
Message-Id: <20220412062945.136856860@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

[ Upstream commit 1bf18da62106225dbc47aab41efee2aeb99caccd ]

0Day robots reported there is compiling issue for 'csky' ARCH when
CONFIG_DEBUG_FORCE_DATA_SECTION_ALIGNED is enabled [1]:

All errors (new ones prefixed by >>):

   {standard input}: Assembler messages:
>> {standard input}:2277: Error: pcrel offset for branch to .LS000B too far (0x3c)

Which was discussed in [2].  And as there is no solution for csky yet, add
some dependency for this config to limit it to several ARCHs which have no
compiling issue so far.

[1]. https://lore.kernel.org/lkml/202202271612.W32UJAj2-lkp@intel.com/
[2]. https://www.spinics.net/lists/linux-kbuild/msg30298.html

Link: https://lkml.kernel.org/r/20220304021100.GN4548@shbuild999.sh.intel.com
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: Guo Ren <guoren@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/Kconfig.debug | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 2a9b6dcdac4f..55e89b237b6f 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -414,7 +414,8 @@ config SECTION_MISMATCH_WARN_ONLY
 	  If unsure, say Y.
 
 config DEBUG_FORCE_FUNCTION_ALIGN_64B
-	bool "Force all function address 64B aligned" if EXPERT
+	bool "Force all function address 64B aligned"
+	depends on EXPERT && (X86_64 || ARM64 || PPC32 || PPC64 || ARC)
 	help
 	  There are cases that a commit from one domain changes the function
 	  address alignment of other domains, and cause magic performance
-- 
2.35.1



