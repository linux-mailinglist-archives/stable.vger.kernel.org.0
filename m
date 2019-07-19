Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9A0A6DCB1
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389451AbfGSENy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:13:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:49952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389449AbfGSENy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:13:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A59DE21872;
        Fri, 19 Jul 2019 04:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509633;
        bh=iRuFMwXhuMLce6qT7V7J15ncz3hLfMvGmvNr2ykkQfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=teah+4Ln583x6LQiQ34L50igJzVnNwWo4IovY/Wgk+tyCXegyNN39q/qhHt7KxO7i
         BdPnN+mlNcvDN06yCDaD/GuO+gvptBnC8FMljEk50UyUmaq895XfdJja0ITSI8HcsQ
         r5A5KMh/9KAINzVUrOZgpjE8pOuPr8t9JvrUJqx4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christian Lamparter <chunkeey@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.9 29/45] powerpc/4xx/uic: clear pending interrupt after irq type/pol change
Date:   Fri, 19 Jul 2019 00:12:48 -0400
Message-Id: <20190719041304.18849-29-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719041304.18849-1-sashal@kernel.org>
References: <20190719041304.18849-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Lamparter <chunkeey@gmail.com>

[ Upstream commit 3ab3a0689e74e6aa5b41360bc18861040ddef5b1 ]

When testing out gpio-keys with a button, a spurious
interrupt (and therefore a key press or release event)
gets triggered as soon as the driver enables the irq
line for the first time.

This patch clears any potential bogus generated interrupt
that was caused by the switching of the associated irq's
type and polarity.

Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/sysdev/uic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/sysdev/uic.c b/arch/powerpc/sysdev/uic.c
index a00949f3e378..a8ebc96dfed2 100644
--- a/arch/powerpc/sysdev/uic.c
+++ b/arch/powerpc/sysdev/uic.c
@@ -158,6 +158,7 @@ static int uic_set_irq_type(struct irq_data *d, unsigned int flow_type)
 
 	mtdcr(uic->dcrbase + UIC_PR, pr);
 	mtdcr(uic->dcrbase + UIC_TR, tr);
+	mtdcr(uic->dcrbase + UIC_SR, ~mask);
 
 	raw_spin_unlock_irqrestore(&uic->lock, flags);
 
-- 
2.20.1

