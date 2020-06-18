Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 337241FE7E8
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387894AbgFRCoP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:44:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:39016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727876AbgFRBLP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:11:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C689221E6;
        Thu, 18 Jun 2020 01:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442674;
        bh=t6Xx/7RdyXz/lgFb8xtFVtATLHaRwVHELJd5weVgOqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aKr21wKqU66G7sdVn4U51y2BwjJ0ZCBBr7+asdFWbm4NiSM+sW1hM1FjEUEHNw9UA
         ydmloANk0xhcxG8TRNk+QUdBYd11q0opkLsDCHE2NavzmgcJQ9AN8Pb5HhPP9LB2Bd
         t/isU7+s9VVYO2D+pwQeDUONQYhKtEb7hr4T2pC0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julian Wiedmann <jwi@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 143/388] s390/qdio: put thinint indicator after early error
Date:   Wed, 17 Jun 2020 21:04:00 -0400
Message-Id: <20200618010805.600873-143-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

[ Upstream commit 75e82bec6b2622c6f455b7a543fb5476a5d0eed7 ]

qdio_establish() calls qdio_setup_thinint() via qdio_setup_irq().
If the subsequent qdio_establish_thinint() fails, we miss to put the
DSCI again. Thus the DSCI isn't available for re-use. Given enough of
such errors, we could end up with having only the shared DSCI available.

Merge qdio_setup_thinint() into qdio_establish_thinint(), and deal with
such an error internally.

Fixes: 779e6e1c724d ("[S390] qdio: new qdio driver.")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/qdio.h         |  1 -
 drivers/s390/cio/qdio_setup.c   |  1 -
 drivers/s390/cio/qdio_thinint.c | 14 ++++++++------
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/s390/cio/qdio.h b/drivers/s390/cio/qdio.h
index 3cf223bc1d5f..a2afd7bc100b 100644
--- a/drivers/s390/cio/qdio.h
+++ b/drivers/s390/cio/qdio.h
@@ -364,7 +364,6 @@ static inline int multicast_outbound(struct qdio_q *q)
 extern u64 last_ai_time;
 
 /* prototypes for thin interrupt */
-void qdio_setup_thinint(struct qdio_irq *irq_ptr);
 int qdio_establish_thinint(struct qdio_irq *irq_ptr);
 void qdio_shutdown_thinint(struct qdio_irq *irq_ptr);
 void tiqdio_add_device(struct qdio_irq *irq_ptr);
diff --git a/drivers/s390/cio/qdio_setup.c b/drivers/s390/cio/qdio_setup.c
index d12f094db056..8edfa0982221 100644
--- a/drivers/s390/cio/qdio_setup.c
+++ b/drivers/s390/cio/qdio_setup.c
@@ -480,7 +480,6 @@ int qdio_setup_irq(struct qdio_irq *irq_ptr, struct qdio_initialize *init_data)
 	}
 
 	setup_qib(irq_ptr, init_data);
-	qdio_setup_thinint(irq_ptr);
 	set_impl_params(irq_ptr, init_data->qib_param_field_format,
 			init_data->qib_param_field,
 			init_data->input_slib_elements,
diff --git a/drivers/s390/cio/qdio_thinint.c b/drivers/s390/cio/qdio_thinint.c
index ae50373617cd..0faa0ad21732 100644
--- a/drivers/s390/cio/qdio_thinint.c
+++ b/drivers/s390/cio/qdio_thinint.c
@@ -227,17 +227,19 @@ int __init tiqdio_register_thinints(void)
 
 int qdio_establish_thinint(struct qdio_irq *irq_ptr)
 {
+	int rc;
+
 	if (!is_thinint_irq(irq_ptr))
 		return 0;
-	return set_subchannel_ind(irq_ptr, 0);
-}
 
-void qdio_setup_thinint(struct qdio_irq *irq_ptr)
-{
-	if (!is_thinint_irq(irq_ptr))
-		return;
 	irq_ptr->dsci = get_indicator();
 	DBF_HEX(&irq_ptr->dsci, sizeof(void *));
+
+	rc = set_subchannel_ind(irq_ptr, 0);
+	if (rc)
+		put_indicator(irq_ptr->dsci);
+
+	return rc;
 }
 
 void qdio_shutdown_thinint(struct qdio_irq *irq_ptr)
-- 
2.25.1

