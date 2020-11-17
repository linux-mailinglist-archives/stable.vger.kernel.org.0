Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0722B656B
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730397AbgKQNzT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:55:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:59154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730857AbgKQNYJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:24:09 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBD022463D;
        Tue, 17 Nov 2020 13:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619448;
        bh=kmuqCUfm9zSf7c1aNmUb/mtXrU+xM+WtkkvfC/WVZRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d79jBIJ7iIxs7pLq8r1BP8yuBBpN/pI41l7ItiI4+/7OoqUQZug6ERm/CEORcMs1F
         bRz+DkiCPQjvuW/Vf75F8xPiK3j8MvpizXh7N3VmiCPpaZgED5eqyz1dwVQVmuBe79
         5BXr95Hz4+I8ZsfW0T4/ua9jqm1y0cdaJFdP+gbk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 012/151] genirq: Let GENERIC_IRQ_IPI select IRQ_DOMAIN_HIERARCHY
Date:   Tue, 17 Nov 2020 14:04:02 +0100
Message-Id: <20201117122122.003505514@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 151a535171be6ff824a0a3875553ea38570f4c05 ]

kernel/irq/ipi.c otherwise fails to compile if nothing else
selects it.

Fixes: 379b656446a3 ("genirq: Add GENERIC_IRQ_IPI Kconfig symbol")
Reported-by: Pavel Machek <pavel@ucw.cz>
Tested-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20201015101222.GA32747@amd
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/irq/Kconfig b/kernel/irq/Kconfig
index f92d9a6873720..4e11120265c74 100644
--- a/kernel/irq/Kconfig
+++ b/kernel/irq/Kconfig
@@ -81,6 +81,7 @@ config IRQ_FASTEOI_HIERARCHY_HANDLERS
 # Generic IRQ IPI support
 config GENERIC_IRQ_IPI
 	bool
+	select IRQ_DOMAIN_HIERARCHY
 
 # Generic MSI interrupt support
 config GENERIC_MSI_IRQ
-- 
2.27.0



