Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3541D24B222
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbgHTJY1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:24:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:59916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726912AbgHTJYQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:24:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A1F022CE3;
        Thu, 20 Aug 2020 09:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915455;
        bh=sy/Uz6UT4Qh47LrCSZBXGxfv/cPwQ3qmUJiBgcdvSBw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X3nF1wx6lGCKQ5CdeSawk3K+YTuOCbewtQ3TiDHb6dcEhxYBHk93LA1QMACV6K9Sa
         qW6HNNVUFOvJwy4lxsGtPuvQ5bfzxjAcyDlgNo/lqPAF6vuyqxbDuG97FSrOZxn0dO
         pXSLhZx7plFQ2aif+KsD4oJIqHuZty34k6m6/xIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.8 002/232] smb3: warn on confusing error scenario with sec=krb5
Date:   Thu, 20 Aug 2020 11:17:33 +0200
Message-Id: <20200820091612.821749452@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

commit 0a018944eee913962bce8ffebbb121960d5125d9 upstream.

When mounting with Kerberos, users have been confused about the
default error returned in scenarios in which either keyutils is
not installed or the user did not properly acquire a krb5 ticket.
Log a warning message in the case that "ENOKEY" is returned
from the get_spnego_key upcall so that users can better understand
why mount failed in those two cases.

CC: Stable <stable@vger.kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/smb2pdu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1387,6 +1387,8 @@ SMB2_auth_kerberos(struct SMB2_sess_data
 	spnego_key = cifs_get_spnego_key(ses);
 	if (IS_ERR(spnego_key)) {
 		rc = PTR_ERR(spnego_key);
+		if (rc == -ENOKEY)
+			cifs_dbg(VFS, "Verify user has a krb5 ticket and keyutils is installed\n");
 		spnego_key = NULL;
 		goto out;
 	}


