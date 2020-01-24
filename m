Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6439148338
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404701AbgAXLeO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:34:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:54090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404691AbgAXLeN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:34:13 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80A1D20838;
        Fri, 24 Jan 2020 11:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865653;
        bh=vx3U5QbwduGQBLYprsebiLulcwS7MfYAnyCq0tDxRY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GYMG+z35G82t9qbp6Azv35F9c3wxjLxwQUfW4U8mYiUA2tB+TohMe6u4umm/3jSPR
         WSYkhQ8gZlTyWGYJBEtx4kiEtN0sxX7qMQhnVQQa1O7jlb/TJ/NA9WJJJLyuCQ3FW9
         Fpgm/tf7HV34fot01rHAp4Vl6g9k9gkwt8fs9Kvg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Igor Russkikh <igor.russkikh@aquantia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 574/639] net: aquantia: Fix aq_vec_isr_legacy() return value
Date:   Fri, 24 Jan 2020 10:32:24 +0100
Message-Id: <20200124093201.334609891@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 31aefe14bc9f56566041303d733fda511d3a1c3e ]

The irqreturn_t type is an enum or an unsigned int in GCC.  That
creates to problems because it can't detect if the
self->aq_hw_ops->hw_irq_read() call fails and at the end the function
always returns IRQ_HANDLED.

drivers/net/ethernet/aquantia/atlantic/aq_vec.c:316 aq_vec_isr_legacy() warn: unsigned 'err' is never less than zero.
drivers/net/ethernet/aquantia/atlantic/aq_vec.c:329 aq_vec_isr_legacy() warn: always true condition '(err >= 0) => (0-u32max >= 0)'

Fixes: 970a2e9864b0 ("net: ethernet: aquantia: Vector operations")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Igor Russkikh <igor.russkikh@aquantia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_vec.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
index 82582fa54d5d2..72aa2a4c4d666 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
@@ -309,15 +309,13 @@ irqreturn_t aq_vec_isr_legacy(int irq, void *private)
 {
 	struct aq_vec_s *self = private;
 	u64 irq_mask = 0U;
-	irqreturn_t err = 0;
+	int err;
 
-	if (!self) {
-		err = -EINVAL;
-		goto err_exit;
-	}
+	if (!self)
+		return IRQ_NONE;
 	err = self->aq_hw_ops->hw_irq_read(self->aq_hw, &irq_mask);
 	if (err < 0)
-		goto err_exit;
+		return IRQ_NONE;
 
 	if (irq_mask) {
 		self->aq_hw_ops->hw_irq_disable(self->aq_hw,
@@ -325,11 +323,10 @@ irqreturn_t aq_vec_isr_legacy(int irq, void *private)
 		napi_schedule(&self->napi);
 	} else {
 		self->aq_hw_ops->hw_irq_enable(self->aq_hw, 1U);
-		err = IRQ_NONE;
+		return IRQ_NONE;
 	}
 
-err_exit:
-	return err >= 0 ? IRQ_HANDLED : IRQ_NONE;
+	return IRQ_HANDLED;
 }
 
 cpumask_t *aq_vec_get_affinity_mask(struct aq_vec_s *self)
-- 
2.20.1



