Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A58B0411C76
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245412AbhITRKB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:10:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:34918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346518AbhITRHl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:07:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28CDB615A2;
        Mon, 20 Sep 2021 16:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156939;
        bh=vn5V48WHea7ZI1gUMJLNHFexHBmcof4BOoIcF9NdWyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f7QCuNvuf8M3OYoZEOM01SGQ7kjqXtu3b/oZzV7CMnu2xK57FBUObLed1piSCemFK
         qKVjL/jPNjYPNSN1KrxtPGqpBRJhmlkOJCxCSNXrBwgjwx0aGLGfzXk3gw44YBk2PI
         Eiqwofl4VbzsWJvReaps0pSAMnIXboCrkK1S0u3Y=
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
Subject: [PATCH 4.9 156/175] ptp: dp83640: dont define PAGE0
Date:   Mon, 20 Sep 2021 18:43:25 +0200
Message-Id: <20210920163923.174115160@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163918.068823680@linuxfoundation.org>
References: <20210920163918.068823680@linuxfoundation.org>
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
@@ -4,7 +4,7 @@
 #ifndef HAVE_DP83640_REGISTERS
 #define HAVE_DP83640_REGISTERS
 
-#define PAGE0                     0x0000
+/* #define PAGE0                  0x0000 */
 #define PHYCR2                    0x001c /* PHY Control Register 2 */
 
 #define PAGE4                     0x0004


