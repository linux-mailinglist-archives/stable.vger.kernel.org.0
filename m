Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21B80B85BA
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407131AbfISWYM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:24:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:40232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407126AbfISWYK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:24:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9462321929;
        Thu, 19 Sep 2019 22:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931850;
        bh=ZnDZXhBIRGN6OWMGxYRviA8kQtnsHMHEhPRM7nl7h60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yte8qhvcRP9MDSpBEcddV9UMGqJ7KRn1A5bl3dRZ+lOVAusy7Ucl4F5nKtww9ffZa
         W530S/aMgb34nBDtNs4lovmYSpZdVtoo9aiiPefpTtn2JAcDU4/AbtjOannQOqcjXi
         SMbl6/vQukUp2BMUyuPSrBW0re3FlbA0lzLlZCN8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 38/56] NFSv4: Fix return values for nfs4_file_open()
Date:   Fri, 20 Sep 2019 00:04:19 +0200
Message-Id: <20190919214758.710383344@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214742.483643642@linuxfoundation.org>
References: <20190919214742.483643642@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 90cf500e338ab3f3c0f126ba37e36fb6a9058441 ]

Currently, we are translating RPC level errors such as timeouts,
as well as interrupts etc into EOPENSTALE, which forces a single
replay of the open attempt. What we actually want to do is
force the replay only in the cases where the returned error
indicates that the file may have changed on the server.

So the fix is to spell out the exact set of errors where we want
to return EOPENSTALE.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4file.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/nfs/nfs4file.c b/fs/nfs/nfs4file.c
index d3e3761eacfa2..c5e884585c23a 100644
--- a/fs/nfs/nfs4file.c
+++ b/fs/nfs/nfs4file.c
@@ -73,13 +73,13 @@ nfs4_file_open(struct inode *inode, struct file *filp)
 	if (IS_ERR(inode)) {
 		err = PTR_ERR(inode);
 		switch (err) {
-		case -EPERM:
-		case -EACCES:
-		case -EDQUOT:
-		case -ENOSPC:
-		case -EROFS:
-			goto out_put_ctx;
 		default:
+			goto out_put_ctx;
+		case -ENOENT:
+		case -ESTALE:
+		case -EISDIR:
+		case -ENOTDIR:
+		case -ELOOP:
 			goto out_drop;
 		}
 	}
-- 
2.20.1



