Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3E7433BA55
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235459AbhCOOI5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:08:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:49580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234317AbhCOODM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:03:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3EA1664EEF;
        Mon, 15 Mar 2021 14:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816991;
        bh=XFnEJAJEGP1dMB9+leoyqbn0dOzO/j7o4mhWP36zdiE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BwlcehKWP5ruTcdaqkGv+BJ2TlNlmm0Sp/3atSXPh/t2gG8OgU4jAthm5NDOX/+6t
         r7opNO9Bj69hTYqlhKAxQ6rKE692dMJ9pUcChYW2PnPwpMUgjOZNOVSBX0njuIdEFP
         ain1kBryFo7Wsn6lPqTmbBUjgaONzDvRwFrhB33M=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ondrej Mosnacek <omosnace@redhat.com>,
        James Morris <jamorris@linux.microsoft.com>,
        Paul Moore <paul@paul-moore.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 248/306] NFSv4.2: fix return value of _nfs4_get_security_label()
Date:   Mon, 15 Mar 2021 14:55:11 +0100
Message-Id: <20210315135516.028281292@linuxfoundation.org>
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

From: Ondrej Mosnacek <omosnace@redhat.com>

[ Upstream commit 53cb245454df5b13d7063162afd7a785aed6ebf2 ]

An xattr 'get' handler is expected to return the length of the value on
success, yet _nfs4_get_security_label() (and consequently also
nfs4_xattr_get_nfs4_label(), which is used as an xattr handler) returns
just 0 on success.

Fix this by returning label.len instead, which contains the length of
the result.

Fixes: aa9c2669626c ("NFS: Client implementation of Labeled-NFS")
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
Reviewed-by: James Morris <jamorris@linux.microsoft.com>
Reviewed-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index fc8bbfd9beb3..7eb44f37558c 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -5972,7 +5972,7 @@ static int _nfs4_get_security_label(struct inode *inode, void *buf,
 		return ret;
 	if (!(fattr.valid & NFS_ATTR_FATTR_V4_SECURITY_LABEL))
 		return -ENOENT;
-	return 0;
+	return label.len;
 }
 
 static int nfs4_get_security_label(struct inode *inode, void *buf,
-- 
2.30.1



