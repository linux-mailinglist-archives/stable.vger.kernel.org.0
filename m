Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBA54A24F4
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 20:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729371AbfH2SPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 14:15:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:57354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729359AbfH2SPh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 14:15:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E59A72342B;
        Thu, 29 Aug 2019 18:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102536;
        bh=dVA703rK6IxI1rxx+YY4+dmvvsctabIC5SH1lxPtYk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c01ddU3jx7RgTp3wkQ15q0qg8czrN6kjezGq1bLpOcUGoOpjQ5JcnXaXzf4JxADKH
         3dW6PSIwSx5rHN/V8aPfIBl/BJYXlTbOCpmkk6v3Nb5AFWIc0vdCUvDpRfqP8l95GU
         4OIBm7YsNd67yyvEeyEbsF2bMmCpvXFSgSiSoVNk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-afs@lists.infradead.org
Subject: [PATCH AUTOSEL 5.2 71/76] afs: Fix possible oops in afs_lookup trace event
Date:   Thu, 29 Aug 2019 14:13:06 -0400
Message-Id: <20190829181311.7562-71-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829181311.7562-1-sashal@kernel.org>
References: <20190829181311.7562-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Dionne <marc.dionne@auristor.com>

[ Upstream commit c4c613ff08d92e72bf64a65ec35a2c3aa1cfcd06 ]

The afs_lookup trace event can cause the following:

[  216.576777] BUG: kernel NULL pointer dereference, address: 000000000000023b
[  216.576803] #PF: supervisor read access in kernel mode
[  216.576813] #PF: error_code(0x0000) - not-present page
...
[  216.576913] RIP: 0010:trace_event_raw_event_afs_lookup+0x9e/0x1c0 [kafs]

If the inode from afs_do_lookup() is an error other than ENOENT, or if it
is ENOENT and afs_try_auto_mntpt() returns an error, the trace event will
try to dereference the error pointer as a valid pointer.

Use IS_ERR_OR_NULL to only pass a valid pointer for the trace, or NULL.

Ideally the trace would include the error value, but for now just avoid
the oops.

Fixes: 80548b03991f ("afs: Add more tracepoints")
Signed-off-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/dir.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index da9563d62b327..c50cc3f6f4553 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -952,7 +952,8 @@ static struct dentry *afs_lookup(struct inode *dir, struct dentry *dentry,
 				 inode ? AFS_FS_I(inode) : NULL);
 	} else {
 		trace_afs_lookup(dvnode, &dentry->d_name,
-				 inode ? AFS_FS_I(inode) : NULL);
+				 IS_ERR_OR_NULL(inode) ? NULL
+				 : AFS_FS_I(inode));
 	}
 	return d;
 }
-- 
2.20.1

