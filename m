Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 382AF21180E
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 03:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728682AbgGBBYj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 21:24:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:54804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728558AbgGBBX6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 21:23:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C896B2145D;
        Thu,  2 Jul 2020 01:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593653038;
        bh=sj7Mgy53uvCuBJN5AxCbcIf+Ao8fcs55/4IY3bzKD68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VdnRDpFu5v8J0eUxcnNL6EaglWISOwebQKUEVHTmsf18LOU358c5i8HQpxeL5FdrK
         0k0/Mhgu9TRStx8NKXfSUWmfAncppK/kbrtH4o+htTRcLplDOnzEYPviRHuTaVavXr
         00m8C4iaI4SaKNoavCAaQ/1vwUvOwn8TDdW1/BrQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tom Rix <trix@redhat.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 51/53] nfs: Fix memory leak of export_path
Date:   Wed,  1 Jul 2020 21:22:00 -0400
Message-Id: <20200702012202.2700645-51-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702012202.2700645-1-sashal@kernel.org>
References: <20200702012202.2700645-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

[ Upstream commit 4659ed7cc8514369043053463514408ca16ad6f3 ]

The try_location function is called within a loop by nfs_follow_referral.
try_location calls nfs4_pathname_string to created the export_path.
nfs4_pathname_string allocates the memory. export_path is stored in the
nfs_fs_context/fs_context structure similarly as hostname and source.
But whereas the ctx hostname and source are freed before assignment,
export_path is not.  So if there are multiple loops, the new export_path
will overwrite the old without the old being freed.

So call kfree for export_path.

Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4namespace.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfs/nfs4namespace.c b/fs/nfs/nfs4namespace.c
index a3ab6e219061b..873342308dc0d 100644
--- a/fs/nfs/nfs4namespace.c
+++ b/fs/nfs/nfs4namespace.c
@@ -308,6 +308,7 @@ static int try_location(struct fs_context *fc,
 	if (IS_ERR(export_path))
 		return PTR_ERR(export_path);
 
+	kfree(ctx->nfs_server.export_path);
 	ctx->nfs_server.export_path = export_path;
 
 	source = kmalloc(len + 1 + ctx->nfs_server.export_path_len + 1,
-- 
2.25.1

