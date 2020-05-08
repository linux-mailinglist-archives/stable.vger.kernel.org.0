Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13A0F1CAAD3
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbgEHMhL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:37:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:51336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728018AbgEHMhK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:37:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 721CD21835;
        Fri,  8 May 2020 12:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941429;
        bh=rBlSr5NBHfZ/N935rLEslrLFisg4sr5EccNQDxUtH+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S9IbPLXKtSNk20Ao7Q5HByk0DowwFdXMH9u5wIYHKZ66jx/vxt/1KyGfzoeHOs8qE
         M27TNaSRMnzfsifmdLa2ZBWHkvG4qSWmRDHvZO5P0uRbCJLPBeqeSufFxu0PZ/2dEM
         JNKQGEWVdP/DCl2pJadMK6mhUPp7SoBVth0WxAfA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        David Daney <david.daney@cavium.com>,
        Rob Herring <robh@kernel.org>,
        Marc Zyngier <marc.zyngier@arm.com>, linux-mips@linux-mips.org,
        kernel-janitors@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 4.4 029/312] MIPS: Octeon: Off by one in octeon_irq_gpio_map()
Date:   Fri,  8 May 2020 14:30:20 +0200
Message-Id: <20200508123126.529643159@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 008d0cf1ec69ec6d2c08f2d23aff2b67cbe5d2af upstream.

It should be >= ARRAY_SIZE() instead of > ARRAY_SIZE().

Fixes: 64b139f97c01 ('MIPS: OCTEON: irq: add CIB and other fixes')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: David Daney <david.daney@cavium.com>
Cc: Rob Herring <robh@kernel.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-mips@linux-mips.org
Cc: kernel-janitors@vger.kernel.org
Patchwork: https://patchwork.linux-mips.org/patch/13813/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/cavium-octeon/octeon-irq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/cavium-octeon/octeon-irq.c
+++ b/arch/mips/cavium-octeon/octeon-irq.c
@@ -1220,7 +1220,7 @@ static int octeon_irq_gpio_map(struct ir
 
 	line = (hw + gpiod->base_hwirq) >> 6;
 	bit = (hw + gpiod->base_hwirq) & 63;
-	if (line > ARRAY_SIZE(octeon_irq_ciu_to_irq) ||
+	if (line >= ARRAY_SIZE(octeon_irq_ciu_to_irq) ||
 		octeon_irq_ciu_to_irq[line][bit] != 0)
 		return -EINVAL;
 


