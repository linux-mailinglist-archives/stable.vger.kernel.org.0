Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E889613F127
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:27:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390717AbgAPS0u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:26:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:35520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403977AbgAPR0f (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:26:35 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15A59246D4;
        Thu, 16 Jan 2020 17:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195594;
        bh=pZ1XnrvHf1IPiLRXxbEExVOtWong9/zjiiEtZtGOJzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hHp7uJeKLVal196D/wg9MFkl4NFIMGa9M4yAzTjrYWczaTku3OWF/uCi+Jgnme3Xi
         NxFYlA1KVJBm2Hu/igjyD/fgI4KfmvqXeLPesJ3ntm5fFu6Z87k/E9pjgqqfR4AYLm
         UK2v7SAJb04ZONOlny3+xsqJQPnUoVyiO1Sh4z68=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trondmy@gmail.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 172/371] NFS: Don't interrupt file writeout due to fatal errors
Date:   Thu, 16 Jan 2020 12:20:44 -0500
Message-Id: <20200116172403.18149-115-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trondmy@gmail.com>

[ Upstream commit 14bebe3c90b326d2a0df78aed5e9de090c71d878 ]

When flushing out dirty pages, the fact that we may hit fatal errors
is not a reason to stop writeback. Those errors are reported through
fsync(), not through the flush mechanism.

Fixes: a6598813a4c5b ("NFS: Don't write back further requests if there...")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/write.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 01b9d9341b54..ed3f5afc4ff7 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -643,7 +643,7 @@ static int nfs_page_async_flush(struct nfs_pageio_descriptor *pgio,
 	return ret;
 out_launder:
 	nfs_write_error_remove_page(req);
-	return ret;
+	return 0;
 }
 
 static int nfs_do_writepage(struct page *page, struct writeback_control *wbc,
-- 
2.20.1

