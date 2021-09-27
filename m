Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC5EA418EAA
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 07:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232911AbhI0Fbf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 01:31:35 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:51114 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232910AbhI0Fbf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Sep 2021 01:31:35 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0Uphdb8W_1632720596;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0Uphdb8W_1632720596)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 27 Sep 2021 13:29:56 +0800
From:   Gao Xiang <hsiangkao@linux.alibaba.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     linux-erofs@lists.ozlabs.org,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Chao Yu <chao@kernel.org>
Subject: [PATCH 4.19.y RESEND] erofs: fix up erofs_lookup tracepoint
Date:   Mon, 27 Sep 2021 13:29:54 +0800
Message-Id: <20210927052954.136280-1-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <163266167710981@kroah.com>
References: <163266167710981@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 93368aab0efc87288cac65e99c9ed2e0ffc9e7d0 upstream.

Fix up a misuse that the filename pointer isn't always valid in
the ring buffer, and we should copy the content instead.

Link: https://lore.kernel.org/r/20210921143531.81356-1-hsiangkao@linux.alibaba.com
Fixes: 13f06f48f7bf ("staging: erofs: support tracepoint")
Cc: stable@vger.kernel.org # 4.19+
Reviewed-by: Chao Yu <chao@kernel.org>
[ Gao Xiang: resolve trivial conflicts for 4.19.y. ]
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
add missing upstream commit id...

 drivers/staging/erofs/include/trace/events/erofs.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/erofs/include/trace/events/erofs.h b/drivers/staging/erofs/include/trace/events/erofs.h
index 5aead93a762f..852c94176d1b 100644
--- a/drivers/staging/erofs/include/trace/events/erofs.h
+++ b/drivers/staging/erofs/include/trace/events/erofs.h
@@ -32,20 +32,20 @@ TRACE_EVENT(erofs_lookup,
 	TP_STRUCT__entry(
 		__field(dev_t,		dev	)
 		__field(erofs_nid_t,	nid	)
-		__field(const char *,	name	)
+		__string(name,		dentry->d_name.name	)
 		__field(unsigned int,	flags	)
 	),
 
 	TP_fast_assign(
 		__entry->dev	= dir->i_sb->s_dev;
 		__entry->nid	= EROFS_V(dir)->nid;
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
2.24.4

