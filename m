Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEFBF177FD3
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732276AbgCCRxE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:53:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:33488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731343AbgCCRxD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:53:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF0BF2072D;
        Tue,  3 Mar 2020 17:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257983;
        bh=7/tLskozrg4ixBT/OquLc2xq33BKnTZdZEOZh32dCUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zuRUinfxXMHz0L8eeWtZJp7PR9ZLwHNnMigI32t7ZpCRPU1zemt46g2iV7YrEC0Yw
         NcyM0mJmn20J84hl2ojNRDY/CGobGZfR2uaulsYdGiOdOFQPeAkFVfjm0iF/zn5mgn
         9WcLLBn5LhOd5bfxUDJ6BVy1YJK1B1qnYV9guefQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 027/152] dax: pass NOWAIT flag to iomap_apply
Date:   Tue,  3 Mar 2020 18:42:05 +0100
Message-Id: <20200303174305.537006772@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174302.523080016@linuxfoundation.org>
References: <20200303174302.523080016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 2cc43cd914eb8..cc56313c6b3b9 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1207,6 +1207,9 @@ dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
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



