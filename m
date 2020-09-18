Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 392BE26F3FA
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgIRCCb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:02:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:47698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726752AbgIRCCa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:02:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4746F2371F;
        Fri, 18 Sep 2020 02:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394545;
        bh=uLyab3reV9Cbu2r3VvlqvXJIVfiUsg5LorqQCGrHO9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C7u4CnfpBS7T6jYpzgHQzWelVgo5zboB+DB6Dq5o7kSy/4JKiXWfIwkp30Hwq/8cu
         vRVCDOZPrqa7ihBKIqdU3TMgO+XZzFTPsCSfOPku77h9eAGGxmOAf3+9P1PfUC+r8O
         OMKptyNRMQA2PMi0DzEtBpaFY0PC/pk1bgP12op0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Markus Elfring <elfring@users.sourceforge.net>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.4 062/330] CIFS: Use common error handling code in smb2_ioctl_query_info()
Date:   Thu, 17 Sep 2020 21:56:42 -0400
Message-Id: <20200918020110.2063155-62-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>

[ Upstream commit 2b1116bbe898aefdf584838448c6869f69851e0f ]

Move the same error code assignments so that such exception handling
can be better reused at the end of this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2ops.c | 45 +++++++++++++++++++++++----------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 7ccbfc6564787..318d805e74d40 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1565,35 +1565,32 @@ smb2_ioctl_query_info(const unsigned int xid,
 		if (le32_to_cpu(io_rsp->OutputCount) < qi.input_buffer_length)
 			qi.input_buffer_length = le32_to_cpu(io_rsp->OutputCount);
 		if (qi.input_buffer_length > 0 &&
-		    le32_to_cpu(io_rsp->OutputOffset) + qi.input_buffer_length > rsp_iov[1].iov_len) {
-			rc = -EFAULT;
-			goto iqinf_exit;
-		}
-		if (copy_to_user(&pqi->input_buffer_length, &qi.input_buffer_length,
-				 sizeof(qi.input_buffer_length))) {
-			rc = -EFAULT;
-			goto iqinf_exit;
-		}
+		    le32_to_cpu(io_rsp->OutputOffset) + qi.input_buffer_length
+		    > rsp_iov[1].iov_len)
+			goto e_fault;
+
+		if (copy_to_user(&pqi->input_buffer_length,
+				 &qi.input_buffer_length,
+				 sizeof(qi.input_buffer_length)))
+			goto e_fault;
+
 		if (copy_to_user((void __user *)pqi + sizeof(struct smb_query_info),
 				 (const void *)io_rsp + le32_to_cpu(io_rsp->OutputOffset),
-				 qi.input_buffer_length)) {
-			rc = -EFAULT;
-			goto iqinf_exit;
-		}
+				 qi.input_buffer_length))
+			goto e_fault;
 	} else {
 		pqi = (struct smb_query_info __user *)arg;
 		qi_rsp = (struct smb2_query_info_rsp *)rsp_iov[1].iov_base;
 		if (le32_to_cpu(qi_rsp->OutputBufferLength) < qi.input_buffer_length)
 			qi.input_buffer_length = le32_to_cpu(qi_rsp->OutputBufferLength);
-		if (copy_to_user(&pqi->input_buffer_length, &qi.input_buffer_length,
-				 sizeof(qi.input_buffer_length))) {
-			rc = -EFAULT;
-			goto iqinf_exit;
-		}
-		if (copy_to_user(pqi + 1, qi_rsp->Buffer, qi.input_buffer_length)) {
-			rc = -EFAULT;
-			goto iqinf_exit;
-		}
+		if (copy_to_user(&pqi->input_buffer_length,
+				 &qi.input_buffer_length,
+				 sizeof(qi.input_buffer_length)))
+			goto e_fault;
+
+		if (copy_to_user(pqi + 1, qi_rsp->Buffer,
+				 qi.input_buffer_length))
+			goto e_fault;
 	}
 
  iqinf_exit:
@@ -1609,6 +1606,10 @@ smb2_ioctl_query_info(const unsigned int xid,
 	free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
 	free_rsp_buf(resp_buftype[2], rsp_iov[2].iov_base);
 	return rc;
+
+e_fault:
+	rc = -EFAULT;
+	goto iqinf_exit;
 }
 
 static ssize_t
-- 
2.25.1

