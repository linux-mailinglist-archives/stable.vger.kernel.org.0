Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF128127D51
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 15:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727564AbfLTOct (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 09:32:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:34780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727903AbfLTOau (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Dec 2019 09:30:50 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36D3A24691;
        Fri, 20 Dec 2019 14:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576852250;
        bh=yncMnTIlVeBDgGpkBuy+C4FVdWGC/AeEWtvv41q7wLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J2T2anbFEL1ePDhmZx6qaxnIV+KNSwX6EEoMRjs9RWcnNL+bkxcR7ny043G4KSgzY
         w9Q05dZ+ikQ3IWadl1iA8B7BM1v0+QZfOi+h8Km+ICdvULsBOEmfaVbYFy5hnW+9Wg
         p0HMroSpZ3w2SntZdLTfiw5bsQ4Q3SybtZ5tSAoE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Jonathan Billings <jsbillings@jsbillings.org>,
        Marc Dionne <marc.dionne@auristor.com>,
        Sasha Levin <sashal@kernel.org>, linux-afs@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 41/52] afs: Fix mountpoint parsing
Date:   Fri, 20 Dec 2019 09:29:43 -0500
Message-Id: <20191220142954.9500-41-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191220142954.9500-1-sashal@kernel.org>
References: <20191220142954.9500-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 158d58335393af3956a9c06f0816ee75ed1f1447 ]

Each AFS mountpoint has strings that define the target to be mounted.  This
is required to end in a dot that is supposed to be stripped off.  The
string can include suffixes of ".readonly" or ".backup" - which are
supposed to come before the terminal dot.  To add to the confusion, the "fs
lsmount" afs utility does not show the terminal dot when displaying the
string.

The kernel mount source string parser, however, assumes that the terminal
dot marks the suffix and that the suffix is always "" and is thus ignored.
In most cases, there is no suffix and this is not a problem - but if there
is a suffix, it is lost and this affects the ability to mount the correct
volume.

The command line mount command, on the other hand, is expected not to
include a terminal dot - so the problem doesn't arise there.

Fix this by making sure that the dot exists and then stripping it when
passing the string to the mount configuration.

Fixes: bec5eb614130 ("AFS: Implement an autocell mount capability [ver #2]")
Reported-by: Jonathan Billings <jsbillings@jsbillings.org>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Marc Dionne <marc.dionne@auristor.com>
Tested-by: Jonathan Billings <jsbillings@jsbillings.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/mntpt.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/afs/mntpt.c b/fs/afs/mntpt.c
index f532d6d3bd28c..79bc5f1338edf 100644
--- a/fs/afs/mntpt.c
+++ b/fs/afs/mntpt.c
@@ -126,7 +126,7 @@ static int afs_mntpt_set_params(struct fs_context *fc, struct dentry *mntpt)
 		if (src_as->cell)
 			ctx->cell = afs_get_cell(src_as->cell);
 
-		if (size > PAGE_SIZE - 1)
+		if (size < 2 || size > PAGE_SIZE - 1)
 			return -EINVAL;
 
 		page = read_mapping_page(d_inode(mntpt)->i_mapping, 0, NULL);
@@ -140,7 +140,9 @@ static int afs_mntpt_set_params(struct fs_context *fc, struct dentry *mntpt)
 		}
 
 		buf = kmap(page);
-		ret = vfs_parse_fs_string(fc, "source", buf, size);
+		ret = -EINVAL;
+		if (buf[size - 1] == '.')
+			ret = vfs_parse_fs_string(fc, "source", buf, size - 1);
 		kunmap(page);
 		put_page(page);
 		if (ret < 0)
-- 
2.20.1

