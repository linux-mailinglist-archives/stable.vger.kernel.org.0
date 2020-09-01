Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBE425932C
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729482AbgIAPWg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:22:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:44014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729431AbgIAPW0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:22:26 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52E7A206FA;
        Tue,  1 Sep 2020 15:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973745;
        bh=MEpVlEtJ7mHi7GnHi3IAk9pa/Z/9Y+l5hc46rXCGRaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TG/6s0KEeSPkRqTJmYDe56bA3I8qonOKFr29Ip+ZPPWsqmA+VKf9vmjPXoNiBx5fg
         PIVsrVl/qQsZw7s3tNJ9PmqEwvdbvTa9X/dSNSBWyFTXCkjLBVVAIq/djN5KH0K0+W
         JoVIDA/cxDam69KwXBgvIHDrIQxaLzY8hwzQMbyo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+f31428628ef672716ea8@syzkaller.appspotmail.com,
        Necip Fazil Yildiran <necip@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 004/125] net: qrtr: fix usage of idr in port assignment to socket
Date:   Tue,  1 Sep 2020 17:09:19 +0200
Message-Id: <20200901150934.800871779@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150934.576210879@linuxfoundation.org>
References: <20200901150934.576210879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Necip Fazil Yildiran <necip@google.com>

[ Upstream commit 8dfddfb79653df7c38a9c8c4c034f242a36acee9 ]

Passing large uint32 sockaddr_qrtr.port numbers for port allocation
triggers a warning within idr_alloc() since the port number is cast
to int, and thus interpreted as a negative number. This leads to
the rejection of such valid port numbers in qrtr_port_assign() as
idr_alloc() fails.

To avoid the problem, switch to idr_alloc_u32() instead.

Fixes: bdabad3e363d ("net: Add Qualcomm IPC router")
Reported-by: syzbot+f31428628ef672716ea8@syzkaller.appspotmail.com
Signed-off-by: Necip Fazil Yildiran <necip@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/qrtr/qrtr.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -554,23 +554,25 @@ static void qrtr_port_remove(struct qrtr
  */
 static int qrtr_port_assign(struct qrtr_sock *ipc, int *port)
 {
+	u32 min_port;
 	int rc;
 
 	mutex_lock(&qrtr_port_lock);
 	if (!*port) {
-		rc = idr_alloc(&qrtr_ports, ipc,
-			       QRTR_MIN_EPH_SOCKET, QRTR_MAX_EPH_SOCKET + 1,
-			       GFP_ATOMIC);
-		if (rc >= 0)
-			*port = rc;
+		min_port = QRTR_MIN_EPH_SOCKET;
+		rc = idr_alloc_u32(&qrtr_ports, ipc, &min_port, QRTR_MAX_EPH_SOCKET, GFP_ATOMIC);
+		if (!rc)
+			*port = min_port;
 	} else if (*port < QRTR_MIN_EPH_SOCKET && !capable(CAP_NET_ADMIN)) {
 		rc = -EACCES;
 	} else if (*port == QRTR_PORT_CTRL) {
-		rc = idr_alloc(&qrtr_ports, ipc, 0, 1, GFP_ATOMIC);
+		min_port = 0;
+		rc = idr_alloc_u32(&qrtr_ports, ipc, &min_port, 0, GFP_ATOMIC);
 	} else {
-		rc = idr_alloc(&qrtr_ports, ipc, *port, *port + 1, GFP_ATOMIC);
-		if (rc >= 0)
-			*port = rc;
+		min_port = *port;
+		rc = idr_alloc_u32(&qrtr_ports, ipc, &min_port, *port, GFP_ATOMIC);
+		if (!rc)
+			*port = min_port;
 	}
 	mutex_unlock(&qrtr_port_lock);
 


