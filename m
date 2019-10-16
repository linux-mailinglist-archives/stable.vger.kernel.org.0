Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E14DDD9C0B
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 22:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437305AbfJPUwm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 16:52:42 -0400
Received: from linux.microsoft.com ([13.77.154.182]:58846 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437299AbfJPUwk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Oct 2019 16:52:40 -0400
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id 74F4120B9C01; Wed, 16 Oct 2019 13:52:39 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 74F4120B9C01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1571259159;
        bh=4sfYqfNcpqUyQQbNHu50T1zrwYwZAKGk5e7iBBIfSaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:Reply-To:From;
        b=fEJ5jG1S1MwamTnSlDlKPEPKPQZoloArDSkK1MWu89vIhffBH8pIzueXDS3OyoKRe
         hOpdrnE4BABVWf5KhMLqSS2oASgx141KJp5415iAzkLTiOMdBMZX9O6hlD0nVyeisd
         Kam0Tmk3Iiy6f4NIs+n4nQ54gqqU/u4GhABEWH5c=
From:   longli@linuxonhyperv.com
To:     Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Cc:     Long Li <longli@microsoft.com>, stable@vger.kernel.org
Subject: [PATCH 7/7] cifs: smbd: Return -EAGAIN when transport is reconnecting
Date:   Wed, 16 Oct 2019 13:51:56 -0700
Message-Id: <1571259116-102015-8-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1571259116-102015-1-git-send-email-longli@linuxonhyperv.com>
References: <1571259116-102015-1-git-send-email-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Long Li <longli@microsoft.com>

During reconnecting, the transport may have already been destroyed and is in
the process being reconnected. In this case, return -EAGAIN to not fail and
to retry this I/O.

Signed-off-by: Long Li <longli@microsoft.com>
Cc: stable@vger.kernel.org
---
 fs/cifs/transport.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index afe66f9cb15e..66fde7bfec4f 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -318,8 +318,11 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
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
 
-- 
2.17.1

