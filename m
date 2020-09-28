Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88A3A27A690
	for <lists+stable@lfdr.de>; Mon, 28 Sep 2020 06:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725290AbgI1Eee (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 00:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725287AbgI1Eee (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Sep 2020 00:34:34 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E83C0613CE;
        Sun, 27 Sep 2020 21:34:34 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id r8so7165690qtp.13;
        Sun, 27 Sep 2020 21:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ConN5YtggiLZaASBU/xhEJXmwHgM4GQ65dyhnJrPmKk=;
        b=OrlsG6iY/WL5irP3rXRNnjtGc56SmCJs8yUie1qT2CuBx8PrpgdAPajrULbDH6Sgq7
         qCO36BJigflKxgOCPvImeGOk/TfyxOxBUnyM63pU2/zICbHCuJBOmmBzJmFPItIxF+Of
         +ph+zQbnED8a6cI8weOnECZf3ezV2MPTroNlV2kjtj+9HIc+7uXaZ1yVwZpHP6bzxKmh
         4D+Dkq7q+Y2rRUCLQiDa5ewPQimCZsPLVMFMpAXb5xcSQpfu8p2hILzDWVzPcXU3xU2D
         G9Ah+GjMCqo8u3APwPkBpEw5wT1Zh5/uSS4zzooasWJTxSZncR7lkb8GVvIRU5zpabIg
         9UcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ConN5YtggiLZaASBU/xhEJXmwHgM4GQ65dyhnJrPmKk=;
        b=dl59cDRCug6luCb5q2fM/WlZUf0AkK5wxD/CCkoIPaJVeRV8Ap3XMUha2VwMpzgBHN
         HHcOg7vqtTeiISRzT3MTOu+mYm1oeLegL/NEWbRZ9I3bzZosYD3i0l65IrndJv+axlnj
         MgO2BKBsNbIYmE4Nu/nzgELYXU1edrBVoiHzvXnlUHDBhd5WmVv1jrTW6S1RK2gMTwCq
         xS2oha1BIdbR8+pd23BNzUu3mqKwqM6cCBnffiIJ8rUNbmcAv7D/NN5LMbNcLmagNZyb
         84kw14xFI9PL0P7X1Vdeluzp6Lb4U6rvi4t14p+aE9Pkd0+bIi8gVB8+r8FK/uyjJoXh
         LCLg==
X-Gm-Message-State: AOAM532kF5MLuw37zUXpQWsikCIlpuSpU7Qw2AlfYuXMoUDf+MYRwOaa
        iJ0aBKJMQUDfcrxIoFyP56w=
X-Google-Smtp-Source: ABdhPJz8BRI8cDTasymvP6TZXcGOJby0FLRXvRi8sd4J1cn8vBdqg/56lbKnZtWDQL6i1Kub6nBd5A==
X-Received: by 2002:ac8:39c5:: with SMTP id v63mr10887654qte.12.1601267673265;
        Sun, 27 Sep 2020 21:34:33 -0700 (PDT)
Received: from andromeda.markmielke.com ([2607:fea8:c260:8de::d020])
        by smtp.gmail.com with ESMTPSA id 202sm8427085qkg.56.2020.09.27.21.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2020 21:34:32 -0700 (PDT)
From:   Mark Mielke <mark.mielke@gmail.com>
To:     Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        Mark Mielke <mark.mielke@gmail.com>,
        Marc Dionne <marc.c.dionne@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] iscsi: iscsi_tcp: Avoid holding spinlock while calling getpeername
Date:   Mon, 28 Sep 2020 00:33:29 -0400
Message-Id: <20200928043329.606781-1-mark.mielke@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Kernel may fail to boot or devices may fail to come up when
initializing iscsi_tcp devices starting with Linux 5.8.

Marc Dionne identified the cause in RHBZ#1877345.

Commit a79af8a64d39 ("[SCSI] iscsi_tcp: use iscsi_conn_get_addr_param
libiscsi function") introduced getpeername() within the session spinlock.

Commit 1b66d253610c ("bpf: Add get{peer, sock}name attach types for
sock_addr") introduced BPF_CGROUP_RUN_SA_PROG_LOCK() within getpeername,
which acquires a mutex and when used from iscsi_tcp devices can now lead
to "BUG: scheduling while atomic:" and subsequent damage.

This commit ensures that the spinlock is released before calling
getpeername() or getsockname(). sock_hold() and sock_put() are
used to ensure that the socket reference is preserved until after
the getpeername() or getsockname() complete.

Reported-by: Marc Dionne <marc.c.dionne@gmail.com>
Link: https://bugzilla.redhat.com/show_bug.cgi?id=1877345
Link: https://lkml.org/lkml/2020/7/28/1085
Link: https://lkml.org/lkml/2020/8/31/459
Fixes: a79af8a64d39 ("[SCSI] iscsi_tcp: use iscsi_conn_get_addr_param libiscsi function")
Fixes: 1b66d253610c ("bpf: Add get{peer, sock}name attach types for sock_addr")
Signed-off-by: Mark Mielke <mark.mielke@gmail.com>
Cc: stable@vger.kernel.org
---
 drivers/scsi/iscsi_tcp.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index b5dd1caae5e9..d10efb66cf19 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -736,6 +736,7 @@ static int iscsi_sw_tcp_conn_get_param(struct iscsi_cls_conn *cls_conn,
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
 	struct sockaddr_in6 addr;
+	struct socket *sock;
 	int rc;
 
 	switch(param) {
@@ -747,13 +748,17 @@ static int iscsi_sw_tcp_conn_get_param(struct iscsi_cls_conn *cls_conn,
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
 
@@ -775,6 +780,7 @@ static int iscsi_sw_tcp_host_get_param(struct Scsi_Host *shost,
 	struct iscsi_tcp_conn *tcp_conn;
 	struct iscsi_sw_tcp_conn *tcp_sw_conn;
 	struct sockaddr_in6 addr;
+	struct socket *sock;
 	int rc;
 
 	switch (param) {
@@ -789,16 +795,18 @@ static int iscsi_sw_tcp_host_get_param(struct Scsi_Host *shost,
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
 
-- 
2.28.0

