Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6272ACA5C6
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404438AbfJCQgg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:36:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:45868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404434AbfJCQgf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:36:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED6E22086A;
        Thu,  3 Oct 2019 16:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120594;
        bh=aOmStEXpth9Ho7NutSuDgtWs7bvLiWs/8qUkr+s1Yvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kyrlwBxpwMxKufYPe4mkpB78XlScWdwVymkRGRjEhHPAMFYk52ysXUCQwysVup6Zm
         yg36SdF7thoglDhvm1KBwtleUN5tT3niRwNoBQbI9DsbbkK9zWff+7qgucA/ZbztgG
         XHrMeWCvk15Si9jyMukKiNwT03nvxWKkOYzlcM2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve French <stfrench@microsoft.com>,
        Pavel Shilovsky <pshilov@microsoft.com>
Subject: [PATCH 5.2 279/313] smb3: fix leak in "open on server" perf counter
Date:   Thu,  3 Oct 2019 17:54:17 +0200
Message-Id: <20191003154600.540731635@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
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
@@ -1167,6 +1169,7 @@ smb2_set_ea(const unsigned int xid, stru
 
 	rc = compound_send_recv(xid, ses, flags, 3, rqst,
 				resp_buftype, rsp_iov);
+	/* no need to bump num_remote_opens because handle immediately closed */
 
  sea_exit:
 	kfree(ea);
@@ -1488,6 +1491,8 @@ smb2_ioctl_query_info(const unsigned int
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
@@ -2263,6 +2263,7 @@ int smb311_posix_mkdir(const unsigned in
 	rqst.rq_iov = iov;
 	rqst.rq_nvec = n_iov;
 
+	/* no need to inc num_remote_opens because we close it just below */
 	trace_smb3_posix_mkdir_enter(xid, tcon->tid, ses->Suid, CREATE_NOT_FILE,
 				    FILE_WRITE_ATTRIBUTES);
 	/* resource #4: response buffer */


