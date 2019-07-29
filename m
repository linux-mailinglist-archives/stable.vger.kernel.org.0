Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3E9798B3
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730382AbfG2UJX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 16:09:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:51266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729333AbfG2Tgs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:36:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D385B2171F;
        Mon, 29 Jul 2019 19:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429007;
        bh=Sfb8OS3U2e2x5qmCLlDtDVvs6ClLocIR+p5SM0N5PPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q3q+/posYvnjyWJiiyannv8RqngyXH1IDXW8V30wQn2i/5tpDgjQnhV9m5lFvagua
         rCkGDEpky7g3Mf3+jhI1qEoM38FqRgcZSpVslNVvZbotm5IJsURmImQJgzqFgyGPxK
         nqnyvNzQ2gYoW15bbg9mxvfW8XdAPBS40o3g8OaI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christian Lamparter <chunkeey@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 255/293] powerpc/4xx/uic: clear pending interrupt after irq type/pol change
Date:   Mon, 29 Jul 2019 21:22:26 +0200
Message-Id: <20190729190843.975767237@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



