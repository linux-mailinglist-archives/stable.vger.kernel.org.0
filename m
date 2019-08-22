Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E01299CCB
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392572AbfHVRhD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:37:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:46644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404283AbfHVRYl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:24:41 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D1C123407;
        Thu, 22 Aug 2019 17:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494680;
        bh=da+FIGqymv0BJw686Xw4cpNKNezmZCzAbdkgFdjolxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uC5Z4AjjICzS1B+BTaieBsMOVqNPs8RtpE9/bLPDOtb2ASp22iUsY738w2n0geDmm
         /MrjPw56Tkz6g4dunWZPR34HDxFe9eUqJSIObPFMa6xo+YXCcTaYIvwroxlsNR+jDA
         5wA24RYORLbQaCdXgR6mEg0sR4c0epDuc2SwrYO4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 25/71] irqchip/irq-imx-gpcv2: Forward irq type to parent
Date:   Thu, 22 Aug 2019 10:19:00 -0700
Message-Id: <20190822171728.830100834@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171726.131957995@linuxfoundation.org>
References: <20190822171726.131957995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 9a446ef08f3bfc0c3deb9c6be840af2528ef8cf8 ]

The GPCv2 is a stacked IRQ controller below the ARM GIC. It doesn't
care about the IRQ type itself, but needs to forward the type to the
parent IRQ controller, so this one can be configured correctly.

Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-imx-gpcv2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/irqchip/irq-imx-gpcv2.c b/drivers/irqchip/irq-imx-gpcv2.c
index 675eda5ff2b85..e4831491a3c49 100644
--- a/drivers/irqchip/irq-imx-gpcv2.c
+++ b/drivers/irqchip/irq-imx-gpcv2.c
@@ -145,6 +145,7 @@ static struct irq_chip gpcv2_irqchip_data_chip = {
 	.irq_unmask		= imx_gpcv2_irq_unmask,
 	.irq_set_wake		= imx_gpcv2_irq_set_wake,
 	.irq_retrigger		= irq_chip_retrigger_hierarchy,
+	.irq_set_type		= irq_chip_set_type_parent,
 #ifdef CONFIG_SMP
 	.irq_set_affinity	= irq_chip_set_affinity_parent,
 #endif
-- 
2.20.1



