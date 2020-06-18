Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7C31FE770
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbgFRBMP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:12:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:40706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728130AbgFRBMO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:12:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5ED61214DB;
        Thu, 18 Jun 2020 01:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442734;
        bh=lPWevka9QnhGex3BOVrY8374uXhUL2P30uuTNmrKqfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y0Uo7i9IJG/Iy8tyfI0xLnpOifkpjgq1r6voEe41Qu2Q8Z5QGwSW3c1baRveiRhGf
         q9Dls4qVaGp975hP9ug6hTjyzpDFcGXgGxrNxZMKSsijCXWet9NFcM7Ko91ur0chQn
         FDIoIag/poageRlTpPIM9dcWnIKlFEdhH6+YoNPU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.7 189/388] f2fs: fix potential use-after-free issue
Date:   Wed, 17 Jun 2020 21:04:46 -0400
Message-Id: <20200618010805.600873-189-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index cdf2f626bea7..10491ae1cb85 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2130,16 +2130,16 @@ int f2fs_read_multi_pages(struct compress_ctx *cc, struct bio **bio_ret,
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

