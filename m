Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6545C41356F
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 16:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233699AbhIUOhP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 10:37:15 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:40851 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233701AbhIUOhP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 10:37:15 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0Up8yjG5_1632234933;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0Up8yjG5_1632234933)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 21 Sep 2021 22:35:44 +0800
From:   Gao Xiang <hsiangkao@linux.alibaba.com>
To:     linux-erofs@lists.ozlabs.org, Chao Yu <chao@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Gao Xiang <hsiangkao@linux.alibaba.com>, stable@vger.kernel.org
Subject: [PATCH 1/2] erofs: fix up erofs_lookup tracepoint
Date:   Tue, 21 Sep 2021 22:35:30 +0800
Message-Id: <20210921143531.81356-1-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix up a misuse that the filename pointer isn't always valid in
the ring buffer, and we should copy the content instead.

Fixes: 13f06f48f7bf ("staging: erofs: support tracepoint")
Cc: stable@vger.kernel.org # 4.19+
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 include/trace/events/erofs.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/trace/events/erofs.h b/include/trace/events/erofs.h
index bf9806f..db4f2ce 100644
--- a/include/trace/events/erofs.h
+++ b/include/trace/events/erofs.h
@@ -35,20 +35,20 @@
 	TP_STRUCT__entry(
 		__field(dev_t,		dev	)
 		__field(erofs_nid_t,	nid	)
-		__field(const char *,	name	)
+		__string(name,		dentry->d_name.name	)
 		__field(unsigned int,	flags	)
 	),
 
 	TP_fast_assign(
 		__entry->dev	= dir->i_sb->s_dev;
 		__entry->nid	= EROFS_I(dir)->nid;
-		__entry->name	= dentry->d_name.name;
+		__assign_str(name, dentry->d_name.name);
 		__entry->flags	= flags;
 	),
 
 	TP_printk("dev = (%d,%d), pnid = %llu, name:%s, flags:%x",
 		show_dev_nid(__entry),
-		__entry->name,
+		__get_str(name),
 		__entry->flags)
 );
 
-- 
1.8.3.1

