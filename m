Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AAA62B6638
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 15:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729520AbgKQNKu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:10:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:40114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729514AbgKQNKo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:10:44 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4CF524698;
        Tue, 17 Nov 2020 13:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618644;
        bh=d2WD2upIBhI0qBf6ii5Qv8GdhRGrj9vGi/dFfjY7N50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IJ9v2bKwXbHqP9Bz+fk1nRChtVlFLwl+0KcNP8i/YqqT+7z2T3N4Kq1AQRF6BRWxU
         pis7hYw7oYti7QaUpSRS04qGVUPw+aH56WSm2m6Liq1vrYOiD977BolSrQM6nxTSIO
         0JT3C4fD1V1BX5Ghq5KNLudHw1I8oRhlRq72U1dA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 07/78] genirq: Let GENERIC_IRQ_IPI select IRQ_DOMAIN_HIERARCHY
Date:   Tue, 17 Nov 2020 14:04:33 +0100
Message-Id: <20201117122109.455203463@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122109.116890262@linuxfoundation.org>
References: <20201117122109.116890262@linuxfoundation.org>
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
index 3bbfd6a9c4756..bb3a46cbe034c 100644
--- a/kernel/irq/Kconfig
+++ b/kernel/irq/Kconfig
@@ -67,6 +67,7 @@ config IRQ_DOMAIN_HIERARCHY
 # Generic IRQ IPI support
 config GENERIC_IRQ_IPI
 	bool
+	select IRQ_DOMAIN_HIERARCHY
 
 # Generic MSI interrupt support
 config GENERIC_MSI_IRQ
-- 
2.27.0



