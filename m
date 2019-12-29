Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D48F912C930
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:18:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387425AbfL2SBf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 13:01:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:45248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732792AbfL2R4D (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:56:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85733208C4;
        Sun, 29 Dec 2019 17:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642163;
        bh=ZXDCni9gbST/8F5GznpBpNGzWPfBuhsLhjzm6RseDqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=do1N9TwyZqaQFCAhUnZwxNmyBh+mNGJqZBalx4rfYSZKLXA6+qDt8oxgQ1+cAOm7s
         6voXmz8S6G/ED1mGYK+ej6QS1tykGMp4QIJYUUSDZNizSwkj9NvEXpaFNls/E3Cleh
         L6uuPh7n0kMIDuaFsbjo0sbHFK1QZq9zefGP5wGo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jeffrin Jose T <jeffrin@rajagiritech.edu.in>,
        Tadeusz Struk <tadeusz.struk@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH 5.4 366/434] tpm: fix invalid locking in NONBLOCKING mode
Date:   Sun, 29 Dec 2019 18:26:59 +0100
Message-Id: <20191229172726.284691037@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tadeusz Struk <tadeusz.struk@intel.com>

commit d23d12484307b40eea549b8a858f5fffad913897 upstream.

When an application sends TPM commands in NONBLOCKING mode
the driver holds chip->tpm_mutex returning from write(),
which triggers: "WARNING: lock held when returning to user space".
To fix this issue the driver needs to release the mutex before
returning and acquire it again in tpm_dev_async_work() before
sending the command.

Cc: stable@vger.kernel.org
Fixes: 9e1b74a63f776 (tpm: add support for nonblocking operation)
Reported-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/tpm/tpm-dev-common.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/char/tpm/tpm-dev-common.c
+++ b/drivers/char/tpm/tpm-dev-common.c
@@ -61,6 +61,12 @@ static void tpm_dev_async_work(struct wo
 
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
@@ -68,6 +74,7 @@ static void tpm_dev_async_work(struct wo
 		priv->response_length = ret;
 		mod_timer(&priv->user_read_timer, jiffies + (120 * HZ));
 	}
+out:
 	mutex_unlock(&priv->buffer_mutex);
 	wake_up_interruptible(&priv->async_wait);
 }
@@ -204,6 +211,7 @@ ssize_t tpm_common_write(struct file *fi
 	if (file->f_flags & O_NONBLOCK) {
 		priv->command_enqueued = true;
 		queue_work(tpm_dev_wq, &priv->async_work);
+		tpm_put_ops(priv->chip);
 		mutex_unlock(&priv->buffer_mutex);
 		return size;
 	}


