Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 824B9472429
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:34:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234009AbhLMJee (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:34:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234126AbhLMJeA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:34:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30A16C0698D3;
        Mon, 13 Dec 2021 01:33:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF1B2B80E0B;
        Mon, 13 Dec 2021 09:33:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4056EC341C8;
        Mon, 13 Dec 2021 09:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388035;
        bh=IEH0SgXW32ZJv2QeLrjSktkpfigNy0ReA7GV2QSSPMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J/bTtCPjfw43MmPCTGGfP/1l6ANBsNm2mL6H9CiPcjr2Jb0FJ3Ac9FpcRw/TCsyXE
         Nb1I4WjdN3bVBMS5aw74z1Aa+nz+yxTw6iEiFrMV8NSHB6EfJXxjxJhtoCwtCzrrZn
         0bhVbCldLfSjhCZOGi7Qs/HT4q8dXBH/RSjLg4w8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Murzin <vladimir.murzin@arm.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 4.4 37/37] irqchip: nvic: Fix offset for Interrupt Priority Offsets
Date:   Mon, 13 Dec 2021 10:30:15 +0100
Message-Id: <20211213092926.590971008@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092925.380184671@linuxfoundation.org>
References: <20211213092925.380184671@linuxfoundation.org>
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


