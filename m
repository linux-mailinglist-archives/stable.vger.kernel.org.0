Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D23496DA38
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728956AbfGSEAS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:00:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:60146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727996AbfGSEAS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:00:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 897832189F;
        Fri, 19 Jul 2019 04:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508817;
        bh=8sW2YS7ii0lNAuJz5v+7XGJtZjSoln1Lotj6urVCiE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Y6TxGXkCEJKkiQEvTDF5uFTU7zehBppphgyk9gqOV69p/dCvI87EBAwS+d/5ws70
         Nzhh0K19p9wlZ0o4beIaVIHVF5GOimBQtERy8vsv5Kcn5Egr3GiepIjhtQT8aeLf4T
         Jk75fkT5LEAwy5TOkGC+3FD/tL7Z9lhZ1LLnaq+8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christian Lamparter <chunkeey@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.2 106/171] powerpc/4xx/uic: clear pending interrupt after irq type/pol change
Date:   Thu, 18 Jul 2019 23:55:37 -0400
Message-Id: <20190719035643.14300-106-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719035643.14300-1-sashal@kernel.org>
References: <20190719035643.14300-1-sashal@kernel.org>
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
 arch/powerpc/platforms/4xx/uic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/platforms/4xx/uic.c b/arch/powerpc/platforms/4xx/uic.c
index 31f12ad37a98..36fb66ce54cf 100644
--- a/arch/powerpc/platforms/4xx/uic.c
+++ b/arch/powerpc/platforms/4xx/uic.c
@@ -154,6 +154,7 @@ static int uic_set_irq_type(struct irq_data *d, unsigned int flow_type)
 
 	mtdcr(uic->dcrbase + UIC_PR, pr);
 	mtdcr(uic->dcrbase + UIC_TR, tr);
+	mtdcr(uic->dcrbase + UIC_SR, ~mask);
 
 	raw_spin_unlock_irqrestore(&uic->lock, flags);
 
-- 
2.20.1

