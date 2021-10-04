Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CABF420CCC
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235037AbhJDNJe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:09:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:39430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235560AbhJDNIi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:08:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7BB161B4C;
        Mon,  4 Oct 2021 13:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352548;
        bh=7ie3UZy2F3R5XAAJKmnVEn2D/Hf5BWycaT8q0xuxwJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OeZup8xQ4owmfwgpjqZTJIj5OUnnoMX1VH2h/IElQurz0EBDD4Ufini5N/9deBd62
         XtX5ET+lIMJi6p6PADs1lqb8Rvbv4xiQgyr3Fo02u7yf317/Qxgy7NNsuFwG5c/xR4
         cyyZoeeBEAbTZz+QHQ/7duXPu5B2WO+hNBTopZ0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kaige Fu <kaige.fu@linux.alibaba.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 30/95] irqchip/gic-v3-its: Fix potential VPE leak on error
Date:   Mon,  4 Oct 2021 14:52:00 +0200
Message-Id: <20211004125034.551184514@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125033.572932188@linuxfoundation.org>
References: <20211004125033.572932188@linuxfoundation.org>
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
index cd58c123f547..b55dff1aa50b 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -2996,7 +2996,7 @@ static int its_vpe_irq_domain_alloc(struct irq_domain *domain, unsigned int virq
 
 	if (err) {
 		if (i > 0)
-			its_vpe_irq_domain_free(domain, virq, i - 1);
+			its_vpe_irq_domain_free(domain, virq, i);
 
 		its_lpi_free(bitmap, base, nr_ids);
 		its_free_prop_table(vprop_page);
-- 
2.33.0



