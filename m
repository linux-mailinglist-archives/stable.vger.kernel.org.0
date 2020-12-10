Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD782D6246
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 17:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390527AbgLJP7T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 10:59:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:44876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388002AbgLJOh7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:37:59 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.9 22/75] cifs: allow syscalls to be restarted in __smb_send_rqst()
Date:   Thu, 10 Dec 2020 15:26:47 +0100
Message-Id: <20201210142607.148484368@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142606.074509102@linuxfoundation.org>
References: <20201210142606.074509102@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paulo Alcantara <pc@cjr.nz>

commit 6988a619f5b79e4efadea6e19dcfe75fbcd350b5 upstream.

A customer has reported that several files in their multi-threaded app
were left with size of 0 because most of the read(2) calls returned
-EINTR and they assumed no bytes were read.  Obviously, they could
have fixed it by simply retrying on -EINTR.

We noticed that most of the -EINTR on read(2) were due to real-time
signals sent by glibc to process wide credential changes (SIGRT_1),
and its signal handler had been established with SA_RESTART, in which
case those calls could have been automatically restarted by the
kernel.

Let the kernel decide to whether or not restart the syscalls when
there is a signal pending in __smb_send_rqst() by returning
-ERESTARTSYS.  If it can't, it will return -EINTR anyway.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
CC: Stable <stable@vger.kernel.org>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/transport.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -339,8 +339,8 @@ __smb_send_rqst(struct TCP_Server_Info *
 		return -EAGAIN;
 
 	if (signal_pending(current)) {
-		cifs_dbg(FYI, "signal is pending before sending any data\n");
-		return -EINTR;
+		cifs_dbg(FYI, "signal pending before send request\n");
+		return -ERESTARTSYS;
 	}
 
 	/* cork the socket */


