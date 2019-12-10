Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54329119501
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727848AbfLJVRv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:17:51 -0500
Received: from mga01.intel.com ([192.55.52.88]:58566 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727528AbfLJVRv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:17:51 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Dec 2019 13:17:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,300,1571727600"; 
   d="scan'208";a="210505395"
Received: from tstruk-mobl1.jf.intel.com (HELO [127.0.1.1]) ([10.7.196.67])
  by fmsmga007.fm.intel.com with ESMTP; 10 Dec 2019 13:17:50 -0800
Subject: [PATCH] tpm: fix WARNING: lock held when returning to user space
From:   Tadeusz Struk <tadeusz.struk@intel.com>
To:     jarkko.sakkinen@linux.intel.com
Cc:     tadeusz.struk@intel.com, peterz@infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org, jgg@ziepe.ca,
        mingo@redhat.com, jeffrin@rajagiritech.edu.in,
        linux-integrity@vger.kernel.org, will@kernel.org, peterhuewe@gmx.de
Date:   Tue, 10 Dec 2019 13:17:51 -0800
Message-ID: <157601267151.12904.7408818232910113434.stgit@tstruk-mobl1>
In-Reply-To: <34e5340f-de75-f20e-7898-6142eac45c13@intel.com>
References: <34e5340f-de75-f20e-7898-6142eac45c13@intel.com>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When an application sends TPM commands in NONBLOCKING mode
the driver holds chip->tpm_mutex returning from write(),
which triggers WARNING: lock held when returning to user space!
To silence this warning the driver needs to release the mutex
and acquire it again in tpm_dev_async_work() before sending
the command.

Cc: stable@vger.kernel.org
Fixes: 9e1b74a63f776 (tpm: add support for nonblocking operation)
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/char/tpm/tpm-dev-common.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/char/tpm/tpm-dev-common.c b/drivers/char/tpm/tpm-dev-common.c
index 2ec47a69a2a6..b23b0b999232 100644
--- a/drivers/char/tpm/tpm-dev-common.c
+++ b/drivers/char/tpm/tpm-dev-common.c
@@ -61,6 +61,12 @@ static void tpm_dev_async_work(struct work_struct *work)
 
 	mutex_lock(&priv->buffer_mutex);
 	priv->command_enqueued = false;
+	ret = tpm_try_get_ops(priv->chip);
+	if (ret) {
+		priv->response_length = ret;
+		goto out;
+	}
+
 	ret = tpm_dev_transmit(priv->chip, priv->space, priv->data_buffer,
 			       sizeof(priv->data_buffer));
 	tpm_put_ops(priv->chip);
@@ -68,6 +74,7 @@ static void tpm_dev_async_work(struct work_struct *work)
 		priv->response_length = ret;
 		mod_timer(&priv->user_read_timer, jiffies + (120 * HZ));
 	}
+out:
 	mutex_unlock(&priv->buffer_mutex);
 	wake_up_interruptible(&priv->async_wait);
 }
@@ -204,6 +211,7 @@ ssize_t tpm_common_write(struct file *file, const char __user *buf,
 	if (file->f_flags & O_NONBLOCK) {
 		priv->command_enqueued = true;
 		queue_work(tpm_dev_wq, &priv->async_work);
+		tpm_put_ops(priv->chip);
 		mutex_unlock(&priv->buffer_mutex);
 		return size;
 	}

