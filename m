Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB76845BE2A
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:42:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245743AbhKXMpL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:45:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:41826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345211AbhKXMlG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:41:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64DDE61216;
        Wed, 24 Nov 2021 12:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756680;
        bh=xqVALZlNQfC1BHtDBPx9Qlj03SZPArGR0HpXbatcAuw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nNPiRKUTPV0WBeg/R/nL3yE/spIuW04ssySUGqmcW6GE5OeQWicAY/Xie27sl1YFl
         9oXJif7Hi90g5ATpeXjvXcF2oboQzZ3Woi4IVvSO/3JiwOmzE7H+sOd8jeJMc9T47v
         sx1KZ1pqXl8/9gce4JlsIJgbkc7bZyZdNYFDnqoc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jackie Liu <liuyun01@kylinos.cn>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 140/251] ARM: s3c: irq-s3c24xx: Fix return value check for s3c24xx_init_intc()
Date:   Wed, 24 Nov 2021 12:56:22 +0100
Message-Id: <20211124115715.127598283@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jackie Liu <liuyun01@kylinos.cn>

[ Upstream commit 2aa717473ce96c93ae43a5dc8c23cedc8ce7dd9f ]

The s3c24xx_init_intc() returns an error pointer upon failure, not NULL.
let's add an error pointer check in s3c24xx_handle_irq.

s3c_intc[0] is not NULL or ERR, we can simplify the code.

Fixes: 1f629b7a3ced ("ARM: S3C24XX: transform irq handling into a declarative form")
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
Link: https://lore.kernel.org/r/20210901123557.1043953-1-liu.yun@linux.dev
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-s3c24xx.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-s3c24xx.c b/drivers/irqchip/irq-s3c24xx.c
index c25ce5af091ad..e92ab62cc87d9 100644
--- a/drivers/irqchip/irq-s3c24xx.c
+++ b/drivers/irqchip/irq-s3c24xx.c
@@ -368,11 +368,25 @@ static inline int s3c24xx_handle_intc(struct s3c_irq_intc *intc,
 asmlinkage void __exception_irq_entry s3c24xx_handle_irq(struct pt_regs *regs)
 {
 	do {
-		if (likely(s3c_intc[0]))
-			if (s3c24xx_handle_intc(s3c_intc[0], regs, 0))
-				continue;
+		/*
+		 * For platform based machines, neither ERR nor NULL can happen here.
+		 * The s3c24xx_handle_irq() will be set as IRQ handler iff this succeeds:
+		 *
+		 *    s3c_intc[0] = s3c24xx_init_intc()
+		 *
+		 * If this fails, the next calls to s3c24xx_init_intc() won't be executed.
+		 *
+		 * For DT machine, s3c_init_intc_of() could set the IRQ handler without
+		 * setting s3c_intc[0] only if it was called with num_ctrl=0. There is no
+		 * such code path, so again the s3c_intc[0] will have a valid pointer if
+		 * set_handle_irq() is called.
+		 *
+		 * Therefore in s3c24xx_handle_irq(), the s3c_intc[0] is always something.
+		 */
+		if (s3c24xx_handle_intc(s3c_intc[0], regs, 0))
+			continue;
 
-		if (s3c_intc[2])
+		if (!IS_ERR_OR_NULL(s3c_intc[2]))
 			if (s3c24xx_handle_intc(s3c_intc[2], regs, 64))
 				continue;
 
-- 
2.33.0



