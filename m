Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E886433BA6E
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235660AbhCOOJL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:09:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:49974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231356AbhCOODg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:03:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC68264EF1;
        Mon, 15 Mar 2021 14:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615817015;
        bh=OsN9fP/3Q8x/uk2NpP+b5JvtzITPXV9VGc9C/iPEXmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fd/9gMAanGlnPqJmvpSzOsb5salbpoj99oPxa7dRvf9JJ5q9iKI5+ObqUqQXLzglN
         y9m0w5XUwDT7SXiYGELLMqtgCwIsaqfhdCOcM+8oyC+BDhf6xOlPoB4f0bmmBspo5a
         etEbWywEzhRkPj5WpFWHTQY50VnLkAcptXTYOhxw=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ondrej Mosnacek <omosnace@redhat.com>,
        James Morris <jamorris@linux.microsoft.com>,
        Paul Moore <paul@paul-moore.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 248/290] NFSv4.2: fix return value of _nfs4_get_security_label()
Date:   Mon, 15 Mar 2021 14:55:41 +0100
Message-Id: <20210315135550.399707805@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
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
index a811d42ffbd1..ba2dfba4854b 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -5967,7 +5967,7 @@ static int _nfs4_get_security_label(struct inode *inode, void *buf,
 		return ret;
 	if (!(fattr.valid & NFS_ATTR_FATTR_V4_SECURITY_LABEL))
 		return -ENOENT;
-	return 0;
+	return label.len;
 }
 
 static int nfs4_get_security_label(struct inode *inode, void *buf,
-- 
2.30.1



