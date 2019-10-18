Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C32EADD3B4
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731572AbfJRWG3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:06:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:38442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731548AbfJRWG3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:06:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BAD06222D2;
        Fri, 18 Oct 2019 22:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436388;
        bh=C3roP5wrC549HDqOhjYaF7T3usfv8aIrH4mKkQ3NbXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dt4oe8M27gd/iB/LmiGSw8hvgQU5GFJjXC687JezYcc3gmwEF2kWWRs3iYjEvsVoc
         7UVdlNdkfOoBMYRUtMvD0+UshTuLMXRLRHjqcCbA7AAK9yakL7tlyGi7FLd7vf/RCk
         YaRG5OtKzO4AI6vVQGZWHHgiyDIppOmbfo04hXyE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 040/100] CIFS: Respect SMB2 hdr preamble size in read responses
Date:   Fri, 18 Oct 2019 18:04:25 -0400
Message-Id: <20191018220525.9042-40-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220525.9042-1-sashal@kernel.org>
References: <20191018220525.9042-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Shilovsky <pshilov@microsoft.com>

[ Upstream commit bb1bccb60c2ebd9a6f895507d1d48d5ed773814e ]

There are a couple places where we still account for 4 bytes
in the beginning of SMB2 packet which is not true in the current
code. Fix this to use a header preamble size where possible.

Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifssmb.c | 7 ++++---
 fs/cifs/smb2ops.c | 6 +++---
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 86a54b809c484..8b9471904f67e 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1521,9 +1521,10 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 
 	/* set up first two iov for signature check and to get credits */
 	rdata->iov[0].iov_base = buf;
-	rdata->iov[0].iov_len = 4;
-	rdata->iov[1].iov_base = buf + 4;
-	rdata->iov[1].iov_len = server->total_read - 4;
+	rdata->iov[0].iov_len = server->vals->header_preamble_size;
+	rdata->iov[1].iov_base = buf + server->vals->header_preamble_size;
+	rdata->iov[1].iov_len =
+		server->total_read - server->vals->header_preamble_size;
 	cifs_dbg(FYI, "0: iov_base=%p iov_len=%zu\n",
 		 rdata->iov[0].iov_base, rdata->iov[0].iov_len);
 	cifs_dbg(FYI, "1: iov_base=%p iov_len=%zu\n",
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index f0d966da7f378..6fc16329ceb45 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3000,10 +3000,10 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 
 	/* set up first two iov to get credits */
 	rdata->iov[0].iov_base = buf;
-	rdata->iov[0].iov_len = 4;
-	rdata->iov[1].iov_base = buf + 4;
+	rdata->iov[0].iov_len = 0;
+	rdata->iov[1].iov_base = buf;
 	rdata->iov[1].iov_len =
-		min_t(unsigned int, buf_len, server->vals->read_rsp_size) - 4;
+		min_t(unsigned int, buf_len, server->vals->read_rsp_size);
 	cifs_dbg(FYI, "0: iov_base=%p iov_len=%zu\n",
 		 rdata->iov[0].iov_base, rdata->iov[0].iov_len);
 	cifs_dbg(FYI, "1: iov_base=%p iov_len=%zu\n",
-- 
2.20.1

