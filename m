Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC07EEC99
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 22:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729717AbfKDV6q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:58:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:55778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730729AbfKDV6o (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:58:44 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B45CB214D9;
        Mon,  4 Nov 2019 21:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904724;
        bh=C3roP5wrC549HDqOhjYaF7T3usfv8aIrH4mKkQ3NbXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N1t1TUPG89RIOaGrzyDbdGaSwkfwEUioe8yCj5HR6lwaBqijMeA1lGBqP3nTAEaiT
         U+EjhYf/7YhLcx9W7TWqTcHhh0F+0l3oIBYIrF+8ctyt7kjNfE36I+KDa00awtJS0i
         ZcgTr1xsqExvCJZeSvcaSulh0uRMifMgm2NmHpQo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 048/149] CIFS: Respect SMB2 hdr preamble size in read responses
Date:   Mon,  4 Nov 2019 22:44:01 +0100
Message-Id: <20191104212139.466501121@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



