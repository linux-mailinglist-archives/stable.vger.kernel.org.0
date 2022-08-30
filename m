Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 184395A699C
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 19:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbiH3RVS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 13:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231282AbiH3RUk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 13:20:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E38971839B;
        Tue, 30 Aug 2022 10:19:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1513761785;
        Tue, 30 Aug 2022 17:19:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9F0DC433C1;
        Tue, 30 Aug 2022 17:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661879988;
        bh=xGNcFDDt6V15LLpcLKZBhSPZxEQpN6bnSJ9NyfqZQE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hF84J7lNPgipjo99f7oG/hZDyL9DQ+IBqLY/GxPXMp/SxnO3KQN22N3MbW4B23K9v
         fH9nXXSCo4XhhSMRMAvuW8p+OjuZNDbqH4Elbp7DXG48bCZ7bZCW+FVQdYpxJz2vsC
         VyR+BZHlXb9IOcd9BFRuaf0DLmiVwntHP1DLP4oG1NYFTOm3dJmE/Or4aRzOidi6Qc
         LZZQR3ju5sE54nDxMFStnwEDUQiUfLKw4qN8VNl4mXywkHXGHWz8dewFRfkYzyEvz1
         bXAuiIgvR9LonzrjxQsvU/g4SWfTCYXX8gtELaB6SKXAHNpI5zVM49j6KJ+KeGtfK7
         H3MTfUkiNa6Jg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>,
        James.Bottomley@HansenPartnership.com, yury.norov@gmail.com,
        geert@linux-m68k.org, linux-parisc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 15/33] Revert "parisc: Show error if wrong 32/64-bit compiler is being used"
Date:   Tue, 30 Aug 2022 13:18:06 -0400
Message-Id: <20220830171825.580603-15-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220830171825.580603-1-sashal@kernel.org>
References: <20220830171825.580603-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 56ffd260c669b..0ec9cfc5131fc 100644
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

