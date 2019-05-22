Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B67B26CC1
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 21:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729767AbfEVThT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:37:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:53910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732774AbfEVTa1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:30:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55D942173C;
        Wed, 22 May 2019 19:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553427;
        bh=2tdx0dv/iRRHc+bjoP1rVr48kmKTYBJAsaMm6nfp5zg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PoeDWukp7tgzByDrSm/gwL8fSvDLaE7B0ZLPgNG75JKvE1Y1cCinfFRR4OzzSoCAM
         psqc/FPNn946fksyyKKnyAF4ZWCVojRxyIPlviUuijJh96tNJe91XPbgUOXxj0T6bE
         O3QOSlJ/jO7hfDOVCx2s2r5N4N6j9ydf9yJuQmP8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Brandenburg <martin@omnibond.com>,
        Mike Marshall <hubcap@omnibond.com>,
        Sasha Levin <sashal@kernel.org>, devel@lists.orangefs.org
Subject: [PATCH AUTOSEL 4.9 006/114] orangefs: truncate before updating size
Date:   Wed, 22 May 2019 15:28:29 -0400
Message-Id: <20190522193017.26567-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522193017.26567-1-sashal@kernel.org>
References: <20190522193017.26567-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Brandenburg <martin@omnibond.com>

[ Upstream commit 33713cd09ccdc1e01b10d0782ae60200d4989553 ]

Otherwise we race with orangefs_writepage/orangefs_writepages
which and does not expect i_size < page_offset.

Fixes xfstests generic/129.

Signed-off-by: Martin Brandenburg <martin@omnibond.com>
Signed-off-by: Mike Marshall <hubcap@omnibond.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/orangefs/inode.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/orangefs/inode.c b/fs/orangefs/inode.c
index 08ecdeebd6f70..c85c5f9b17036 100644
--- a/fs/orangefs/inode.c
+++ b/fs/orangefs/inode.c
@@ -176,7 +176,11 @@ static int orangefs_setattr_size(struct inode *inode, struct iattr *iattr)
 	}
 	orig_size = i_size_read(inode);
 
-	truncate_setsize(inode, iattr->ia_size);
+	/* This is truncate_setsize in a different order. */
+	truncate_pagecache(inode, iattr->ia_size);
+	i_size_write(inode, iattr->ia_size);
+	if (iattr->ia_size > orig_size)
+		pagecache_isize_extended(inode, orig_size, iattr->ia_size);
 
 	new_op = op_alloc(ORANGEFS_VFS_OP_TRUNCATE);
 	if (!new_op)
-- 
2.20.1

