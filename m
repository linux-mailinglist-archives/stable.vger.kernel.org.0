Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE7C11AC72A
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 16:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390777AbgDPOul (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 10:50:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:45230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2506781AbgDPN6O (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:58:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9E7820786;
        Thu, 16 Apr 2020 13:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045493;
        bh=zvjR35mQ9hoJty1PjO1v66adUfRK6NLfWHAp4HgerOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z/J2TCVd/Ox7R90W/+XPXbjRY51+rryu7PdJ/1yBw9VdifjbWgUZCNIxz8SdA2BZz
         HFLl1iQ5esTat928oOKfrvUl8pGv8FoZFY2rQfXrIoDNeFmRsohEFpY4r0AUQ9zKKU
         y2l91oTj7ZPIeuCYqh3W7/JMo1cTqZ7nl9qm3F4c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yilu Lin <linyilu@huawei.com>,
        Steve French <stfrench@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH 5.6 140/254] CIFS: Fix bug which the return value by asynchronous read is error
Date:   Thu, 16 Apr 2020 15:23:49 +0200
Message-Id: <20200416131343.984048431@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yilu Lin <linyilu@huawei.com>

commit 97adda8b3ab703de8e4c8d27646ddd54fe22879c upstream.

This patch is used to fix the bug in collect_uncached_read_data()
that rc is automatically converted from a signed number to an
unsigned number when the CIFS asynchronous read fails.
It will cause ctx->rc is error.

Example:
Share a directory and create a file on the Windows OS.
Mount the directory to the Linux OS using CIFS.
On the CIFS client of the Linux OS, invoke the pread interface to
deliver the read request.

The size of the read length plus offset of the read request is greater
than the maximum file size.

In this case, the CIFS server on the Windows OS returns a failure
message (for example, the return value of
smb2.nt_status is STATUS_INVALID_PARAMETER).

After receiving the response message, the CIFS client parses
smb2.nt_status to STATUS_INVALID_PARAMETER
and converts it to the Linux error code (rdata->result=-22).

Then the CIFS client invokes the collect_uncached_read_data function to
assign the value of rdata->result to rc, that is, rc=rdata->result=-22.

The type of the ctx->total_len variable is unsigned integer,
the type of the rc variable is integer, and the type of
the ctx->rc variable is ssize_t.

Therefore, during the ternary operation, the value of rc is
automatically converted to an unsigned number. The final result is
ctx->rc=4294967274. However, the expected result is ctx->rc=-22.

Signed-off-by: Yilu Lin <linyilu@huawei.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
CC: Stable <stable@vger.kernel.org>
Acked-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3841,7 +3841,7 @@ again:
 	if (rc == -ENODATA)
 		rc = 0;
 
-	ctx->rc = (rc == 0) ? ctx->total_len : rc;
+	ctx->rc = (rc == 0) ? (ssize_t)ctx->total_len : rc;
 
 	mutex_unlock(&ctx->aio_mutex);
 


