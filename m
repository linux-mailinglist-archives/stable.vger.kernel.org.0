Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D37333B684
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbhCON6B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:58:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:34534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231998AbhCON53 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:57:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AB5B64EF9;
        Mon, 15 Mar 2021 13:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816649;
        bh=1avx2fmdYPQmOKmxt4i8FIMz9NoVJrIbxZW3s5w1V4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eg6GWKn2hIncJddSRP26BWBKN9fwFhuhaABGczNSj5fRSUR3PUZBykZvuHlhode1N
         XiRm0kejqvGXjQ+K3loJ38eNTjOhnPv0yMVJL5t7lbzDTVkP57MSGqKuQjkO6ZGQZ5
         dRemtOHk/wNGYbF8IG6vsOrqZtPBUD/KgYjTJmSc=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Aurelien Aptel <aaptel@suse.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.11 041/306] cifs: return proper error code in statfs(2)
Date:   Mon, 15 Mar 2021 14:51:44 +0100
Message-Id: <20210315135509.029598541@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Paulo Alcantara <pc@cjr.nz>

commit 14302ee3301b3a77b331cc14efb95bf7184c73cc upstream.

In cifs_statfs(), if server->ops->queryfs is not NULL, then we should
use its return value rather than always returning 0.  Instead, use rc
variable as it is properly set to 0 in case there is no
server->ops->queryfs.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
CC: <stable@vger.kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cifsfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -290,7 +290,7 @@ cifs_statfs(struct dentry *dentry, struc
 		rc = server->ops->queryfs(xid, tcon, cifs_sb, buf);
 
 	free_xid(xid);
-	return 0;
+	return rc;
 }
 
 static long cifs_fallocate(struct file *file, int mode, loff_t off, loff_t len)


