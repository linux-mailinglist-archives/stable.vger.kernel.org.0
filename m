Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 355931EBDBE
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 16:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbgFBOOd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 10:14:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38785 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbgFBOOc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jun 2020 10:14:32 -0400
Received: from 112-104-28-97.adsl.dynamic.seed.net.tw ([112.104.28.97] helo=canonical.com)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <ivan.hu@canonical.com>)
        id 1jg7gU-00047O-3O; Tue, 02 Jun 2020 14:14:30 +0000
From:   Ivan Hu <ivan.hu@canonical.com>
To:     kernel-team@lists.ubuntu.com
Cc:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        stable@vger.kernel.org, Ivan Hu <ivan.hu@canonical.com>
Subject: [PATCH 1/1][SRU][F][OEM-5.6] UBUNTU: SAUCE: tpm: fix TIS locality timeout problems
Date:   Tue,  2 Jun 2020 22:13:25 +0800
Message-Id: <20200602141325.21074-3-ivan.hu@canonical.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200602141325.21074-1-ivan.hu@canonical.com>
References: <20200602141325.21074-1-ivan.hu@canonical.com>
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
(cherry picked from https://patchwork.kernel.org/patch/11576453/)
Signed-off-by: Ivan Hu <ivan.hu@canonical.com>
---
 drivers/char/tpm/tpm-dev-common.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/char/tpm/tpm-dev-common.c b/drivers/char/tpm/tpm-dev-common.c
index 87f449340202..1784530b8387 100644
--- a/drivers/char/tpm/tpm-dev-common.c
+++ b/drivers/char/tpm/tpm-dev-common.c
@@ -189,15 +189,6 @@ ssize_t tpm_common_write(struct file *file, const char __user *buf,
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
@@ -211,11 +202,19 @@ ssize_t tpm_common_write(struct file *file, const char __user *buf,
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
 	ret = tpm_dev_transmit(priv->chip, priv->space, priv->data_buffer,
 			       sizeof(priv->data_buffer));
 	tpm_put_ops(priv->chip);
-- 
2.17.1

