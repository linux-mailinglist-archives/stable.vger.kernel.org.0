Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B95706DDB3
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731490AbfGSEYw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:24:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:44058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387572AbfGSEJ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:09:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EA162189E;
        Fri, 19 Jul 2019 04:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509369;
        bh=4C3GOrjknXPI85zfXqF36miPxIgMOCcb0/OZJSd8Rqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wt0LsNnEyLVwNaF0rDYkOPblvSP4LgIG+OxirGlIXgjum4lX2eMOViQfgiNJGNtAy
         UaYGOaCLPVBdtTFPj80VtNat4cGBVAF3tCV4ZWN0L+OEP5zAHGtSun0b8jALhwWnsQ
         AGd9e6DBKCJ+M/+pmdbhKbFdWOhc8I4LlcsnGSZA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christian Lamparter <chunkeey@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 057/101] powerpc/4xx/uic: clear pending interrupt after irq type/pol change
Date:   Fri, 19 Jul 2019 00:06:48 -0400
Message-Id: <20190719040732.17285-57-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719040732.17285-1-sashal@kernel.org>
References: <20190719040732.17285-1-sashal@kernel.org>
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
index 8b4dd0da0839..9e27cfe27026 100644
--- a/arch/powerpc/platforms/4xx/uic.c
+++ b/arch/powerpc/platforms/4xx/uic.c
@@ -158,6 +158,7 @@ static int uic_set_irq_type(struct irq_data *d, unsigned int flow_type)
 
 	mtdcr(uic->dcrbase + UIC_PR, pr);
 	mtdcr(uic->dcrbase + UIC_TR, tr);
+	mtdcr(uic->dcrbase + UIC_SR, ~mask);
 
 	raw_spin_unlock_irqrestore(&uic->lock, flags);
 
-- 
2.20.1

