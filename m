Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8346541231B
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377309AbhITSVH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:21:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:40364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1376429AbhITSSS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:18:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8203632A0;
        Mon, 20 Sep 2021 17:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158558;
        bh=cdIMnGOF4CkU42daacZN2R1isEuvbkTI+FGt9W79hLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GiIqjXjaq0wQt4zVrwN3wbV11b3rkP069CpNOc1PDKo8ZNyt/zUNH9smn7DJ5FnCI
         HPY+sz4stVewENuDeoLTd7miFyvWGOqADnMzPr6LcjV8X+KkmCc+CEIvUER73tFol6
         h9MVytVuuxFciScGeAM57MOY0h9RAOUZdrpHGEUs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        John Stultz <john.stultz@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 211/260] ptp: dp83640: dont define PAGE0
Date:   Mon, 20 Sep 2021 18:43:49 +0200
Message-Id: <20210920163938.276868167@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

commit 7366c23ff492ad260776a3ee1aaabba9fc773a8b upstream.

Building dp83640.c on arch/parisc/ produces a build warning for
PAGE0 being redefined. Since the macro is not used in the dp83640
driver, just make it a comment for documentation purposes.

In file included from ../drivers/net/phy/dp83640.c:23:
../drivers/net/phy/dp83640_reg.h:8: warning: "PAGE0" redefined
    8 | #define PAGE0                     0x0000
                 from ../drivers/net/phy/dp83640.c:11:
../arch/parisc/include/asm/page.h:187: note: this is the location of the previous definition
  187 | #define PAGE0   ((struct zeropage *)__PAGE_OFFSET)

Fixes: cb646e2b02b2 ("ptp: Added a clock driver for the National Semiconductor PHYTER.")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Richard Cochran <richard.cochran@omicron.at>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20210913220605.19682-1-rdunlap@infradead.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/dp83640_reg.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/phy/dp83640_reg.h
+++ b/drivers/net/phy/dp83640_reg.h
@@ -5,7 +5,7 @@
 #ifndef HAVE_DP83640_REGISTERS
 #define HAVE_DP83640_REGISTERS
 
-#define PAGE0                     0x0000
+/* #define PAGE0                  0x0000 */
 #define PHYCR2                    0x001c /* PHY Control Register 2 */
 
 #define PAGE4                     0x0004


