Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03FFAB8645
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405485AbfISW16 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:27:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:34014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393974AbfISWUJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:20:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E9F021924;
        Thu, 19 Sep 2019 22:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931608;
        bh=9bpHPLsDOpYikVS9tUwi031DN+m6WQ/rT07qfg7aNoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JhxxtlGYuMqptdjIBcaJgKjrvtVR6RcHGZb9PaxmMiPq9sVPft5uA9dY/klj6WdlT
         80BAiL+HXVoylJMHNrUySV4FEL2ChkhS2+da9XNmio8OTO+LyEvwLT3HbQ70/z8/89
         R2htj+vOb/IZ5BTfAdXROE71jRkydjBttJre63+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 49/74] NFS: Fix initialisation of I/O result struct in nfs_pgio_rpcsetup
Date:   Fri, 20 Sep 2019 00:04:02 +0200
Message-Id: <20190919214809.516240428@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214800.519074117@linuxfoundation.org>
References: <20190919214800.519074117@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 17d8c5d145000070c581f2a8aa01edc7998582ab ]

Initialise the result count to 0 rather than initialising it to the
argument count. The reason is that we want to ensure we record the
I/O stats correctly in the case where an error is returned (for
instance in the layoutstats).

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/pagelist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/pagelist.c b/fs/nfs/pagelist.c
index fad4d5188aafa..b6e25126a0b0f 100644
--- a/fs/nfs/pagelist.c
+++ b/fs/nfs/pagelist.c
@@ -562,7 +562,7 @@ static void nfs_pgio_rpcsetup(struct nfs_pgio_header *hdr,
 	}
 
 	hdr->res.fattr   = &hdr->fattr;
-	hdr->res.count   = count;
+	hdr->res.count   = 0;
 	hdr->res.eof     = 0;
 	hdr->res.verf    = &hdr->verf;
 	nfs_fattr_init(&hdr->fattr);
-- 
2.20.1



