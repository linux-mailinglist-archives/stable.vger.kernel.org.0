Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93A52599F0E
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350359AbiHSPvh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 11:51:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350535AbiHSPuv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 11:50:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4497C742B;
        Fri, 19 Aug 2022 08:48:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58B5A61702;
        Fri, 19 Aug 2022 15:48:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67567C433D6;
        Fri, 19 Aug 2022 15:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924105;
        bh=TV0z72+3mSdWZU9PHTH7EIN3XB5gMzathmY268PHYYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xawt8wZYU3YjytYRZlDOdHllwbsd4eX5Yr2WPVpH4L9i3CA9spiIWMstnL1dFS+5z
         dlQHaGQkNNsnquJ4k03jFvrbOWKqkYmDvv6+TH3k3eWW83bbCffHWrN/1nH5t/AEYz
         Ux7gmyav14c3i/WDEe6Ruj4YgAJIxkVwTbi7phrQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Yury Norov <yury.norov@gmail.com>
Subject: [PATCH 5.10 058/545] ia64, processor: fix -Wincompatible-pointer-types in ia64_get_irr()
Date:   Fri, 19 Aug 2022 17:37:08 +0200
Message-Id: <20220819153831.827211433@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

From: Alexander Lobakin <alexandr.lobakin@intel.com>

commit e5a16a5c4602c119262f350274021f90465f479d upstream.

test_bit(), as any other bitmap op, takes `unsigned long *` as a
second argument (pointer to the actual bitmap), as any bitmap
itself is an array of unsigned longs. However, the ia64_get_irr()
code passes a ref to `u64` as a second argument.
This works with the ia64 bitops implementation due to that they
have `void *` as the second argument and then cast it later on.
This works with the bitmap API itself due to that `unsigned long`
has the same size on ia64 as `u64` (`unsigned long long`), but
from the compiler PoV those two are different.
Define @irr as `unsigned long` to fix that. That implies no
functional changes. Has been hidden for 16 years!

Fixes: a58786917ce2 ("[IA64] avoid broken SAL_CACHE_FLUSH implementations")
Cc: stable@vger.kernel.org # 2.6.16+
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/ia64/include/asm/processor.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/ia64/include/asm/processor.h
+++ b/arch/ia64/include/asm/processor.h
@@ -542,7 +542,7 @@ ia64_get_irr(unsigned int vector)
 {
 	unsigned int reg = vector / 64;
 	unsigned int bit = vector % 64;
-	u64 irr;
+	unsigned long irr;
 
 	switch (reg) {
 	case 0: irr = ia64_getreg(_IA64_REG_CR_IRR0); break;


