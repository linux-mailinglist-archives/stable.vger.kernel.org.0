Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3D431EB6A7
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 09:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbgFBHmb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 03:42:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53798 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbgFBHmb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jun 2020 03:42:31 -0400
Received: from 112-104-28-97.adsl.dynamic.seed.net.tw ([112.104.28.97] helo=canonical.com)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <ivan.hu@canonical.com>)
        id 1jg1Z6-0000O8-8A; Tue, 02 Jun 2020 07:42:28 +0000
From:   Ivan Hu <ivan.hu@canonical.com>
To:     acelan.kao@canonical.com
Cc:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        stable@vger.kernel.org, Ivan Hu <ivan.hu@canonical.com>
Subject: [PATCH 1/1] tpm: fix TIS locality timeout problems
Date:   Tue,  2 Jun 2020 15:42:18 +0800
Message-Id: <20200602074218.12142-2-ivan.hu@canonical.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200602074218.12142-1-ivan.hu@canonical.com>
References: <20200602074218.12142-1-ivan.hu@canonical.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Bottomley <James.Bottomley@HansenPartnership.com>

BugLink: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1881710

It has been reported that some TIS based TPMs are giving unexpected
errors when using the O_NONBLOCK path of the TPM device. The problem
is that some TPMs don't like it when you get and then relinquish a
locality (as the tpm_try_get_ops()/tpm_put_ops() pair does) without
sending a command.  This currently happens all the time in the
O_NONBLOCK write path. Fix this by moving the tpm_try_get_ops()
further down the code to after the O_NONBLOCK determination is made.
This is safe because the priv->buffer_mutex still protects the priv
state being modified.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=206275
Fixes: d23d12484307 ("tpm: fix invalid locking in NONBLOCKING mode")
Reported-by: Mario Limonciello <Mario.Limonciello@dell.com>
Tested-by: Alex Guzman <alex@guzman.io>
Cc: stable@vger.kernel.org
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Ivan Hu <ivan.hu@canonical.com>
---
 drivers/char/tpm/tpm-dev-common.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/char/tpm/tpm-dev-common.c b/drivers/char/tpm/tpm-dev-common.c
index 10b9f63701e6..de55205d3a11 100644
--- a/drivers/char/tpm/tpm-dev-common.c
+++ b/drivers/char/tpm/tpm-dev-common.c
@@ -164,15 +164,6 @@ ssize_t tpm_common_write(struct file *file, const char __user *buf,
 		goto out;
 	}
 
-	/* atomic tpm command send and result receive. We only hold the ops
-	 * lock during this period so that the tpm can be unregistered even if
-	 * the char dev is held open.
-	 */
-	if (tpm_try_get_ops(priv->chip)) {
-		ret = -EPIPE;
-		goto out;
-	}
-
 	priv->response_length = 0;
 	priv->response_read = false;
 	*off = 0;
@@ -186,11 +177,19 @@ ssize_t tpm_common_write(struct file *file, const char __user *buf,
 	if (file->f_flags & O_NONBLOCK) {
 		priv->command_enqueued = true;
 		queue_work(tpm_dev_wq, &priv->async_work);
-		tpm_put_ops(priv->chip);
 		mutex_unlock(&priv->buffer_mutex);
 		return size;
 	}
 
+	/* atomic tpm command send and result receive. We only hold the ops
+	 * lock during this period so that the tpm can be unregistered even if
+	 * the char dev is held open.
+	 */
+	if (tpm_try_get_ops(priv->chip)) {
+		ret = -EPIPE;
+		goto out;
+	}
+
 	ret = tpm_transmit(priv->chip, priv->space, priv->data_buffer,
 			   sizeof(priv->data_buffer), 0);
 	tpm_put_ops(priv->chip);
-- 
2.17.1

