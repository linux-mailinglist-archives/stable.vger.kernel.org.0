Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30B1D5B70EA
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232341AbiIMOeW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:34:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234282AbiIMOdx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:33:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F1AB21E31;
        Tue, 13 Sep 2022 07:19:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FE8D614C1;
        Tue, 13 Sep 2022 14:18:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 250B7C433D6;
        Tue, 13 Sep 2022 14:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078682;
        bh=D2HyxxSpSa5YTEjtXuzgAvSwiiYUGhrSmQTZJg4P7MA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mRW4/L4+Vx3lxy2EvQpysxTPBc9+mN4t4soeEXVwIJp9Cs6Tym5w3gLMxa6a5yzcO
         dn9oSc/ow7JLRQUyQAk/yHjStC+fmT8U/fQGC6OWOtbl1ZlI0i+IbuB090X6KL+vwX
         yikbJNZxb3+PN6PfX3TAxBtk0Kfl64W31sTMtfgs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 015/121] Revert "parisc: Show error if wrong 32/64-bit compiler is being used"
Date:   Tue, 13 Sep 2022 16:03:26 +0200
Message-Id: <20220913140357.998691943@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140357.323297659@linuxfoundation.org>
References: <20220913140357.323297659@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Helge Deller <deller@gmx.de>

[ Upstream commit b4b18f47f4f9682fbf5827682645da7c8dde8f80 ]

This reverts commit b160628e9ebcdc85d0db9d7f423c26b3c7c179d0.

There is no need any longer to have this sanity check, because the
previous commit ("parisc: Make CONFIG_64BIT available for ARCH=parisc64
only") prevents that CONFIG_64BIT is set if ARCH==parisc.

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/parisc/include/asm/bitops.h | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/parisc/include/asm/bitops.h b/arch/parisc/include/asm/bitops.h
index 5779d463b341f..aa4e883431c1a 100644
--- a/arch/parisc/include/asm/bitops.h
+++ b/arch/parisc/include/asm/bitops.h
@@ -12,14 +12,6 @@
 #include <asm/barrier.h>
 #include <linux/atomic.h>
 
-/* compiler build environment sanity checks: */
-#if !defined(CONFIG_64BIT) && defined(__LP64__)
-#error "Please use 'ARCH=parisc' to build the 32-bit kernel."
-#endif
-#if defined(CONFIG_64BIT) && !defined(__LP64__)
-#error "Please use 'ARCH=parisc64' to build the 64-bit kernel."
-#endif
-
 /* See http://marc.theaimsgroup.com/?t=108826637900003 for discussion
  * on use of volatile and __*_bit() (set/clear/change):
  *	*_bit() want use of volatile.
-- 
2.35.1



