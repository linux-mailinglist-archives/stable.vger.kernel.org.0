Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4597F2A58FF
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 23:04:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730803AbgKCUn7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:43:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:58480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730243AbgKCUn6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:43:58 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 487EF223C7;
        Tue,  3 Nov 2020 20:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436237;
        bh=yNyBLxwHgdgQetRTaf0yBDfH1gBNobKd9uSHAO2U/zM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g8/aW+j367/8pZm+JbOyC3dYmXTE9Ox7Fd58FCtpYXR9BpD3MjCZAHURSxIdD19IY
         O4ewOzGBFYiMFzJ69xsCpi0TpeX7opMMAQXU0DwD+N5olcscc+FzJ+OeLG38IQPWY9
         JZmkkxN/NqeowCIeTZMOFo50vbslRH4qIoqJPGcQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rohith Surabattula <rohiths@microsoft.com>,
        Aurelien Aptel <aaptel@suse.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 162/391] Handle STATUS_IO_TIMEOUT gracefully
Date:   Tue,  3 Nov 2020 21:33:33 +0100
Message-Id: <20201103203357.778420068@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rohith Surabattula <rohiths@microsoft.com>

[ Upstream commit 8e670f77c4a55013db6d23b962f9bf6673a5e7b6 ]

Currently STATUS_IO_TIMEOUT is not treated as retriable error.
It is currently mapped to ETIMEDOUT and returned to userspace
for most system calls. STATUS_IO_TIMEOUT is returned by server
in case of unavailability or throttling errors.

This patch will map the STATUS_IO_TIMEOUT to EAGAIN, so that it
can be retried. Also, added a check to drop the connection to
not overload the server in case of ongoing unavailability.

Signed-off-by: Rohith Surabattula <rohiths@microsoft.com>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifsglob.h     |  2 ++
 fs/cifs/connect.c      | 15 ++++++++++++++-
 fs/cifs/smb2maperror.c |  2 +-
 fs/cifs/smb2ops.c      | 15 +++++++++++++++
 4 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index b565d83ba89ed..5a491afafacc7 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -510,6 +510,8 @@ struct smb_version_operations {
 		      struct fiemap_extent_info *, u64, u64);
 	/* version specific llseek implementation */
 	loff_t (*llseek)(struct file *, struct cifs_tcon *, loff_t, int);
+	/* Check for STATUS_IO_TIMEOUT */
+	bool (*is_status_io_timeout)(char *buf);
 };
 
 struct smb_version_values {
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 9817a31a39db6..b8780a79a42a2 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -69,6 +69,9 @@ extern bool disable_legacy_dialects;
 #define TLINK_ERROR_EXPIRE	(1 * HZ)
 #define TLINK_IDLE_EXPIRE	(600 * HZ)
 
+/* Drop the connection to not overload the server */
+#define NUM_STATUS_IO_TIMEOUT   5
+
 enum {
 	/* Mount options that take no arguments */
 	Opt_user_xattr, Opt_nouser_xattr,
@@ -1117,7 +1120,7 @@ cifs_demultiplex_thread(void *p)
 	struct task_struct *task_to_wake = NULL;
 	struct mid_q_entry *mids[MAX_COMPOUND];
 	char *bufs[MAX_COMPOUND];
-	unsigned int noreclaim_flag;
+	unsigned int noreclaim_flag, num_io_timeout = 0;
 
 	noreclaim_flag = memalloc_noreclaim_save();
 	cifs_dbg(FYI, "Demultiplex PID: %d\n", task_pid_nr(current));
@@ -1213,6 +1216,16 @@ next_pdu:
 			continue;
 		}
 
+		if (server->ops->is_status_io_timeout &&
+		    server->ops->is_status_io_timeout(buf)) {
+			num_io_timeout++;
+			if (num_io_timeout > NUM_STATUS_IO_TIMEOUT) {
+				cifs_reconnect(server);
+				num_io_timeout = 0;
+				continue;
+			}
+		}
+
 		server->lstrp = jiffies;
 
 		for (i = 0; i < num_mids; i++) {
diff --git a/fs/cifs/smb2maperror.c b/fs/cifs/smb2maperror.c
index 7fde3775cb574..b004cf87692a7 100644
--- a/fs/cifs/smb2maperror.c
+++ b/fs/cifs/smb2maperror.c
@@ -488,7 +488,7 @@ static const struct status_to_posix_error smb2_error_map_table[] = {
 	{STATUS_PIPE_CONNECTED, -EIO, "STATUS_PIPE_CONNECTED"},
 	{STATUS_PIPE_LISTENING, -EIO, "STATUS_PIPE_LISTENING"},
 	{STATUS_INVALID_READ_MODE, -EIO, "STATUS_INVALID_READ_MODE"},
-	{STATUS_IO_TIMEOUT, -ETIMEDOUT, "STATUS_IO_TIMEOUT"},
+	{STATUS_IO_TIMEOUT, -EAGAIN, "STATUS_IO_TIMEOUT"},
 	{STATUS_FILE_FORCED_CLOSED, -EIO, "STATUS_FILE_FORCED_CLOSED"},
 	{STATUS_PROFILING_NOT_STARTED, -EIO, "STATUS_PROFILING_NOT_STARTED"},
 	{STATUS_PROFILING_NOT_STOPPED, -EIO, "STATUS_PROFILING_NOT_STOPPED"},
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 09e1cd320ee56..e2e53652193e6 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2346,6 +2346,17 @@ smb2_is_session_expired(char *buf)
 	return true;
 }
 
+static bool
+smb2_is_status_io_timeout(char *buf)
+{
+	struct smb2_sync_hdr *shdr = (struct smb2_sync_hdr *)buf;
+
+	if (shdr->Status == STATUS_IO_TIMEOUT)
+		return true;
+	else
+		return false;
+}
+
 static int
 smb2_oplock_response(struct cifs_tcon *tcon, struct cifs_fid *fid,
 		     struct cifsInodeInfo *cinode)
@@ -4816,6 +4827,7 @@ struct smb_version_operations smb20_operations = {
 	.make_node = smb2_make_node,
 	.fiemap = smb3_fiemap,
 	.llseek = smb3_llseek,
+	.is_status_io_timeout = smb2_is_status_io_timeout,
 };
 
 struct smb_version_operations smb21_operations = {
@@ -4916,6 +4928,7 @@ struct smb_version_operations smb21_operations = {
 	.make_node = smb2_make_node,
 	.fiemap = smb3_fiemap,
 	.llseek = smb3_llseek,
+	.is_status_io_timeout = smb2_is_status_io_timeout,
 };
 
 struct smb_version_operations smb30_operations = {
@@ -5026,6 +5039,7 @@ struct smb_version_operations smb30_operations = {
 	.make_node = smb2_make_node,
 	.fiemap = smb3_fiemap,
 	.llseek = smb3_llseek,
+	.is_status_io_timeout = smb2_is_status_io_timeout,
 };
 
 struct smb_version_operations smb311_operations = {
@@ -5137,6 +5151,7 @@ struct smb_version_operations smb311_operations = {
 	.make_node = smb2_make_node,
 	.fiemap = smb3_fiemap,
 	.llseek = smb3_llseek,
+	.is_status_io_timeout = smb2_is_status_io_timeout,
 };
 
 struct smb_version_values smb20_values = {
-- 
2.27.0



