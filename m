Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83611CA75F
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391345AbfJCQxd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:53:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:41618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406434AbfJCQxd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:53:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B34820867;
        Thu,  3 Oct 2019 16:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121612;
        bh=+DVWTkRncnAFYcTVWYorCgHrV49Hd2VG5eUzOOfe5Qo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LRuKX5QLjpJ1V58e6GJwe6S/GjWfbL+8g8JIIcNDfw74ARYdsVOVXGZtUEV7ng7nk
         GAwRPBv4nYYeqSzUqZphP3uJnxgfwDaFbyHD1/yn52m1U9afjYrinu9JXfmlTeZi86
         rJcu+X8MYQN72LNmWGinr7VtW2RlQvaKkY2wJZDg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve French <stfrench@microsoft.com>,
        Pavel Shilovsky <pshilov@microsoft.com>
Subject: [PATCH 5.3 306/344] smb3: fix leak in "open on server" perf counter
Date:   Thu,  3 Oct 2019 17:54:31 +0200
Message-Id: <20191003154609.500567688@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

commit d2f15428d6a0ebfc0edc364094d7c4a2de7037ed upstream.

We were not bumping up the "open on server" (num_remote_opens)
counter (in some cases) on opens of the share root so
could end up showing as a negative value.

CC: Stable <stable@vger.kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/smb2ops.c |    5 +++++
 fs/cifs/smb2pdu.c |    1 +
 2 files changed, 6 insertions(+)

--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -743,6 +743,8 @@ int open_shroot(unsigned int xid, struct
 	if (rc)
 		goto oshr_exit;
 
+	atomic_inc(&tcon->num_remote_opens);
+
 	o_rsp = (struct smb2_create_rsp *)rsp_iov[0].iov_base;
 	oparms.fid->persistent_fid = o_rsp->PersistentFileId;
 	oparms.fid->volatile_fid = o_rsp->VolatileFileId;
@@ -1168,6 +1170,7 @@ smb2_set_ea(const unsigned int xid, stru
 
 	rc = compound_send_recv(xid, ses, flags, 3, rqst,
 				resp_buftype, rsp_iov);
+	/* no need to bump num_remote_opens because handle immediately closed */
 
  sea_exit:
 	kfree(ea);
@@ -1489,6 +1492,8 @@ smb2_ioctl_query_info(const unsigned int
 				resp_buftype, rsp_iov);
 	if (rc)
 		goto iqinf_exit;
+
+	/* No need to bump num_remote_opens since handle immediately closed */
 	if (qi.flags & PASSTHRU_FSCTL) {
 		pqi = (struct smb_query_info __user *)arg;
 		io_rsp = (struct smb2_ioctl_rsp *)rsp_iov[1].iov_base;
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2351,6 +2351,7 @@ int smb311_posix_mkdir(const unsigned in
 	rqst.rq_iov = iov;
 	rqst.rq_nvec = n_iov;
 
+	/* no need to inc num_remote_opens because we close it just below */
 	trace_smb3_posix_mkdir_enter(xid, tcon->tid, ses->Suid, CREATE_NOT_FILE,
 				    FILE_WRITE_ATTRIBUTES);
 	/* resource #4: response buffer */


