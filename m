Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 089583E8216
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 20:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235964AbhHJSFn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 14:05:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:37208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236957AbhHJSDb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 14:03:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDA676124F;
        Tue, 10 Aug 2021 17:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617671;
        bh=TSSu0j/Y42OwHoJ9tyDjSyyjc/nHSELfyyCW/jHTfD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ae1G4KiMuFHwIW59nbIVYjUxPU7dzHo/pk/oIWssqqElppRh9CvoJDxlyRkAVgexD
         H0XjzOVPohMiq035MKYjOOtlOFlp55hcjwZ7OiOq+uY7b7pShfQo3LEMXJRr8NHl20
         ydVLTHzr/pQYfqk0Zjw0KdHzIgPQv3EiOKaoQnGM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.13 161/175] soc: ixp4xx/qmgr: fix invalid __iomem access
Date:   Tue, 10 Aug 2021 19:31:09 +0200
Message-Id: <20210810173006.264923245@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit a8eee86317f11e97990d755d4615c1c0db203d08 upstream.

Sparse reports a compile time warning when dereferencing an
__iomem pointer:

drivers/soc/ixp4xx/ixp4xx-qmgr.c:149:37: warning: dereference of noderef expression
drivers/soc/ixp4xx/ixp4xx-qmgr.c:153:40: warning: dereference of noderef expression
drivers/soc/ixp4xx/ixp4xx-qmgr.c:154:40: warning: dereference of noderef expression
drivers/soc/ixp4xx/ixp4xx-qmgr.c:174:38: warning: dereference of noderef expression
drivers/soc/ixp4xx/ixp4xx-qmgr.c:174:44: warning: dereference of noderef expression

Use __raw_readl() here for consistency with the rest of the file.
This should really get converted to some proper accessor, as the
__raw functions are not meant to be used in drivers, but the driver
has used these since the start, so for the moment, let's only fix
the warning.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: d4c9e9fc9751 ("IXP42x: Add QMgr support for IXP425 rev. A0 processors.")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/ixp4xx/ixp4xx-qmgr.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/soc/ixp4xx/ixp4xx-qmgr.c
+++ b/drivers/soc/ixp4xx/ixp4xx-qmgr.c
@@ -145,12 +145,12 @@ static irqreturn_t qmgr_irq1_a0(int irq,
 	/* ACK - it may clear any bits so don't rely on it */
 	__raw_writel(0xFFFFFFFF, &qmgr_regs->irqstat[0]);
 
-	en_bitmap = qmgr_regs->irqen[0];
+	en_bitmap = __raw_readl(&qmgr_regs->irqen[0]);
 	while (en_bitmap) {
 		i = __fls(en_bitmap); /* number of the last "low" queue */
 		en_bitmap &= ~BIT(i);
-		src = qmgr_regs->irqsrc[i >> 3];
-		stat = qmgr_regs->stat1[i >> 3];
+		src = __raw_readl(&qmgr_regs->irqsrc[i >> 3]);
+		stat = __raw_readl(&qmgr_regs->stat1[i >> 3]);
 		if (src & 4) /* the IRQ condition is inverted */
 			stat = ~stat;
 		if (stat & BIT(src & 3)) {
@@ -170,7 +170,8 @@ static irqreturn_t qmgr_irq2_a0(int irq,
 	/* ACK - it may clear any bits so don't rely on it */
 	__raw_writel(0xFFFFFFFF, &qmgr_regs->irqstat[1]);
 
-	req_bitmap = qmgr_regs->irqen[1] & qmgr_regs->statne_h;
+	req_bitmap = __raw_readl(&qmgr_regs->irqen[1]) &
+		     __raw_readl(&qmgr_regs->statne_h);
 	while (req_bitmap) {
 		i = __fls(req_bitmap); /* number of the last "high" queue */
 		req_bitmap &= ~BIT(i);


