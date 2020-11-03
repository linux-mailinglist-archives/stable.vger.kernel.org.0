Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFAC2A549A
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389096AbgKCVMy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:12:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:55510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389092AbgKCVMx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:12:53 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73F48206B5;
        Tue,  3 Nov 2020 21:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437973;
        bh=JXPGxJRDp7PlOYH8alET6KGPLUiaU+blm6Ne4oIWc5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l7JuWHihWGQGfCB3dSIkeJYl+brgR5bjss1Lt8ugj2ChjVfDqQwADcySD/5GlwF3R
         zQT7EHTMXT2fQNcq5vbiNFt360tY4gD9nI8S6LfNW1o/KcseeUCAPwuWvFSCf10iox
         YAVLxAlN4QNrVX4iS2IiKi3lWzRU1qBrcSrHvAd8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 4.14 103/125] libceph: clear con->out_msg on Policy::stateful_server faults
Date:   Tue,  3 Nov 2020 21:38:00 +0100
Message-Id: <20201103203212.065767127@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203156.372184213@linuxfoundation.org>
References: <20201103203156.372184213@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Dryomov <idryomov@gmail.com>

commit 28e1581c3b4ea5f98530064a103c6217bedeea73 upstream.

con->out_msg must be cleared on Policy::stateful_server
(!CEPH_MSG_CONNECT_LOSSY) faults.  Not doing so botches the
reconnection attempt, because after writing the banner the
messenger moves on to writing the data section of that message
(either from where it got interrupted by the connection reset or
from the beginning) instead of writing struct ceph_msg_connect.
This results in a bizarre error message because the server
sends CEPH_MSGR_TAG_BADPROTOVER but we think we wrote struct
ceph_msg_connect:

  libceph: mds0 (1)172.21.15.45:6828 socket error on write
  ceph: mds0 reconnect start
  libceph: mds0 (1)172.21.15.45:6829 socket closed (con state OPEN)
  libceph: mds0 (1)172.21.15.45:6829 protocol version mismatch, my 32 != server's 32
  libceph: mds0 (1)172.21.15.45:6829 protocol version mismatch

AFAICT this bug goes back to the dawn of the kernel client.
The reason it survived for so long is that only MDS sessions
are stateful and only two MDS messages have a data section:
CEPH_MSG_CLIENT_RECONNECT (always, but reconnecting is rare)
and CEPH_MSG_CLIENT_REQUEST (only when xattrs are involved).
The connection has to get reset precisely when such message
is being sent -- in this case it was the former.

Cc: stable@vger.kernel.org
Link: https://tracker.ceph.com/issues/47723
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ceph/messenger.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -3007,6 +3007,11 @@ static void con_fault(struct ceph_connec
 		ceph_msg_put(con->in_msg);
 		con->in_msg = NULL;
 	}
+	if (con->out_msg) {
+		BUG_ON(con->out_msg->con != con);
+		ceph_msg_put(con->out_msg);
+		con->out_msg = NULL;
+	}
 
 	/* Requeue anything that hasn't been acked */
 	list_splice_init(&con->out_sent, &con->out_queue);


