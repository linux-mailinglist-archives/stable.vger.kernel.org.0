Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13FEA3CDA52
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244223AbhGSOfd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:35:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:47024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245536AbhGSOen (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:34:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B4386128E;
        Mon, 19 Jul 2021 15:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707652;
        bh=cgQeWa6VY+L9UnqvCofy0cc87uTZTbvmtNzBafYrQEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hrv/QlawUh4qdsbAAr/timFCdm2DL56WjGH2byshdh/HDen+ldunalB8vlmlWeRj8
         MNDdsxT9uHPwkNvGrZY5Mmgkp+R1DMFPKughZiBrV24yzr+vLLzCUYseLArUB+c1TO
         cJg57ivWXtBuS2cDzxzrLTB9gbH9J10cqWtTGl/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Marshall <hubcap@omnibond.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 216/245] orangefs: fix orangefs df output.
Date:   Mon, 19 Jul 2021 16:52:38 +0200
Message-Id: <20210719144947.370813955@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marshall <hubcap@omnibond.com>

[ Upstream commit 0fdec1b3c9fbb5e856a40db5993c9eaf91c74a83 ]

Orangefs df output is whacky. Walt Ligon suggested this might fix it.
It seems way more in line with reality now...

Signed-off-by: Mike Marshall <hubcap@omnibond.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/orangefs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/orangefs/super.c b/fs/orangefs/super.c
index 6e35ef6521b4..8972ebc87016 100644
--- a/fs/orangefs/super.c
+++ b/fs/orangefs/super.c
@@ -185,7 +185,7 @@ static int orangefs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_bavail = (sector_t) new_op->downcall.resp.statfs.blocks_avail;
 	buf->f_files = (sector_t) new_op->downcall.resp.statfs.files_total;
 	buf->f_ffree = (sector_t) new_op->downcall.resp.statfs.files_avail;
-	buf->f_frsize = sb->s_blocksize;
+	buf->f_frsize = 0;
 
 out_op_release:
 	op_release(new_op);
-- 
2.30.2



