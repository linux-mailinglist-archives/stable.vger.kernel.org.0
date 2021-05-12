Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55A4337C883
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233910AbhELQJH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:09:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:49158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237768AbhELQEP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:04:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E18A561C3F;
        Wed, 12 May 2021 15:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833660;
        bh=e3OOcQJpqFZGaR6u1gY8aZUXjS+i30BuumWbEPhDvuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p/AXVlVFpCFuB9tb9njwJlr658RyxvWKVjTENZQX+Dn4V0FOdGSY1Pw84ZTeXRzOi
         ClrYJgQvscAaZUptcW9CyO9LlqU31S+eNKte9a2jm6VK49yDzGJxg3zI53/D7y1dLW
         Bf5Qto1NK+oPl8l8S3YLA5+N/i8BCopKNBeZ9w4I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 238/601] irqchip/gic-v3: Fix OF_BAD_ADDR error handling
Date:   Wed, 12 May 2021 16:45:15 +0200
Message-Id: <20210512144835.669850166@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 8e13d96670a4c050d4883e6743a9e9858e5cfe10 ]

When building with extra warnings enabled, clang points out a
mistake in the error handling:

drivers/irqchip/irq-gic-v3-mbi.c:306:21: error: result of comparison of constant 18446744073709551615 with expression of type 'phys_addr_t' (aka 'unsigned int') is always false [-Werror,-Wtautological-constant-out-of-range-compare]
                if (mbi_phys_base == OF_BAD_ADDR) {

Truncate the constant to the same type as the variable it gets compared
to, to shut make the check work and void the warning.

Fixes: 505287525c24 ("irqchip/gic-v3: Add support for Message Based Interrupts as an MSI controller")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210323131842.2773094-1-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3-mbi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic-v3-mbi.c b/drivers/irqchip/irq-gic-v3-mbi.c
index 563a9b366294..e81e89a81cb5 100644
--- a/drivers/irqchip/irq-gic-v3-mbi.c
+++ b/drivers/irqchip/irq-gic-v3-mbi.c
@@ -303,7 +303,7 @@ int __init mbi_init(struct fwnode_handle *fwnode, struct irq_domain *parent)
 	reg = of_get_property(np, "mbi-alias", NULL);
 	if (reg) {
 		mbi_phys_base = of_translate_address(np, reg);
-		if (mbi_phys_base == OF_BAD_ADDR) {
+		if (mbi_phys_base == (phys_addr_t)OF_BAD_ADDR) {
 			ret = -ENXIO;
 			goto err_free_mbi;
 		}
-- 
2.30.2



