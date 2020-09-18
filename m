Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52F0B26EE28
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729832AbgIRC0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:26:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:45334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729320AbgIRCQA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:16:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 517032399C;
        Fri, 18 Sep 2020 02:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395357;
        bh=muIuyhP/cJjVwo+TG7Ox+ClqqRg1N6YBSaL2OCN8hIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1E51t8IgHC2WACRdM5iyYNKtmfKWXogy258U3mDkSkqCQcRwMUAEMUtT+51EkPkNJ
         5WvLgxt6iIPmu9U3kw7ni05XzY0mdpvd90WrWdbpJt2o8U1+mnEOWv/2CzMQmbvzCj
         JF4KyVnm9POyqzyXQoyhJJSsZEJwtSTXJnMITkfQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefan Berger <stefanb@linux.ibm.com>,
        Nayna Jain <nayna@linux.ibm.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        tpmdd-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.9 51/90] tpm: ibmvtpm: Wait for buffer to be set before proceeding
Date:   Thu, 17 Sep 2020 22:14:16 -0400
Message-Id: <20200918021455.2067301-51-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918021455.2067301-1-sashal@kernel.org>
References: <20200918021455.2067301-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Berger <stefanb@linux.ibm.com>

[ Upstream commit d8d74ea3c00214aee1e1826ca18e77944812b9b4 ]

Synchronize with the results from the CRQs before continuing with
the initialization. This avoids trying to send TPM commands while
the rtce buffer has not been allocated, yet.

This patch fixes an existing race condition that may occurr if the
hypervisor does not quickly respond to the VTPM_GET_RTCE_BUFFER_SIZE
request sent during initialization and therefore the ibmvtpm->rtce_buf
has not been allocated at the time the first TPM command is sent.

Fixes: 132f76294744 ("drivers/char/tpm: Add new device driver to support IBM vTPM")
Signed-off-by: Stefan Berger <stefanb@linux.ibm.com>
Acked-by: Nayna Jain <nayna@linux.ibm.com>
Tested-by: Nayna Jain <nayna@linux.ibm.com>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm_ibmvtpm.c | 9 +++++++++
 drivers/char/tpm/tpm_ibmvtpm.h | 1 +
 2 files changed, 10 insertions(+)

diff --git a/drivers/char/tpm/tpm_ibmvtpm.c b/drivers/char/tpm/tpm_ibmvtpm.c
index 84eca4f93b828..0fad6cf37bab4 100644
--- a/drivers/char/tpm/tpm_ibmvtpm.c
+++ b/drivers/char/tpm/tpm_ibmvtpm.c
@@ -550,6 +550,7 @@ static irqreturn_t ibmvtpm_interrupt(int irq, void *vtpm_instance)
 	 */
 	while ((crq = ibmvtpm_crq_get_next(ibmvtpm)) != NULL) {
 		ibmvtpm_crq_process(crq, ibmvtpm);
+		wake_up_interruptible(&ibmvtpm->crq_queue.wq);
 		crq->valid = 0;
 		smp_wmb();
 	}
@@ -596,6 +597,7 @@ static int tpm_ibmvtpm_probe(struct vio_dev *vio_dev,
 	}
 
 	crq_q->num_entry = CRQ_RES_BUF_SIZE / sizeof(*crq_q->crq_addr);
+	init_waitqueue_head(&crq_q->wq);
 	ibmvtpm->crq_dma_handle = dma_map_single(dev, crq_q->crq_addr,
 						 CRQ_RES_BUF_SIZE,
 						 DMA_BIDIRECTIONAL);
@@ -648,6 +650,13 @@ static int tpm_ibmvtpm_probe(struct vio_dev *vio_dev,
 	if (rc)
 		goto init_irq_cleanup;
 
+	if (!wait_event_timeout(ibmvtpm->crq_queue.wq,
+				ibmvtpm->rtce_buf != NULL,
+				HZ)) {
+		dev_err(dev, "CRQ response timed out\n");
+		goto init_irq_cleanup;
+	}
+
 	return tpm_chip_register(chip);
 init_irq_cleanup:
 	do {
diff --git a/drivers/char/tpm/tpm_ibmvtpm.h b/drivers/char/tpm/tpm_ibmvtpm.h
index 91dfe766d0800..4f6a124601db4 100644
--- a/drivers/char/tpm/tpm_ibmvtpm.h
+++ b/drivers/char/tpm/tpm_ibmvtpm.h
@@ -31,6 +31,7 @@ struct ibmvtpm_crq_queue {
 	struct ibmvtpm_crq *crq_addr;
 	u32 index;
 	u32 num_entry;
+	wait_queue_head_t wq;
 };
 
 struct ibmvtpm_dev {
-- 
2.25.1

