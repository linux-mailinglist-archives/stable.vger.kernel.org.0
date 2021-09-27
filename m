Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 415C4419AF8
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236401AbhI0ROo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:14:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:56112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236859AbhI0RNT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:13:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B579611EF;
        Mon, 27 Sep 2021 17:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762551;
        bh=vCQBPIh7koiFQ78SN6YCIIM9b2GHDSIeSVZdr1JiASk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VdkcbY0gVN3E2Z3d0Hf14cKqv9Jkt+wjNavDQ2T9QLExZb1NsQijGfbRv4QOG1P9Z
         pqenNQpx8WtT37T/TJIad4sUdQyZSsjPc2w3ATetULPyXkYmqrrXGtG2gNvJvPSrlI
         0ZUJacy4dx6mD/oEDPV8ah+SwcWbIiLjWCqekU7U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kaige Fu <kaige.fu@linux.alibaba.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 067/103] irqchip/gic-v3-its: Fix potential VPE leak on error
Date:   Mon, 27 Sep 2021 19:02:39 +0200
Message-Id: <20210927170228.097563716@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
References: <20210927170225.702078779@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kaige Fu <kaige.fu@linux.alibaba.com>

[ Upstream commit 280bef512933b2dda01d681d8cbe499b98fc5bdd ]

In its_vpe_irq_domain_alloc, when its_vpe_init() returns an error,
there is an off-by-one in the number of VPEs to be freed.

Fix it by simply passing the number of VPEs allocated, which is the
index of the loop iterating over the VPEs.

Fixes: 7d75bbb4bc1a ("irqchip/gic-v3-its: Add VPE irq domain allocation/teardown")
Signed-off-by: Kaige Fu <kaige.fu@linux.alibaba.com>
[maz: fixed commit message]
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/d9e36dee512e63670287ed9eff884a5d8d6d27f2.1631672311.git.kaige.fu@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 4069c215328b..95e0b82b6c66 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -4489,7 +4489,7 @@ static int its_vpe_irq_domain_alloc(struct irq_domain *domain, unsigned int virq
 
 	if (err) {
 		if (i > 0)
-			its_vpe_irq_domain_free(domain, virq, i - 1);
+			its_vpe_irq_domain_free(domain, virq, i);
 
 		its_lpi_free(bitmap, base, nr_ids);
 		its_free_prop_table(vprop_page);
-- 
2.33.0



