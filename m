Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64D8A27C9BC
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732151AbgI2MNb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:13:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:58102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730128AbgI2Lha (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66A7523B83;
        Tue, 29 Sep 2020 11:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379270;
        bh=uLyab3reV9Cbu2r3VvlqvXJIVfiUsg5LorqQCGrHO9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I1ETjwfQNQ43Yn/P9GxPrIl5F+833pYEHp/ANxHCJPEaN2DS3QmQEoQe6AXt3zugn
         pI6E5YUR2+SKQZOWSE4RgFHuZxW9+TH+pBh3b3DBFmW14SFglQAaDy3QBFvmOAqco2
         t26AYBP3OD0BbkSQC7YT909CcpX8w9b/A+dywjmc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Markus Elfring <elfring@users.sourceforge.net>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 059/388] CIFS: Use common error handling code in smb2_ioctl_query_info()
Date:   Tue, 29 Sep 2020 12:56:30 +0200
Message-Id: <20200929110013.351713982@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



