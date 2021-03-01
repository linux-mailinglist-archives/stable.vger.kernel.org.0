Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8843F3289DE
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232173AbhCASHJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:07:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:54156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238459AbhCASBi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:01:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C0F264DCF;
        Mon,  1 Mar 2021 17:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620850;
        bh=ytJhFYW2aFDy5jQ+6XiaE629BvE13YX4w6P7MmrwvsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nnI4oXkHgJh7Uui7FINo/RX1/Ipnekbrv1tASoFIvVjdkSeYwag9Gwytgs7CQ9duq
         uDh31q71r63igQ63jGRRQdfSqosRj6BsLB4+02B6nVxrkqTVF93f3ioNfHJXehIAnN
         tpjCKRsG0uBqsjj16Mw3WuYHZPkI3qeCQFATJlZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 272/775] s390/zcrypt: return EIO when msg retry limit reached
Date:   Mon,  1 Mar 2021 17:07:20 +0100
Message-Id: <20210301161215.074835764@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harald Freudenberger <freude@linux.ibm.com>

[ Upstream commit d39fae45c97c67b1b4da04773f2bb5a2f29088c4 ]

When a msg is retried because the lower ap layer returns -EAGAIN
there is a retry limit (currently 10). When this limit is reached
the last return code from the lower layer is returned, causing
the userspace to get -1 on the ioctl with errno EAGAIN.

This EAGAIN is misleading here. After 10 retry attempts the
userspace should receive a clear failure indication like EINVAL
or EIO or ENODEV. However, the reason why these retries all
fail is unclear. On an invalid message EINVAL would be returned
by the lower layer, and if devices go away or are not available
an ENODEV is seen. So this patch now reworks the retry loops
to return EIO to userspace when the retry limit is reached.

Fixes: 91ffc519c199 ("s390/zcrypt: introduce msg tracking in zcrypt functions")
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/zcrypt_api.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/s390/crypto/zcrypt_api.c b/drivers/s390/crypto/zcrypt_api.c
index 10206e4498d07..52eaf51c9bb64 100644
--- a/drivers/s390/crypto/zcrypt_api.c
+++ b/drivers/s390/crypto/zcrypt_api.c
@@ -1438,6 +1438,8 @@ static int icarsamodexpo_ioctl(struct ap_perms *perms, unsigned long arg)
 			if (rc == -EAGAIN)
 				tr.again_counter++;
 		} while (rc == -EAGAIN && tr.again_counter < TRACK_AGAIN_MAX);
+	if (rc == -EAGAIN && tr.again_counter >= TRACK_AGAIN_MAX)
+		rc = -EIO;
 	if (rc) {
 		ZCRYPT_DBF(DBF_DEBUG, "ioctl ICARSAMODEXPO rc=%d\n", rc);
 		return rc;
@@ -1481,6 +1483,8 @@ static int icarsacrt_ioctl(struct ap_perms *perms, unsigned long arg)
 			if (rc == -EAGAIN)
 				tr.again_counter++;
 		} while (rc == -EAGAIN && tr.again_counter < TRACK_AGAIN_MAX);
+	if (rc == -EAGAIN && tr.again_counter >= TRACK_AGAIN_MAX)
+		rc = -EIO;
 	if (rc) {
 		ZCRYPT_DBF(DBF_DEBUG, "ioctl ICARSACRT rc=%d\n", rc);
 		return rc;
@@ -1524,6 +1528,8 @@ static int zsecsendcprb_ioctl(struct ap_perms *perms, unsigned long arg)
 			if (rc == -EAGAIN)
 				tr.again_counter++;
 		} while (rc == -EAGAIN && tr.again_counter < TRACK_AGAIN_MAX);
+	if (rc == -EAGAIN && tr.again_counter >= TRACK_AGAIN_MAX)
+		rc = -EIO;
 	if (rc)
 		ZCRYPT_DBF(DBF_DEBUG, "ioctl ZSENDCPRB rc=%d status=0x%x\n",
 			   rc, xcRB.status);
@@ -1568,6 +1574,8 @@ static int zsendep11cprb_ioctl(struct ap_perms *perms, unsigned long arg)
 			if (rc == -EAGAIN)
 				tr.again_counter++;
 		} while (rc == -EAGAIN && tr.again_counter < TRACK_AGAIN_MAX);
+	if (rc == -EAGAIN && tr.again_counter >= TRACK_AGAIN_MAX)
+		rc = -EIO;
 	if (rc)
 		ZCRYPT_DBF(DBF_DEBUG, "ioctl ZSENDEP11CPRB rc=%d\n", rc);
 	if (copy_to_user(uxcrb, &xcrb, sizeof(xcrb)))
@@ -1744,6 +1752,8 @@ static long trans_modexpo32(struct ap_perms *perms, struct file *filp,
 			if (rc == -EAGAIN)
 				tr.again_counter++;
 		} while (rc == -EAGAIN && tr.again_counter < TRACK_AGAIN_MAX);
+	if (rc == -EAGAIN && tr.again_counter >= TRACK_AGAIN_MAX)
+		rc = -EIO;
 	if (rc)
 		return rc;
 	return put_user(mex64.outputdatalength,
@@ -1795,6 +1805,8 @@ static long trans_modexpo_crt32(struct ap_perms *perms, struct file *filp,
 			if (rc == -EAGAIN)
 				tr.again_counter++;
 		} while (rc == -EAGAIN && tr.again_counter < TRACK_AGAIN_MAX);
+	if (rc == -EAGAIN && tr.again_counter >= TRACK_AGAIN_MAX)
+		rc = -EIO;
 	if (rc)
 		return rc;
 	return put_user(crt64.outputdatalength,
@@ -1865,6 +1877,8 @@ static long trans_xcRB32(struct ap_perms *perms, struct file *filp,
 			if (rc == -EAGAIN)
 				tr.again_counter++;
 		} while (rc == -EAGAIN && tr.again_counter < TRACK_AGAIN_MAX);
+	if (rc == -EAGAIN && tr.again_counter >= TRACK_AGAIN_MAX)
+		rc = -EIO;
 	xcRB32.reply_control_blk_length = xcRB64.reply_control_blk_length;
 	xcRB32.reply_data_length = xcRB64.reply_data_length;
 	xcRB32.status = xcRB64.status;
-- 
2.27.0



