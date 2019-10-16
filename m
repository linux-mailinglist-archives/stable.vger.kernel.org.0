Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3BB2DA086
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393279AbfJPWMZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:12:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:47786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406613AbfJPV4R (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:56:17 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DABFF21925;
        Wed, 16 Oct 2019 21:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262977;
        bh=UlGrKMgXgRaTB19PpiO2d5UObMhWdYR3TmQmAa+QV6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cwycZzVUMtW2QF7K8Kcg1yFoZislhG3nGQlYp1D0CkYHXaO4bmiasbCavMpsK7Zxk
         GV1WTMSNuM+zejZS1YUISFL6t8D25Jppw5O16b2QWIfAMc5xwotxbw/gyOCMaWiRUH
         aKODznVCOFyuEZ/6bfDUhioMJQIvb5XhzXnkvLhE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 4.14 46/65] CIFS: Gracefully handle QueryInfo errors during open
Date:   Wed, 16 Oct 2019 14:51:00 -0700
Message-Id: <20191016214834.485897161@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214756.457746573@linuxfoundation.org>
References: <20191016214756.457746573@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Shilovsky <piastryyy@gmail.com>

commit 30573a82fb179420b8aac30a3a3595aa96a93156 upstream.

Currently if the client identifies problems when processing
metadata returned in CREATE response, the open handle is being
leaked. This causes multiple problems like a file missing a lease
break by that client which causes high latencies to other clients
accessing the file. Another side-effect of this is that the file
can't be deleted.

Fix this by closing the file after the client hits an error after
the file was opened and the open descriptor wasn't returned to
the user space. Also convert -ESTALE to -EOPENSTALE to allow
the VFS to revalidate a dentry and retry the open.

Cc: <stable@vger.kernel.org>
Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/file.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -252,6 +252,12 @@ cifs_nt_open(char *full_path, struct ino
 		rc = cifs_get_inode_info(&inode, full_path, buf, inode->i_sb,
 					 xid, fid);
 
+	if (rc) {
+		server->ops->close(xid, tcon, fid);
+		if (rc == -ESTALE)
+			rc = -EOPENSTALE;
+	}
+
 out:
 	kfree(buf);
 	return rc;


