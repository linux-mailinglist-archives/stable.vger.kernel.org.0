Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCA7B59D837
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242131AbiHWJik (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:38:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351479AbiHWJho (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:37:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F277298A6D;
        Tue, 23 Aug 2022 01:40:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF3E061326;
        Tue, 23 Aug 2022 08:39:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2CA7C433D6;
        Tue, 23 Aug 2022 08:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243996;
        bh=YLHITOvYu0lt7iEImGEtaN+nTdRoAlJHZbNZO7E2YxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MbOxqPD1D+vkF1Pcbvh0w7RJP1SYtbGXExf9+2pFKo/85crafWQOZRaYCs+0ZLEtf
         oKLjkYCryIYe3vpm5Adi9VT92WfF/tBOZwrvcXyTmTIOkroSbD32UQPsvfEeKW1V7+
         MNKtzPnqVcYRywP6W/AteWF14CHnoQW7blQu8hho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Yury Norov <yury.norov@gmail.com>
Subject: [PATCH 4.14 032/229] ia64, processor: fix -Wincompatible-pointer-types in ia64_get_irr()
Date:   Tue, 23 Aug 2022 10:23:13 +0200
Message-Id: <20220823080054.666162644@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
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
@@ -552,7 +552,7 @@ ia64_get_irr(unsigned int vector)
 {
 	unsigned int reg = vector / 64;
 	unsigned int bit = vector % 64;
-	u64 irr;
+	unsigned long irr;
 
 	switch (reg) {
 	case 0: irr = ia64_getreg(_IA64_REG_CR_IRR0); break;


