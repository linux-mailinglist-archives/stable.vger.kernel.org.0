Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6E94724EE
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:39:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234906AbhLMJjl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:39:41 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51834 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233140AbhLMJiQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:38:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5504FB80CAB;
        Mon, 13 Dec 2021 09:38:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0CFEC00446;
        Mon, 13 Dec 2021 09:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388294;
        bh=IEH0SgXW32ZJv2QeLrjSktkpfigNy0ReA7GV2QSSPMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a/uAdh3z7b/IVJ1aRmsKPch5JY9CGxgQnRn00DUkTYYl94OsuYShsXnVNW3dN6DPk
         wJiVHM4tc9uIOsHLdP4MerMSTef4SuTyxnEWFushkjuOlPHMNyWfXTbKLuVr2w8vxU
         gYIWcDmg5YnXzbleQ/WmV/sZDQ4C7ClY+qohb/L8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Murzin <vladimir.murzin@arm.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 4.14 53/53] irqchip: nvic: Fix offset for Interrupt Priority Offsets
Date:   Mon, 13 Dec 2021 10:30:32 +0100
Message-Id: <20211213092930.121094206@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092928.349556070@linuxfoundation.org>
References: <20211213092928.349556070@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Murzin <vladimir.murzin@arm.com>

commit c5e0cbe2858d278a27d5b3fe31890aea5be064c4 upstream.

According to ARM(v7M) ARM Interrupt Priority Offsets located at
0xE000E400-0xE000E5EC, while 0xE000E300-0xE000E33C covers read-only
Interrupt Active Bit Registers

Fixes: 292ec080491d ("irqchip: Add support for ARMv7-M NVIC")
Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20211201110259.84857-1-vladimir.murzin@arm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-nvic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/irqchip/irq-nvic.c
+++ b/drivers/irqchip/irq-nvic.c
@@ -29,7 +29,7 @@
 
 #define NVIC_ISER		0x000
 #define NVIC_ICER		0x080
-#define NVIC_IPR		0x300
+#define NVIC_IPR		0x400
 
 #define NVIC_MAX_BANKS		16
 /*


