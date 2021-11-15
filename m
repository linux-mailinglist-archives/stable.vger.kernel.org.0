Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78FA3450BDF
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:28:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237951AbhKORay (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:30:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:50868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238001AbhKOR2h (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:28:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AEE4763290;
        Mon, 15 Nov 2021 17:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996759;
        bh=Xc+C6RMrFdCkw73NMWJZhOfv2KdCdFr4HRvhdW/MJHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B/BhnOq7w7V0aKVCRPWjhYDGQVs7GuGqFgErI52gJEVsGaXroqO+5EJGP+x8LMIoS
         T02pLPKn1okybHZ4WJrF6muIQjfNsUEecJmpOM7NCrQy+JP/PRtzDKcPKe8E5cI64t
         cwb53wf2uUrdtrcYvH3M6Z92cB2/CD9uZT1b7zds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jackie Liu <liuyun01@kylinos.cn>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 258/355] ARM: s3c: irq-s3c24xx: Fix return value check for s3c24xx_init_intc()
Date:   Mon, 15 Nov 2021 18:03:02 +0100
Message-Id: <20211115165322.085948637@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
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
index d2031fecc3861..5e97ae54782d6 100644
--- a/drivers/irqchip/irq-s3c24xx.c
+++ b/drivers/irqchip/irq-s3c24xx.c
@@ -359,11 +359,25 @@ static inline int s3c24xx_handle_intc(struct s3c_irq_intc *intc,
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



