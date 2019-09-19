Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D056EB86D3
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390577AbfISWcE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:32:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:52972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389084AbfISWNp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:13:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA51621927;
        Thu, 19 Sep 2019 22:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931225;
        bh=y+4/48mPRddCtsFRk2xtrrWt0Ag+cNN84eo2U1HHEZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Q0o5Am708jaEw4fuOA2NJxsQLfrZE2Q7TDuWjoBa+icZincs6bvNC6iAWzOxCq/M
         f64YyjlN5VjzzMYkn513Wq01Pl2X7Jjl0I5xPXo5+JYaEwO0ukzfC8GEbldiR0a1Hy
         6XlM4F7HaEUZR1KdjqXvuh6hUvYjgD3vhs4tfREM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 49/79] NFSv2: Fix eof handling
Date:   Fri, 20 Sep 2019 00:03:34 +0200
Message-Id: <20190919214811.846472108@linuxfoundation.org>
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

[ Upstream commit 71affe9be45a5c60b9772e1b2701710712637274 ]

If we received a reply from the server with a zero length read and
no error, then that implies we are at eof.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/proc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/proc.c b/fs/nfs/proc.c
index e0c257bd62b93..89fa9c706b380 100644
--- a/fs/nfs/proc.c
+++ b/fs/nfs/proc.c
@@ -594,7 +594,8 @@ static int nfs_read_done(struct rpc_task *task, struct nfs_pgio_header *hdr)
 		/* Emulate the eof flag, which isn't normally needed in NFSv2
 		 * as it is guaranteed to always return the file attributes
 		 */
-		if (hdr->args.offset + hdr->res.count >= hdr->res.fattr->size)
+		if ((hdr->res.count == 0 && hdr->args.count > 0) ||
+		    hdr->args.offset + hdr->res.count >= hdr->res.fattr->size)
 			hdr->res.eof = 1;
 	}
 	return 0;
-- 
2.20.1



