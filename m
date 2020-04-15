Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB2CE1AA08E
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 14:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S369366AbgDOM2x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 08:28:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:38226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409122AbgDOLpE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:45:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 549E421569;
        Wed, 15 Apr 2020 11:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586951104;
        bh=gESVvPTfx2xSpiVG8TxKGdtaWIy+comoS9exNaI75lo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qVTpbSfHzfMXILdQsdSdb4DXL94OZwhhzm/feb4bRLkhY3kwIHV62e+NSduWAue/I
         8WfvdaNXuO9Ilw5STL2hF+s1jSbkPk4OmzCTP4tU35lj3dkkZTcQGmAa9sVo1s7K/r
         +njORDEUgw0IDqGrYaB7q5z3voJNmsyNe8eKNjAk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Murphy Zhou <jencce.kernel@gmail.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 19/84] NFSv4.2: error out when relink swapfile
Date:   Wed, 15 Apr 2020 07:43:36 -0400
Message-Id: <20200415114442.14166-19-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114442.14166-1-sashal@kernel.org>
References: <20200415114442.14166-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Murphy Zhou <jencce.kernel@gmail.com>

[ Upstream commit f5fdf1243fb750598b46305dd03c553949cfa14f ]

This fixes xfstests generic/356 failure on NFSv4.2.

Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4file.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/nfs/nfs4file.c b/fs/nfs/nfs4file.c
index 54f1c1f626fc5..fb55c04cdc6bd 100644
--- a/fs/nfs/nfs4file.c
+++ b/fs/nfs/nfs4file.c
@@ -210,6 +210,9 @@ static loff_t nfs42_remap_file_range(struct file *src_file, loff_t src_off,
 	if (remap_flags & ~REMAP_FILE_ADVISORY)
 		return -EINVAL;
 
+	if (IS_SWAPFILE(dst_inode) || IS_SWAPFILE(src_inode))
+		return -ETXTBSY;
+
 	/* check alignment w.r.t. clone_blksize */
 	ret = -EINVAL;
 	if (bs) {
-- 
2.20.1

