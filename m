Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B98B3217119
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730039AbgGGPYI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:24:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:37510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730024AbgGGPYF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:24:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A331E207CD;
        Tue,  7 Jul 2020 15:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135445;
        bh=TQp5hTbDD5CfDkkOPSDPVU3Tk7aX4S5pNwxMCWt8qv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sa4NlwW5JDa2CtXfGPRu5l9xl2cT8Lbq3g7AipLpJ7k0srXjgo0/HUg02CGoe6EbC
         rk+ZUceUbHpkH0sGsz5P/EVC0oZtoiwo9g5kCLrnwz1mDwrTvjwEHJjWSrb79z+CPk
         Bn4xay0yWlTfIDVpiWpjcfTDDO2Kq33TreZcgFRc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mario Limonciello <Mario.Limonciello@dell.com>,
        Alex Guzman <alex@guzman.io>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH 5.7 043/112] tpm: Fix TIS locality timeout problems
Date:   Tue,  7 Jul 2020 17:16:48 +0200
Message-Id: <20200707145803.049491500@linuxfoundation.org>
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

From: James Bottomley <James.Bottomley@HansenPartnership.com>

commit 7862840219058436b80029a0263fd1ef065fb1b3 upstream.

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
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/tpm/tpm-dev-common.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- a/drivers/char/tpm/tpm-dev-common.c
+++ b/drivers/char/tpm/tpm-dev-common.c
@@ -189,15 +189,6 @@ ssize_t tpm_common_write(struct file *fi
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
@@ -211,11 +202,19 @@ ssize_t tpm_common_write(struct file *fi
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


