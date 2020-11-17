Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01E7D2B632B
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732305AbgKQNfh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:35:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:46432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732052AbgKQNff (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:35:35 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 997BA2467A;
        Tue, 17 Nov 2020 13:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620135;
        bh=sW56ZONulphTJNrzR+SU5Sy5PAkV0u1J025vu7So/C8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1KJSBD1TuAgb4GSN1/K8uNA6Ij3YXcDWDWQLUPOaxpCiZMGdskrHKGlwo564amfVp
         SxSKxTjCo9HwfSA8HWHZ6rB8gvSONJTUJV0Ulo0gUfvZPD+9aGnXnWGYGbF4Prpl0m
         wYgvNipZTqVe+we77IOlaL/IFq9L4aksSzSbGqSE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 091/255] gfs2: check for live vs. read-only file system in gfs2_fitrim
Date:   Tue, 17 Nov 2020 14:03:51 +0100
Message-Id: <20201117122143.388063276@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

[ Upstream commit c5c68724696e7d2f8db58a5fce3673208d35c485 ]

Before this patch, gfs2_fitrim was not properly checking for a "live" file
system. If the file system had something to trim and the file system
was read-only (or spectator) it would start the trim, but when it starts
the transaction, gfs2_trans_begin returns -EROFS (read-only file system)
and it errors out. However, if the file system was already trimmed so
there's no work to do, it never called gfs2_trans_begin. That code is
bypassed so it never returns the error. Instead, it returns a good
return code with 0 work. All this makes for inconsistent behavior:
The same fstrim command can return -EROFS in one case and 0 in another.
This tripped up xfstests generic/537 which reports the error as:

    +fstrim with unrecovered metadata just ate your filesystem

This patch adds a check for a "live" (iow, active journal, iow, RW)
file system, and if not, returns the error properly.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/rgrp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 1d65db1b3914a..ac306895bbbcc 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1374,6 +1374,9 @@ int gfs2_fitrim(struct file *filp, void __user *argp)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
+	if (!test_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags))
+		return -EROFS;
+
 	if (!blk_queue_discard(q))
 		return -EOPNOTSUPP;
 
-- 
2.27.0



