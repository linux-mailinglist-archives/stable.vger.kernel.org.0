Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A17EF62213
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387884AbfGHPWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:22:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:48300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730971AbfGHPWF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:22:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEE2921743;
        Mon,  8 Jul 2019 15:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599324;
        bh=MrBvBHU4mwEA3WSIv/aF/ziLSZLflftoJo/8fMLDxEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bD9mIY6DY1K8kGMJgbVKVMN8c3q8ZRpQyh+3cK53WnsKqAF+8lqArSJvnjjQLY9zY
         dCvPBb2mfh+Da3PqBUCIBpEDgVCjR/ibKMxwymTLmDBW6itH4AXpI3d2dDwhqnpaIj
         g00ikhG5c6zHWVINWUgYPe7kZMhfXsn02aQOKtdA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 078/102] mfd: omap-usb-tll: Fix register offsets
Date:   Mon,  8 Jul 2019 17:13:11 +0200
Message-Id: <20190708150530.489167862@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150525.973820964@linuxfoundation.org>
References: <20190708150525.973820964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 993dc737c0996c163325961fb62a0ed9fd0308b4 ]

gcc-8 notices that the register number calculation is wrong
when the offset is an 'u8' but the number is larger than 256:

drivers/mfd/omap-usb-tll.c: In function 'omap_tll_init':
drivers/mfd/omap-usb-tll.c:90:46: error: overflow in conversion from 'int' to 'u8 {aka unsigned char}' chages value from 'i * 256 + 2070' to '22' [-Werror=overflow]

This addresses it by always using a 32-bit offset number for
the register. This is apparently an old problem that previous
compilers did not find.

Fixes: 16fa3dc75c22 ("mfd: omap-usb-tll: HOST TLL platform driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/omap-usb-tll.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/omap-usb-tll.c b/drivers/mfd/omap-usb-tll.c
index 9d167c9af2c6..e153276ed954 100644
--- a/drivers/mfd/omap-usb-tll.c
+++ b/drivers/mfd/omap-usb-tll.c
@@ -131,12 +131,12 @@ static inline u32 usbtll_read(void __iomem *base, u32 reg)
 	return readl_relaxed(base + reg);
 }
 
-static inline void usbtll_writeb(void __iomem *base, u8 reg, u8 val)
+static inline void usbtll_writeb(void __iomem *base, u32 reg, u8 val)
 {
 	writeb_relaxed(val, base + reg);
 }
 
-static inline u8 usbtll_readb(void __iomem *base, u8 reg)
+static inline u8 usbtll_readb(void __iomem *base, u32 reg)
 {
 	return readb_relaxed(base + reg);
 }
-- 
2.20.1



