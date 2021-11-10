Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80C9044C72A
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 19:46:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232548AbhKJSsu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 13:48:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:47546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232955AbhKJSsA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 13:48:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8F4E61208;
        Wed, 10 Nov 2021 18:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636569912;
        bh=HuDl2VmNCFlsyIuUYxBXAxFGAKKb1Lw0dudW2PjvPHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y/ywbXGPu/dZ3spk9BZZgRD2VEAk0GHQJZlL2YvQyFYHgVdnzs5k2cnm+m0tWXI2D
         Jg/rsys3S8O1ZiUHDFdgirZWE55GIiV8L5aypw298Inr+V3oM1vR9DpnsxQNyRgGbL
         HkidqK8N2TX8h4F7TT8ZbAvoQGtA33GbqmQdFbU0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 4.9 04/22] ARM: 9120/1: Revert "amba: make use of -1 IRQs warn"
Date:   Wed, 10 Nov 2021 19:43:11 +0100
Message-Id: <20211110182001.729857331@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211110182001.579561273@linuxfoundation.org>
References: <20211110182001.579561273@linuxfoundation.org>
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
@@ -356,9 +356,6 @@ static int amba_device_try_add(struct am
 	void __iomem *tmp;
 	int i, ret;
 
-	WARN_ON(dev->irq[0] == (unsigned int)-1);
-	WARN_ON(dev->irq[1] == (unsigned int)-1);
-
 	ret = request_resource(parent, &dev->res);
 	if (ret)
 		goto err_out;


