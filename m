Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12395169434
	for <lists+stable@lfdr.de>; Sun, 23 Feb 2020 03:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729120AbgBWCYR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Feb 2020 21:24:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:54148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729042AbgBWCYQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 Feb 2020 21:24:16 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40C5422464;
        Sun, 23 Feb 2020 02:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582424656;
        bh=+4WPWUaGDWLShhdy5FaNvPbfl02ykHihgTT9PqSSayA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k3nvsnYMtUJ8E7He9fK3XluVy5ErBPbePaT2uj3qqS8RoeSzHVqTWUnolGZZ+Abr9
         ATZpKXCh8X91Y+J9MarZSr1MirQjdjLu8SsRPHbjapCGa96LDd/+wML+GQIobHWFdi
         TykNNCMJXZZxzbfzRdNLZBaYFK6yoQEOtqwtIZV8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Moyer <jmoyer@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Jan Kara <jack@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org,
        linux-nvdimm@lists.01.org
Subject: [PATCH AUTOSEL 4.14 03/21] dax: pass NOWAIT flag to iomap_apply
Date:   Sat, 22 Feb 2020 21:23:53 -0500
Message-Id: <20200223022411.2159-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200223022411.2159-1-sashal@kernel.org>
References: <20200223022411.2159-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Moyer <jmoyer@redhat.com>

[ Upstream commit 96222d53842dfe54869ec4e1b9d4856daf9105a2 ]

fstests generic/471 reports a failure when run with MOUNT_OPTIONS="-o
dax".  The reason is that the initial pwrite to an empty file with the
RWF_NOWAIT flag set does not return -EAGAIN.  It turns out that
dax_iomap_rw doesn't pass that flag through to iomap_apply.

With this patch applied, generic/471 passes for me.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/x49r1z86e1d.fsf@segfault.boston.devel.redhat.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dax.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/dax.c b/fs/dax.c
index ddb4981ae32eb..34a55754164f4 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1057,6 +1057,9 @@ dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
 		lockdep_assert_held(&inode->i_rwsem);
 	}
 
+	if (iocb->ki_flags & IOCB_NOWAIT)
+		flags |= IOMAP_NOWAIT;
+
 	while (iov_iter_count(iter)) {
 		ret = iomap_apply(inode, pos, iov_iter_count(iter), flags, ops,
 				iter, dax_iomap_actor);
-- 
2.20.1

