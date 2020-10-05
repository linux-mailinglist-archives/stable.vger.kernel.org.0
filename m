Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AFCE283A1C
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbgJEPbU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:31:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:58184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726638AbgJEPbT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:31:19 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FDBF208B6;
        Mon,  5 Oct 2020 15:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911878;
        bh=Ri1jEqKkGjbOMA1+5tMXGvPymNdNnAvFOfNi9Xd4TWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x5IsrURNAEXiHAgQNJJ+3iy6DETRQ34R0EHvInA2OzzUhIEwUf81IsQrcknRQIxOq
         8WSwGHlFjBSkSkQevpiIzqhOWf5c1+h9NjcBkkyAjymh0uKpMP2iPjo+sTT6cAUjbq
         9Vy+OEN31rQSu411Oim5DyOXAI0ylsBnDe6F2IPg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Dionne <marc.c.dionne@gmail.com>,
        Mike Christie <michael.christie@oracle.com>,
        Mark Mielke <mark.mielke@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.8 15/85] scsi: iscsi: iscsi_tcp: Avoid holding spinlock while calling getpeername()
Date:   Mon,  5 Oct 2020 17:26:11 +0200
Message-Id: <20201005142115.467090912@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142114.732094228@linuxfoundation.org>
References: <20201005142114.732094228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Mielke <mark.mielke@gmail.com>

commit bcf3a2953d36bbfb9bd44ccb3db0897d935cc485 upstream.

The kernel may fail to boot or devices may fail to come up when
initializing iscsi_tcp devices starting with Linux 5.8.

Commit a79af8a64d39 ("[SCSI] iscsi_tcp: use iscsi_conn_get_addr_param
libiscsi function") introduced getpeername() within the session spinlock.

Commit 1b66d253610c ("bpf: Add get{peer, sock}name attach types for
sock_addr") introduced BPF_CGROUP_RUN_SA_PROG_LOCK() within getpeername(),
which acquires a mutex and when used from iscsi_tcp devices can now lead to
"BUG: scheduling while atomic:" and subsequent damage.

Ensure that the spinlock is released before calling getpeername() or
getsockname(). sock_hold() and sock_put() are used to ensure that the
socket reference is preserved until after the getpeername() or
getsockname() complete.

Link: https://bugzilla.redhat.com/show_bug.cgi?id=1877345
Link: https://lkml.org/lkml/2020/7/28/1085
Link: https://lkml.org/lkml/2020/8/31/459
Link: https://lore.kernel.org/r/20200928043329.606781-1-mark.mielke@gmail.com
Fixes: a79af8a64d39 ("[SCSI] iscsi_tcp: use iscsi_conn_get_addr_param libiscsi function")
Fixes: 1b66d253610c ("bpf: Add get{peer, sock}name attach types for sock_addr")
Cc: stable@vger.kernel.org
Reported-by: Marc Dionne <marc.c.dionne@gmail.com>
Tested-by: Marc Dionne <marc.c.dionne@gmail.com>
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Mark Mielke <mark.mielke@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/iscsi_tcp.c |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -736,6 +736,7 @@ static int iscsi_sw_tcp_conn_get_param(s
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
 	struct sockaddr_in6 addr;
+	struct socket *sock;
 	int rc;
 
 	switch(param) {
@@ -747,13 +748,17 @@ static int iscsi_sw_tcp_conn_get_param(s
 			spin_unlock_bh(&conn->session->frwd_lock);
 			return -ENOTCONN;
 		}
+		sock = tcp_sw_conn->sock;
+		sock_hold(sock->sk);
+		spin_unlock_bh(&conn->session->frwd_lock);
+
 		if (param == ISCSI_PARAM_LOCAL_PORT)
-			rc = kernel_getsockname(tcp_sw_conn->sock,
+			rc = kernel_getsockname(sock,
 						(struct sockaddr *)&addr);
 		else
-			rc = kernel_getpeername(tcp_sw_conn->sock,
+			rc = kernel_getpeername(sock,
 						(struct sockaddr *)&addr);
-		spin_unlock_bh(&conn->session->frwd_lock);
+		sock_put(sock->sk);
 		if (rc < 0)
 			return rc;
 
@@ -775,6 +780,7 @@ static int iscsi_sw_tcp_host_get_param(s
 	struct iscsi_tcp_conn *tcp_conn;
 	struct iscsi_sw_tcp_conn *tcp_sw_conn;
 	struct sockaddr_in6 addr;
+	struct socket *sock;
 	int rc;
 
 	switch (param) {
@@ -789,16 +795,18 @@ static int iscsi_sw_tcp_host_get_param(s
 			return -ENOTCONN;
 		}
 		tcp_conn = conn->dd_data;
-
 		tcp_sw_conn = tcp_conn->dd_data;
-		if (!tcp_sw_conn->sock) {
+		sock = tcp_sw_conn->sock;
+		if (!sock) {
 			spin_unlock_bh(&session->frwd_lock);
 			return -ENOTCONN;
 		}
+		sock_hold(sock->sk);
+		spin_unlock_bh(&session->frwd_lock);
 
-		rc = kernel_getsockname(tcp_sw_conn->sock,
+		rc = kernel_getsockname(sock,
 					(struct sockaddr *)&addr);
-		spin_unlock_bh(&session->frwd_lock);
+		sock_put(sock->sk);
 		if (rc < 0)
 			return rc;
 


