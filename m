Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D55D433B502
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbhCONxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:53:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:55418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229518AbhCONwv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:52:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A41AD64EE5;
        Mon, 15 Mar 2021 13:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816371;
        bh=fzpaGEBxyyFF+uV4zhAqlogc261/N5VCcc4VzvBNPMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cY63ucPZQsmcVBcX3isq6y6NdMocqBQN3h7VTR/U7ff968R1EKppEVEH6/w7VY0mJ
         IdsWr/KoZW+p63ic6Y2wc1PutB3APbMUlIS3yLdxsus190MXz3c6u28mBkFgvNPpec
         gIfvGz+ADXhb59q+uCVuvlTdVZZKcgPEgvOZETjU=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Aurelien Aptel <aaptel@suse.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 4.4 08/75] cifs: return proper error code in statfs(2)
Date:   Mon, 15 Mar 2021 14:51:22 +0100
Message-Id: <20210315135208.537855031@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135208.252034256@linuxfoundation.org>
References: <20210315135208.252034256@linuxfoundation.org>
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
@@ -204,7 +204,7 @@ cifs_statfs(struct dentry *dentry, struc
 		rc = server->ops->queryfs(xid, tcon, buf);
 
 	free_xid(xid);
-	return 0;
+	return rc;
 }
 
 static long cifs_fallocate(struct file *file, int mode, loff_t off, loff_t len)


