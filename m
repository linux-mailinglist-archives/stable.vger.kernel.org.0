Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA9C6126BB6
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727529AbfLSS6r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:58:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:49796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730312AbfLSSyV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:54:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A398B222C2;
        Thu, 19 Dec 2019 18:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781661;
        bh=8KfN9n0apjAZczFVWmMcdIxJcfcU/E5vQf1i1tp5uIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VLhmXMYDLpJYxKMKd95D2Wl/L7rJbYEPk6E7rVT0esRA+CC1fITNYpoIkObQtogGm
         Uc9S9Fo4tzOCtzr/hxqLk30gYZJ3CQU9QSpCxw/niK54iwHxQKmWaTGCVaXQUQ9CAW
         VDhG5ZV9G2hVnjxN5CQdWxmVMVBbQnMmyQNFVzig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Long Li <longli@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.4 28/80] cifs: smbd: Return -EAGAIN when transport is reconnecting
Date:   Thu, 19 Dec 2019 19:34:20 +0100
Message-Id: <20191219183103.389385952@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183031.278083125@linuxfoundation.org>
References: <20191219183031.278083125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Long Li <longli@microsoft.com>

commit 4357d45f50e58672e1d17648d792f27df01dfccd upstream.

During reconnecting, the transport may have already been destroyed and is in
the process being reconnected. In this case, return -EAGAIN to not fail and
to retry this I/O.

Signed-off-by: Long Li <longli@microsoft.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/transport.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -319,8 +319,11 @@ __smb_send_rqst(struct TCP_Server_Info *
 	int val = 1;
 	__be32 rfc1002_marker;
 
-	if (cifs_rdma_enabled(server) && server->smbd_conn) {
-		rc = smbd_send(server, num_rqst, rqst);
+	if (cifs_rdma_enabled(server)) {
+		/* return -EAGAIN when connecting or reconnecting */
+		rc = -EAGAIN;
+		if (server->smbd_conn)
+			rc = smbd_send(server, num_rqst, rqst);
 		goto smbd_done;
 	}
 


