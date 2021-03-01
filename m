Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA33328E05
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235436AbhCATWi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:22:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:43878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241342AbhCATRl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:17:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48760650D0;
        Mon,  1 Mar 2021 17:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620693;
        bh=17aJ5TrXXHfPXWOcJMojWK2MnujmW9g7AlH+zI7JqiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oGrHJZqB+30k0Uh5rPMqhz9FsZ3eQLtddo2u7jAiI/HuUt9ZiSxWJqo1ibuWX5Te3
         K64GOEwvM9WwdpCN5NZfJ/KwUuYXUcmXK43XbJ11NjORx3b4nwJO3jy784OL9ekUXh
         CEsBdbf5GwjXre3fnkropmin9JOw8Ix2QCyUJQmM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Biwen Li <biwen.li@nxp.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 246/775] irqchip/ls-extirq: add IRQCHIP_SKIP_SET_WAKE to the irqchip flags
Date:   Mon,  1 Mar 2021 17:06:54 +0100
Message-Id: <20210301161213.783757393@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Biwen Li <biwen.li@nxp.com>

[ Upstream commit c60767421e102dfd1f4d99ad0cc7f8ba24461eb8 ]

The ls-extirq driver doesn't implement the irq_set_wake()
callback, while being wake-up capable. This results in
ugly behaviours across suspend/resume cycles.

Advertise this by adding IRQCHIP_SKIP_SET_WAKE to
the irqchip flags

Fixes: b16a1caf4686 ("irqchip/ls-extirq: Add LS1043A, LS1088A external interrupt support")
Signed-off-by: Biwen Li <biwen.li@nxp.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210129095034.33821-1-biwen.li@oss.nxp.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-ls-extirq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-ls-extirq.c b/drivers/irqchip/irq-ls-extirq.c
index f94f974a87645..853b3972dbe78 100644
--- a/drivers/irqchip/irq-ls-extirq.c
+++ b/drivers/irqchip/irq-ls-extirq.c
@@ -64,7 +64,7 @@ static struct irq_chip ls_extirq_chip = {
 	.irq_set_type		= ls_extirq_set_type,
 	.irq_retrigger		= irq_chip_retrigger_hierarchy,
 	.irq_set_affinity	= irq_chip_set_affinity_parent,
-	.flags                  = IRQCHIP_SET_TYPE_MASKED,
+	.flags                  = IRQCHIP_SET_TYPE_MASKED | IRQCHIP_SKIP_SET_WAKE,
 };
 
 static int
-- 
2.27.0



