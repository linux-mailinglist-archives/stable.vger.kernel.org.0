Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C75DA8BC9
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733306AbfIDQFk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 12:05:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:38904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732805AbfIDQCp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 12:02:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AC5D22CF5;
        Wed,  4 Sep 2019 16:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612964;
        bh=dz3ZAh8uhkziH89Cqtb57Ig1Dfn4IwRMxgvdjvoB64c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oZX6IIopNARhdhxtPJS8Y+OaAThreQJmNEpWwGcSLkGNl21OkGzwc13BhXHYcXhoj
         Wpd8nVOL5qOS6N+999ylyrJGae6GtOOrZDTsEq7EnJhj1KZ9yXI8cYYMJh93DeJcrp
         Sf3dgvVuMN4ami5Am2qmCbMFA0l2k2DAT3jrB/0s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 16/27] NFSv2: Fix eof handling
Date:   Wed,  4 Sep 2019 12:02:09 -0400
Message-Id: <20190904160220.4545-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904160220.4545-1-sashal@kernel.org>
References: <20190904160220.4545-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index b7bca83039895..f3e8bcbd29a09 100644
--- a/fs/nfs/proc.c
+++ b/fs/nfs/proc.c
@@ -588,7 +588,8 @@ static int nfs_read_done(struct rpc_task *task, struct nfs_pgio_header *hdr)
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

