Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1009044C6F4
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 19:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232772AbhKJSrL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 13:47:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:46134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232779AbhKJSqy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 13:46:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E914B61186;
        Wed, 10 Nov 2021 18:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636569846;
        bh=r+I0yYUM8yEbKKEHSQ24u59s6hdHh1qRdUBTYc/J15Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CHKKSbc4hzK21ZPNRkO58yn1gm0rHUYx9K4NopPbNOMjAWP+nkRJSX7IcUYSeJGhX
         aS689TRwAezCinmZIeN9cSYByzzVVmtdPSTRCLYo9TvgNlyDtrHQSJRZSGeUMOqqHH
         D31vJzOhybgxMKC3z/gd9ksesFNsccPfVbuw2rB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 4.4 02/19] ARM: 9120/1: Revert "amba: make use of -1 IRQs warn"
Date:   Wed, 10 Nov 2021 19:43:04 +0100
Message-Id: <20211110182001.335934058@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211110182001.257350381@linuxfoundation.org>
References: <20211110182001.257350381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Kefeng <wangkefeng.wang@huawei.com>

commit eb4f756915875b0ea0757751cd29841f0504d547 upstream.

After commit 77a7300abad7 ("of/irq: Get rid of NO_IRQ usage"),
no irq case has been removed, irq_of_parse_and_map() will return
0 in all cases when get error from parse and map an interrupt into
linux virq space.

amba_device_register() is only used on no-DT initialization, see
  s3c64xx_pl080_init()		arch/arm/mach-s3c/pl080.c
  ep93xx_init_devices()		arch/arm/mach-ep93xx/core.c

They won't set -1 to irq[0], so no need the warn.

This reverts commit 2eac58d5026e4ec8b17ff8b62877fea9e1d2f1b3.

Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/amba/bus.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/amba/bus.c
+++ b/drivers/amba/bus.c
@@ -360,9 +360,6 @@ int amba_device_add(struct amba_device *
 	void __iomem *tmp;
 	int i, ret;
 
-	WARN_ON(dev->irq[0] == (unsigned int)-1);
-	WARN_ON(dev->irq[1] == (unsigned int)-1);
-
 	ret = request_resource(parent, &dev->res);
 	if (ret)
 		goto err_out;


