Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB56206624
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388276AbgFWViD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:38:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:49566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388107AbgFWUIf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:08:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92FE22078A;
        Tue, 23 Jun 2020 20:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942915;
        bh=HA8aiIuaasPxl1vbmOhAxA5aPPqvNiOAcyQJmQvdG/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ey5p5ot4IaxpWGusCbOw2AtKtuZSKzsLMwN+2hFgPBuwl7s9krAaB5Mk0a5l7lz2c
         5NCNsMjUGIqQcrlsg20LM9NTMwFSCyNVgI9LXEN8xrXxGuBXrV+vgKMMqL5F6TpX5n
         WSjO08W8ut5DbQqh4TohKGrfXxFg1mKAiEqSSMfk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 186/477] f2fs: fix potential use-after-free issue
Date:   Tue, 23 Jun 2020 21:53:03 +0200
Message-Id: <20200623195416.379459620@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit f3494345ce9999624b36109252a4bf5f00e51a46 ]

In error path of f2fs_read_multi_pages(), it should let last referrer
release decompress io context memory, otherwise, other referrer will
cause use-after-free issue.

Fixes: 4c8ff7095bef ("f2fs: support data compression")
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index cdf2f626bea7a..10491ae1cb850 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2130,16 +2130,16 @@ submit_and_realloc:
 					page->index, for_write);
 			if (IS_ERR(bio)) {
 				ret = PTR_ERR(bio);
-				bio = NULL;
 				dic->failed = true;
 				if (refcount_sub_and_test(dic->nr_cpages - i,
-							&dic->ref))
+							&dic->ref)) {
 					f2fs_decompress_end_io(dic->rpages,
 							cc->cluster_size, true,
 							false);
-				f2fs_free_dic(dic);
+					f2fs_free_dic(dic);
+				}
 				f2fs_put_dnode(&dn);
-				*bio_ret = bio;
+				*bio_ret = NULL;
 				return ret;
 			}
 		}
-- 
2.25.1



