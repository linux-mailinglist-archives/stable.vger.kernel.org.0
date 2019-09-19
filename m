Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C839FB869B
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404454AbfISWaY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:30:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:56596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404443AbfISWQQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:16:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DE15218AF;
        Thu, 19 Sep 2019 22:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931375;
        bh=dLATFpVow7aojoKfxCGuwrnTgzpLrr1z4QSTjwV1B5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RzeMSQJ6HuOs+UNwYPKk28dAvdohi7k0/5/pyXZoUYuGxY2SA6TKEflOhimUo3r2o
         zMWjHKJmYc7wBeGfXAPyQuAQSc+nUcC61VJJhPS4+12adIoUc6N8GJ3ohlYOUU5Ef6
         kgNnq86vy2NB+nzF2MDpIot+7z0cnE4BRPuLz4M8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 23/59] NFSv4: Fix return value in nfs_finish_open()
Date:   Fri, 20 Sep 2019 00:03:38 +0200
Message-Id: <20190919214803.970032400@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214755.852282682@linuxfoundation.org>
References: <20190919214755.852282682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 9821421a291b548ef4369c6998745baa36ddecd5 ]

If the file turns out to be of the wrong type after opening, we want
to revalidate the path and retry, so return EOPENSTALE rather than
ESTALE.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 85a6fdd76e20b..50c181fa00251 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1470,7 +1470,7 @@ static int nfs_finish_open(struct nfs_open_context *ctx,
 	if (S_ISREG(file->f_path.dentry->d_inode->i_mode))
 		nfs_file_set_open_context(file, ctx);
 	else
-		err = -ESTALE;
+		err = -EOPENSTALE;
 out:
 	return err;
 }
-- 
2.20.1



