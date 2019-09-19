Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5782B86DE
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406447AbfISWcY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:32:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:52424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391082AbfISWNS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:13:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D748218AF;
        Thu, 19 Sep 2019 22:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931198;
        bh=bIpGUdrS+JV8vhdNWybDE/iiWT1MOmLAzGfz+nmxwkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pn0shuJH2/a8tI3tj7iaa7DBIXSKuZVk3nUy1N06ApMOQCfRi17MDDL2tFHKPwIZ7
         4lBuyVe80DJTxPOjDIYbby/n/U7Nnb3UHNunvgLtQkj5QI39UdmSsH7B2HX9At7r34
         44GtHnkeeFS7avzSYizCt/YPAWa2CvoCcDzb1TBg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 37/79] NFSv4: Fix return value in nfs_finish_open()
Date:   Fri, 20 Sep 2019 00:03:22 +0200
Message-Id: <20190919214811.001252972@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214807.612593061@linuxfoundation.org>
References: <20190919214807.612593061@linuxfoundation.org>
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
index 71b2e390becf2..b8d6860879528 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1486,7 +1486,7 @@ static int nfs_finish_open(struct nfs_open_context *ctx,
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



