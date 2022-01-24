Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3834B49A4C1
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2369610AbiAYACO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:02:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1574354AbiAXX2Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:28:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5711EC0A54D9;
        Mon, 24 Jan 2022 13:32:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14576B80FA1;
        Mon, 24 Jan 2022 21:32:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D86C7C340E4;
        Mon, 24 Jan 2022 21:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059971;
        bh=GzbYbsXc5BwyTSbLqMt453HSpU4UrE4xgXx+YQpBbjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b5ITBnkli9wJz6Uk5mClsU/jdyT5pdKGeI/lSITuKtuWjOVZoMaqBO08x8lCGdflM
         4uFH4ovVnZEN2rE0L7stJfAdFXauUEOSD5BSGkgKl+dzp6vEB+1LeFgXWLB7Bc++lX
         4CYpX7bqFM0ROFFb37BtlgOhnTJyjUei+a2F6dWM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+9ca499bb57a2b9e4c652@syzkaller.appspotmail.com,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0763/1039] udf: Fix error handling in udf_new_inode()
Date:   Mon, 24 Jan 2022 19:42:32 +0100
Message-Id: <20220124184150.964657576@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit f05f2429eec60851b98bdde213de31dab697c01b ]

When memory allocation of iinfo or block allocation fails, already
allocated struct udf_inode_info gets freed with iput() and
udf_evict_inode() may look at inode fields which are not properly
initialized. Fix it by marking inode bad before dropping reference to it
in udf_new_inode().

Reported-by: syzbot+9ca499bb57a2b9e4c652@syzkaller.appspotmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/ialloc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/udf/ialloc.c b/fs/udf/ialloc.c
index 2ecf0e87660e3..b5d611cee749c 100644
--- a/fs/udf/ialloc.c
+++ b/fs/udf/ialloc.c
@@ -77,6 +77,7 @@ struct inode *udf_new_inode(struct inode *dir, umode_t mode)
 					GFP_KERNEL);
 	}
 	if (!iinfo->i_data) {
+		make_bad_inode(inode);
 		iput(inode);
 		return ERR_PTR(-ENOMEM);
 	}
@@ -86,6 +87,7 @@ struct inode *udf_new_inode(struct inode *dir, umode_t mode)
 			      dinfo->i_location.partitionReferenceNum,
 			      start, &err);
 	if (err) {
+		make_bad_inode(inode);
 		iput(inode);
 		return ERR_PTR(err);
 	}
-- 
2.34.1



