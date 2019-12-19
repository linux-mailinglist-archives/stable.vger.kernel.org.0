Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB4C3126BE5
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729860AbfLSSwy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:52:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:47638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730289AbfLSSwv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:52:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C178F20674;
        Thu, 19 Dec 2019 18:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781571;
        bh=Kh6G4BGpbP4/7ZLkRXwjPM16uNGZAWbqwyulwAiVOQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h5B8p6HsnesooB+uqT5AuQRMzl4IeyUXurEVc44ntk+8elFjaa7uzydIY928W5kLI
         CWQjasGBtsS0oGMz9tx9Jpq3E6DSl/0DdW9o53Lf2xawItp3xmZImH5chXlUgWFHv9
         Hbe5Ywseq/l325TMQfKbNFLZdUWPWSdhvAT8cXb4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Long Li <longli@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 4.19 32/47] cifs: smbd: Add messages on RDMA session destroy and reconnection
Date:   Thu, 19 Dec 2019 19:34:46 +0100
Message-Id: <20191219182935.051730593@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219182857.659088743@linuxfoundation.org>
References: <20191219182857.659088743@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Long Li <longli@microsoft.com>

commit d63cdbae60ac6fbb2864bd3d8df7404f12b7407d upstream.

Log these activities to help production support.

Signed-off-by: Long Li <longli@microsoft.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/smbdirect.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -1491,6 +1491,7 @@ void smbd_destroy(struct smbd_connection
 		info->transport_status == SMBD_DESTROYED);
 
 	destroy_workqueue(info->workqueue);
+	log_rdma_event(INFO,  "rdma session destroyed\n");
 	kfree(info);
 }
 
@@ -1528,8 +1529,9 @@ create_conn:
 	log_rdma_event(INFO, "creating rdma session\n");
 	server->smbd_conn = smbd_get_connection(
 		server, (struct sockaddr *) &server->dstaddr);
-	log_rdma_event(INFO, "created rdma session info=%p\n",
-		server->smbd_conn);
+
+	if (server->smbd_conn)
+		cifs_dbg(VFS, "RDMA transport re-established\n");
 
 	return server->smbd_conn ? 0 : -ENOENT;
 }


