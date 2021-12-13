Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44C304726C3
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:57:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238707AbhLMJyQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:54:16 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:42842 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237765AbhLMJwG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:52:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2978BCE0E6B;
        Mon, 13 Dec 2021 09:52:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D40A7C00446;
        Mon, 13 Dec 2021 09:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389123;
        bh=ENtvcfGoN/unKFhE/o6vEBmtoYNSaCbW9KlNes6X7Z0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HUfA6OZtnk1A+Qzdaa3yM8ZZFZoAOA4LEHZWtgV9Y/pmfk4+AIMYwlGuct5TVjQMd
         bJWwIDQO7e5CRQwzpeSH7lW5BsQAz5IL/fmZefly2Fq0AkuvPrA0sE3rHs5Q3kHkUS
         QxcBZ4HToLT2xuuGntFq0Qh8R9kV27xoPno8B+w8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Murzin <vladimir.murzin@arm.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.10 126/132] irqchip: nvic: Fix offset for Interrupt Priority Offsets
Date:   Mon, 13 Dec 2021 10:31:07 +0100
Message-Id: <20211213092943.424122985@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
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
@@ -26,7 +26,7 @@
 
 #define NVIC_ISER		0x000
 #define NVIC_ICER		0x080
-#define NVIC_IPR		0x300
+#define NVIC_IPR		0x400
 
 #define NVIC_MAX_BANKS		16
 /*


