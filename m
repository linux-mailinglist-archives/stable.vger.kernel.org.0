Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56F1B1ECDB
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbfEOLC3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:02:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:59720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727926AbfEOLC2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:02:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C4BC2173C;
        Wed, 15 May 2019 11:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918147;
        bh=OTPcD5rIptUhakShi0cZu09JIZv7Pw/PrX7p3jBGavk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pKtyMW6gitX3FaOcOla/3/kxy6VsObb9MeM+5utxGkDCiZnrkRfwgVMl3NbuecP1Q
         5Z3lJtjTBHOPKgGp/JaM68hkutJja4okcFGmesNZK6MlaZd3q+g5iv797/N9qddh8t
         alyWW+iK4mJ8QZHQ3MpYnFQlhv6sBYPfq6nwhHSQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frank Sorenson <sorenson@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH 4.4 003/266] cifs: do not attempt cifs operation on smb2+ rename error
Date:   Wed, 15 May 2019 12:51:50 +0200
Message-Id: <20190515090722.802053821@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frank Sorenson <sorenson@redhat.com>

commit 652727bbe1b17993636346716ae5867627793647 upstream.

A path-based rename returning EBUSY will incorrectly try opening
the file with a cifs (NT Create AndX) operation on an smb2+ mount,
which causes the server to force a session close.

If the mount is smb2+, skip the fallback.

Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
CC: Stable <stable@vger.kernel.org>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/inode.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1669,6 +1669,10 @@ cifs_do_rename(const unsigned int xid, s
 	if (rc == 0 || rc != -EBUSY)
 		goto do_rename_exit;
 
+	/* Don't fall back to using SMB on SMB 2+ mount */
+	if (server->vals->protocol_id != 0)
+		goto do_rename_exit;
+
 	/* open-file renames don't work across directories */
 	if (to_dentry->d_parent != from_dentry->d_parent)
 		goto do_rename_exit;


