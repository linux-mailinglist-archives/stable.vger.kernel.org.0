Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 956B4206431
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389312AbgFWVRg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:17:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:45918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390674AbgFWU0j (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:26:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CB5E20702;
        Tue, 23 Jun 2020 20:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943999;
        bh=kHTISQR4EnsLR+y15Tcb8QedL3M6QpAjkrPEMouBTes=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EgZmYxlBJAJezpKAX5lXKMf5TMKPjQGG39kq/sE4mbl75lu/2LigWz2L00x9bucDk
         Oz1kqk6e51Myo9wsmAmq/po0bLVnWl1jVkhMyRGovl86Z4mLAZAyAdn+L+ux9UpBol
         GyxbSiUi65V9oxMQEVRS1rvNwUJwPrKEd2IcxoXA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 102/314] s390/qdio: put thinint indicator after early error
Date:   Tue, 23 Jun 2020 21:54:57 +0200
Message-Id: <20200623195343.726017627@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index a58b45df95d7e..3b0a4483a2520 100644
--- a/drivers/s390/cio/qdio.h
+++ b/drivers/s390/cio/qdio.h
@@ -372,7 +372,6 @@ static inline int multicast_outbound(struct qdio_q *q)
 extern u64 last_ai_time;
 
 /* prototypes for thin interrupt */
-void qdio_setup_thinint(struct qdio_irq *irq_ptr);
 int qdio_establish_thinint(struct qdio_irq *irq_ptr);
 void qdio_shutdown_thinint(struct qdio_irq *irq_ptr);
 void tiqdio_add_input_queues(struct qdio_irq *irq_ptr);
diff --git a/drivers/s390/cio/qdio_setup.c b/drivers/s390/cio/qdio_setup.c
index ee0b3c5862110..9dc56aa3ae559 100644
--- a/drivers/s390/cio/qdio_setup.c
+++ b/drivers/s390/cio/qdio_setup.c
@@ -479,7 +479,6 @@ int qdio_setup_irq(struct qdio_initialize *init_data)
 	setup_queues(irq_ptr, init_data);
 
 	setup_qib(irq_ptr, init_data);
-	qdio_setup_thinint(irq_ptr);
 	set_impl_params(irq_ptr, init_data->qib_param_field_format,
 			init_data->qib_param_field,
 			init_data->input_slib_elements,
diff --git a/drivers/s390/cio/qdio_thinint.c b/drivers/s390/cio/qdio_thinint.c
index 93ee067c10cab..ddf780b12d408 100644
--- a/drivers/s390/cio/qdio_thinint.c
+++ b/drivers/s390/cio/qdio_thinint.c
@@ -268,17 +268,19 @@ int __init tiqdio_register_thinints(void)
 
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



