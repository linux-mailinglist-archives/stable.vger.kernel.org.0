Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1F2378589
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235343AbhEJLAo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:00:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:53006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234375AbhEJK4S (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:56:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE8E56198C;
        Mon, 10 May 2021 10:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643529;
        bh=Z3zbLFrt1kd0pnZjb2bGHBwq1sjxWyOmHIxibJATDVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vM4mxqaCMPy5cZVgl4N0RDIabfsWpluhUWdhY2q7KOH+ccqPkAQlf3CMrGXQruJYR
         vaDqLjp/rtayEUxEDRprYz8/vMmY3haAPcDFA5I50y3p91sEBXEp4hd8zZZtkTQ+Kc
         zG7VOw+IvF3EkBL/tJAgU2NdDBt+12WP5E07eqA8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Eugene Korenevsky <ekorenevsky@astralinux.ru>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.11 050/342] cifs: fix out-of-bound memory access when calling smb3_notify() at mount point
Date:   Mon, 10 May 2021 12:17:20 +0200
Message-Id: <20210510102011.782444451@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugene Korenevsky <ekorenevsky@astralinux.ru>

commit a637f4ae037e1e0604ac008564934d63261a8fd1 upstream.

If smb3_notify() is called at mount point of CIFS, build_path_from_dentry()
returns the pointer to kmalloc-ed memory with terminating zero (this is
empty FileName to be passed to SMB2 CREATE request). This pointer is assigned
to the `path` variable.
Then `path + 1` (to skip first backslash symbol) is passed to
cifs_convert_path_to_utf16(). This is incorrect for empty path and causes
out-of-bound memory access.

Get rid of this "increase by one". cifs_convert_path_to_utf16() already
contains the check for leading backslash in the path.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=212693
CC: <stable@vger.kernel.org> # v5.6+
Signed-off-by: Eugene Korenevsky <ekorenevsky@astralinux.ru>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb2ops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2201,7 +2201,7 @@ smb3_notify(const unsigned int xid, stru
 
 	cifs_sb = CIFS_SB(inode->i_sb);
 
-	utf16_path = cifs_convert_path_to_utf16(path + 1, cifs_sb);
+	utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
 	if (utf16_path == NULL) {
 		rc = -ENOMEM;
 		goto notify_exit;


