Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A93AF2171B7
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730104AbgGGPYe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:24:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:38148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729084AbgGGPYd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:24:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 008B6206F6;
        Tue,  7 Jul 2020 15:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135472;
        bh=/mfOTlsspiipEOfT9BK4xOAGQZvdm15kjpUq4qCMPOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jhX2/R6TlBbN2Vg/tedRnmEyBzKWfa7DMfx3beAqveE86ZLgS9ZgedslWvvlGWueG
         eJpcPwdKk/FhKxh2R6i9dARPyiexqmV5ZsjGu8XHSmPCKLljrYqgcURkzlwuE+hlaH
         BdJvElCOPgCj2Rxxi/rt1VxtdzNNO/Jqs+BucMBo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zenghui Yu <yuzenghui@huawei.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 053/112] irqchip/gic-v4.1: Use readx_poll_timeout_atomic() to fix sleep in atomic
Date:   Tue,  7 Jul 2020 17:16:58 +0200
Message-Id: <20200707145803.523102261@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zenghui Yu <yuzenghui@huawei.com>

[ Upstream commit 31dbb6b1d025506b3b8b8b74e9b697df47b9f696 ]

readx_poll_timeout() can sleep if @sleep_us is specified by the caller,
and is therefore unsafe to be used inside the atomic context, which is
this case when we use it to poll the GICR_VPENDBASER.Dirty bit in
irq_set_vcpu_affinity() callback.

Let's convert to its atomic version instead which helps to get the v4.1
board back to life!

Fixes: 96806229ca03 ("irqchip/gic-v4.1: Add support for VPENDBASER's Dirty+Valid signaling")
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200605052345.1494-1-yuzenghui@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 124251b0ccbae..b3e16a06c13b7 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -3681,10 +3681,10 @@ static void its_wait_vpt_parse_complete(void)
 	if (!gic_rdists->has_vpend_valid_dirty)
 		return;
 
-	WARN_ON_ONCE(readq_relaxed_poll_timeout(vlpi_base + GICR_VPENDBASER,
-						val,
-						!(val & GICR_VPENDBASER_Dirty),
-						10, 500));
+	WARN_ON_ONCE(readq_relaxed_poll_timeout_atomic(vlpi_base + GICR_VPENDBASER,
+						       val,
+						       !(val & GICR_VPENDBASER_Dirty),
+						       10, 500));
 }
 
 static void its_vpe_schedule(struct its_vpe *vpe)
-- 
2.25.1



