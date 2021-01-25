Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46B74304A94
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730622AbhAZFCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:02:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:37342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729140AbhAYSv7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:51:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4EC32224D4;
        Mon, 25 Jan 2021 18:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600700;
        bh=L0Qp7PhH17kthonGmjN4nMEHUWMGrxvxtbev0IxJl1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mgy0PExgfzSIld5IQ/GJy6RpTJIR64D298x6k1rvOiXBdjVHTe7KVtTHoU0nLa0cK
         OzxuqleVitlLgc1pkXCKhV6H0nZlP5J20Gr+A1GBQigm3ALJNNjvPvkS/U8er9ujfd
         0AXcnwGnwsdvJdU7nkwNxusO78JYBx+X6iI5K+9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.10 117/199] cifs: do not fail __smb_send_rqst if non-fatal signals are pending
Date:   Mon, 25 Jan 2021 19:38:59 +0100
Message-Id: <20210125183221.172800351@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

commit 214a5ea081e77346e4963dd6d20c5539ff8b6ae6 upstream.

RHBZ 1848178

The original intent of returning an error in this function
in the patch:
  "CIFS: Mask off signals when sending SMB packets"
was to avoid interrupting packet send in the middle of
sending the data (and thus breaking an SMB connection),
but we also don't want to fail the request for non-fatal
signals even before we have had a chance to try to
send it (the reported problem could be reproduced e.g.
by exiting a child process when the parent process was in
the midst of calling futimens to update a file's timestamps).

In addition, since the signal may remain pending when we enter the
sending loop, we may end up not sending the whole packet before
TCP buffers become full. In this case the code returns -EINTR
but what we need here is to return -ERESTARTSYS instead to
allow system calls to be restarted.

Fixes: b30c74c73c78 ("CIFS: Mask off signals when sending SMB packets")
Cc: stable@vger.kernel.org # v5.1+
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/transport.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -338,7 +338,7 @@ __smb_send_rqst(struct TCP_Server_Info *
 	if (ssocket == NULL)
 		return -EAGAIN;
 
-	if (signal_pending(current)) {
+	if (fatal_signal_pending(current)) {
 		cifs_dbg(FYI, "signal pending before send request\n");
 		return -ERESTARTSYS;
 	}
@@ -429,7 +429,7 @@ unmask:
 
 	if (signal_pending(current) && (total_len != send_length)) {
 		cifs_dbg(FYI, "signal is pending after attempt to send\n");
-		rc = -EINTR;
+		rc = -ERESTARTSYS;
 	}
 
 	/* uncork it */


