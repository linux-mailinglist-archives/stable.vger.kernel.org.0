Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9836D1BC9E2
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731217AbgD1SnV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:43:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:35626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731219AbgD1SnV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:43:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DB3120575;
        Tue, 28 Apr 2020 18:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099400;
        bh=aT9hg1sNSwLGT6XuCK3dDWR6DyvsBM1bIaw3wIjbf28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CcOT7e2+XBIurtNVMBGnJ858hkWBciuBrtZMzqq5iRNdJEZhbRf5i/cfgjR6akm7O
         3j6WRTYIZNXA2c65CsIX5f1R8zY6fqR1Coy6ESq8BQVxO+f7Q5YY2DLE+jbWb1FF+n
         zhqIHbVOCmS1nvhU1LfmHjH+cr73VXPFwt0eIgGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Aurelien Aptel <aaptel@suse.com>
Subject: [PATCH 5.4 133/168] cifs: fix uninitialised lease_key in open_shroot()
Date:   Tue, 28 Apr 2020 20:25:07 +0200
Message-Id: <20200428182248.820379456@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182231.704304409@linuxfoundation.org>
References: <20200428182231.704304409@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paulo Alcantara <pc@cjr.nz>

commit 0fe0781f29dd8ab618999e6bda33c782ebbdb109 upstream.

SMB2_open_init() expects a pre-initialised lease_key when opening a
file with a lease, so set pfid->lease_key prior to calling it in
open_shroot().

This issue was observed when performing some DFS failover tests and
the lease key was never randomly generated.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
CC: Stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/smb2ops.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -664,6 +664,11 @@ int open_shroot(unsigned int xid, struct
 	if (smb3_encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
+	if (!server->ops->new_lease_key)
+		return -EIO;
+
+	server->ops->new_lease_key(pfid);
+
 	memset(rqst, 0, sizeof(rqst));
 	resp_buftype[0] = resp_buftype[1] = CIFS_NO_BUFFER;
 	memset(rsp_iov, 0, sizeof(rsp_iov));


