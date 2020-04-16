Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC6EC1AC40A
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408972AbgDPNxT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:53:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:39552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408948AbgDPNxN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:53:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9920321927;
        Thu, 16 Apr 2020 13:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045193;
        bh=S3kmvQnrFbm9NwxUbbMXxAAdzCLFDFuaxgikDn3OQNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F6NYv3N9VSUuNb4TGlCzqPBaGTCb+xRbw2OpW5BoGkRbfIxp+uD2ktrTFtXeiCLn5
         tean/nj2LoQA7211SkZ4X8z8xOXtX7fMMAoIejfDvdkYYvnU5OjqcH+kjATPH0eioj
         1JVqUkCza1BnCLkYRBHw68i5zVcWeaP8IAULKYlA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 034/254] irqchip/gic-v4.1: Skip absent CPUs while iterating over redistributors
Date:   Thu, 16 Apr 2020 15:22:03 +0200
Message-Id: <20200416131330.131517661@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 28d160de5194c68ff534443d2a8b6f1d10d57c58 ]

In a system that is only sparsly populated with CPUs, we can end-up with
redistributors structures that are not initialized. Let's make sure we
don't try and access those when iterating over them (in this case when
checking we have a L2 VPE table).

Fixes: 4e6437f12d6e ("irqchip/gic-v4.1: Ensure L2 vPE table is allocated at RD level")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Link: https://lore.kernel.org/r/20200304203330.4967-3-maz@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 83b1186ffcad0..da883a6910284 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -2452,6 +2452,10 @@ static bool allocate_vpe_l2_table(int cpu, u32 id)
 	if (!gic_rdists->has_rvpeid)
 		return true;
 
+	/* Skip non-present CPUs */
+	if (!base)
+		return true;
+
 	val  = gicr_read_vpropbaser(base + SZ_128K + GICR_VPROPBASER);
 
 	esz  = FIELD_GET(GICR_VPROPBASER_4_1_ENTRY_SIZE, val) + 1;
-- 
2.20.1



