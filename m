Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C02E6147CE4
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729351AbgAXJzS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:55:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:58460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726701AbgAXJzS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:55:18 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F495206D5;
        Fri, 24 Jan 2020 09:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859718;
        bh=lXMmNVPGOzXutVT+BEzC2h53HK83CcbMiFQ/30mAHNo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pg6wlfp1I1ECo/QGJwECXwqXPIUpQzEErh9RcfmQj+kHG3rPyS5EW3YCIOUP2VNP5
         Kb7WrF2QF3nMeABF3u1WydWjZrrM+ed/w9g7utgSx4Waaz8hlnQ5I6QdpwrfC6HRsv
         c0sK6p2RzqvUsfuzNGKvdsf2gGXfcTYrhHwUhoAc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 178/343] NFS: Dont interrupt file writeout due to fatal errors
Date:   Fri, 24 Jan 2020 10:29:56 +0100
Message-Id: <20200124092943.410476024@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 01b9d9341b541..ed3f5afc4ff7f 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -643,7 +643,7 @@ out:
 	return ret;
 out_launder:
 	nfs_write_error_remove_page(req);
-	return ret;
+	return 0;
 }
 
 static int nfs_do_writepage(struct page *page, struct writeback_control *wbc,
-- 
2.20.1



