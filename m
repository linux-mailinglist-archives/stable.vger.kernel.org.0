Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F34A2E6500
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389163AbgL1Neb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:34:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:34712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390321AbgL1Nea (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:34:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1E91205CB;
        Mon, 28 Dec 2020 13:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162455;
        bh=X/5QmdreLT8WbOj+BvR2dssysUSvBKT3Em5Dr5jmVq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZooXevMq8ysyEgq3tMP894deCwq3xfBnmcso8kXpW9SoxE++dcf9pqBPwnwNpqG+B
         Mb2N4XvJfXEroPtodKjuPoouKQ1JNmWYxr7EzE8OoUI3GQ39VJf5p8diGnPrs6iLOc
         gYVumQzfQqtitTQvfdI9Ad3atsPgYZueo+H5Kk4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 4.19 309/346] SMB3: avoid confusing warning message on mount to Azure
Date:   Mon, 28 Dec 2020 13:50:28 +0100
Message-Id: <20201228124934.731360898@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

commit ebcd6de98754d9b6a5f89d7835864b1c365d432f upstream.

Mounts to Azure cause an unneeded warning message in dmesg
   "CIFS: VFS: parse_server_interfaces: incomplete interface info"

Azure rounds up the size (by 8 additional bytes, to a
16 byte boundary) of the structure returned on the query
of the server interfaces at mount time.  This is permissible
even though different than other servers so do not log a warning
if query network interfaces response is only rounded up by 8
bytes or fewer.

CC: Stable <stable@vger.kernel.org>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/smb2ops.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -366,7 +366,8 @@ parse_server_interfaces(struct network_i
 		goto out;
 	}
 
-	if (bytes_left || p->Next)
+	/* Azure rounds the buffer size up 8, to a 16 byte boundary */
+	if ((bytes_left > 8) || p->Next)
 		cifs_dbg(VFS, "%s: incomplete interface info\n", __func__);
 
 


