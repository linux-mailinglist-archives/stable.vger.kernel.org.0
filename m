Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38A34382F77
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238901AbhEQOQu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:16:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:46778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239039AbhEQOOr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:14:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0579613E9;
        Mon, 17 May 2021 14:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260555;
        bh=M99jlExbeeNqNrnCe9YF9Fksjjl/8jFrCYgKEFiBW5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t5/MzqUCTMK6GZ4jMq+ag/TnYPmmzqiiXvxY8+MMK0D/hAodSB92zLEc/Bj0rrngX
         eLW1BII3HD74TB/ZJHbWLiVxMEMUE/C4qpdZQAfz8bVY//mZ5hpAuU87F95GLylUXj
         Tbw2biqe4HvFpT8xzeGdMp9HA1o9ykU30HY+PmgU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
        Ray Jui <ray.jui@broadcom.com>, Marc Zyngier <maz@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 133/363] PCI: iproc: Fix return value of iproc_msi_irq_domain_alloc()
Date:   Mon, 17 May 2021 15:59:59 +0200
Message-Id: <20210517140307.116604937@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 1e83130f01b04c16579ed5a5e03d729bcffc4c5d ]

IRQ domain alloc function should return zero on success. Non-zero value
indicates failure.

Link: https://lore.kernel.org/r/20210303142202.25780-1-pali@kernel.org
Fixes: fc54bae28818 ("PCI: iproc: Allow allocation of multiple MSIs")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Krzysztof Wilczyński <kw@linux.com>
Acked-by: Ray Jui <ray.jui@broadcom.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-iproc-msi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pcie-iproc-msi.c b/drivers/pci/controller/pcie-iproc-msi.c
index 908475d27e0e..eede4e8f3f75 100644
--- a/drivers/pci/controller/pcie-iproc-msi.c
+++ b/drivers/pci/controller/pcie-iproc-msi.c
@@ -271,7 +271,7 @@ static int iproc_msi_irq_domain_alloc(struct irq_domain *domain,
 				    NULL, NULL);
 	}
 
-	return hwirq;
+	return 0;
 }
 
 static void iproc_msi_irq_domain_free(struct irq_domain *domain,
-- 
2.30.2



