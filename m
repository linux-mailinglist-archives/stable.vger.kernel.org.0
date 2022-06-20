Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC77551D5F
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349064AbiFTNvM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350950AbiFTNuD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:50:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD52E30F45;
        Mon, 20 Jun 2022 06:18:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8AD2DB811FC;
        Mon, 20 Jun 2022 13:17:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D998EC341C0;
        Mon, 20 Jun 2022 13:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655731036;
        bh=3Ln4hEtHTP/Iye9VV536yRYzaH7q597arnp1pdMkgQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QC4M9Ts+fY88mbUJga1U1XazkxOae+KetWFJT84ag3vvjv79VPqQx3AFyjl3VYoqk
         mhEEHQ1ZqjtfvcOO9Cp2n3MfFS4eYgKsMmy8d/eOWcEN0Hw9wMOHxjQ1tb3zYO194X
         EwqPOFIFUU41zCIPiO6NjPHo5U8K1TOenckioyqY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergmann <arnd@arndb.de>, Helge Deller <deller@gmx.de>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.4 133/240] parisc: define get_cycles macro for arch-override
Date:   Mon, 20 Jun 2022 14:50:34 +0200
Message-Id: <20220620124742.864923302@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124737.799371052@linuxfoundation.org>
References: <20220620124737.799371052@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit 8865bbe6ba1120e67f72201b7003a16202cd42be upstream.

PA-RISC defines a get_cycles() function, but it does not do the usual
`#define get_cycles get_cycles` dance, making it impossible for generic
code to see if an arch-specific function was defined. While the
get_cycles() ifdef is not currently used, the following timekeeping
patch in this series will depend on the macro existing (or not existing)
when defining random_get_entropy().

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Acked-by: Helge Deller <deller@gmx.de>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/include/asm/timex.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/parisc/include/asm/timex.h
+++ b/arch/parisc/include/asm/timex.h
@@ -12,9 +12,10 @@
 
 typedef unsigned long cycles_t;
 
-static inline cycles_t get_cycles (void)
+static inline cycles_t get_cycles(void)
 {
 	return mfctl(16);
 }
+#define get_cycles get_cycles
 
 #endif


