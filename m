Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06273CA1DD
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731439AbfJCP7w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 11:59:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:43302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731434AbfJCP7w (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 11:59:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EB11222C9;
        Thu,  3 Oct 2019 15:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118391;
        bh=kEmCe5eFpDf0pcPFKgaycmMa56SMC86pe2QDKHFiby0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WDzpsgZduYtPLUfbxIdGmm01geD7xFAxFZx6PwolUPUtAe+pCUxRhtCHo0/Rad/BU
         K/q5rEJ2oKbZ3cwYGLjJFF6MgbM/DsA3SnrFCfsfCxtM3uj6QCFznWcIQxiCThuW+E
         AxbdEQzJCy+rQ7gI/aLx6i/6ybALNo9rM6yd9bFU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH 4.4 95/99] CIFS: Fix oplock handling for SMB 2.1+ protocols
Date:   Thu,  3 Oct 2019 17:53:58 +0200
Message-Id: <20191003154341.829350191@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154252.297991283@linuxfoundation.org>
References: <20191003154252.297991283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Shilovsky <pshilov@microsoft.com>

commit a016e2794fc3a245a91946038dd8f34d65e53cc3 upstream.

There may be situations when a server negotiates SMB 2.1
protocol version or higher but responds to a CREATE request
with an oplock rather than a lease.

Currently the client doesn't handle such a case correctly:
when another CREATE comes in the server sends an oplock
break to the initial CREATE and the client doesn't send
an ack back due to a wrong caching level being set (READ
instead of RWH). Missing an oplock break ack makes the
server wait until the break times out which dramatically
increases the latency of the second CREATE.

Fix this by properly detecting oplocks when using SMB 2.1
protocol version and higher.

Cc: <stable@vger.kernel.org>
Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/smb2ops.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1335,6 +1335,11 @@ smb21_set_oplock_level(struct cifsInodeI
 	if (oplock == SMB2_OPLOCK_LEVEL_NOCHANGE)
 		return;
 
+	/* Check if the server granted an oplock rather than a lease */
+	if (oplock & SMB2_OPLOCK_LEVEL_EXCLUSIVE)
+		return smb2_set_oplock_level(cinode, oplock, epoch,
+					     purge_cache);
+
 	if (oplock & SMB2_LEASE_READ_CACHING_HE) {
 		new_oplock |= CIFS_CACHE_READ_FLG;
 		strcat(message, "R");


