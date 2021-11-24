Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2119645C138
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343915AbhKXNPq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:15:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:52018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348672AbhKXNNn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:13:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1AAE161AAA;
        Wed, 24 Nov 2021 12:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757802;
        bh=54Fc3/FReXOvSaUKoTCRD1aHduVlwM/2aAoBw+BObaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fpzn1/V0qxG55x18Jp0Q+KckW8OaP2R8nj06a7QheV3JMXrm8ACqmICQc2ER9X1wZ
         H/4RUtYjDdHvIsozRCehsEGs0XvoTl9Pu9Ya7VA9UNm4nj3rmPS7LFXHOK37EXgJAg
         tooENeLL6yK1CAAmtF9e11lehDqpm1NdsZUyXAv4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gao Xiang <hsiangkao@linux.alibaba.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 281/323] f2fs: fix up f2fs_lookup tracepoints
Date:   Wed, 24 Nov 2021 12:57:51 +0100
Message-Id: <20211124115728.380771090@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 70a9ac36ffd807ac506ed0b849f3e8ce3c6623f2 ]

Fix up a misuse that the filename pointer isn't always valid in
the ring buffer, and we should copy the content instead.

Fixes: 0c5e36db17f5 ("f2fs: trace f2fs_lookup")
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/f2fs.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index 795698925d206..52e6456bdb922 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -751,20 +751,20 @@ TRACE_EVENT(f2fs_lookup_start,
 	TP_STRUCT__entry(
 		__field(dev_t,	dev)
 		__field(ino_t,	ino)
-		__field(const char *,	name)
+		__string(name,	dentry->d_name.name)
 		__field(unsigned int, flags)
 	),
 
 	TP_fast_assign(
 		__entry->dev	= dir->i_sb->s_dev;
 		__entry->ino	= dir->i_ino;
-		__entry->name	= dentry->d_name.name;
+		__assign_str(name, dentry->d_name.name);
 		__entry->flags	= flags;
 	),
 
 	TP_printk("dev = (%d,%d), pino = %lu, name:%s, flags:%u",
 		show_dev_ino(__entry),
-		__entry->name,
+		__get_str(name),
 		__entry->flags)
 );
 
@@ -778,7 +778,7 @@ TRACE_EVENT(f2fs_lookup_end,
 	TP_STRUCT__entry(
 		__field(dev_t,	dev)
 		__field(ino_t,	ino)
-		__field(const char *,	name)
+		__string(name,	dentry->d_name.name)
 		__field(nid_t,	cino)
 		__field(int,	err)
 	),
@@ -786,14 +786,14 @@ TRACE_EVENT(f2fs_lookup_end,
 	TP_fast_assign(
 		__entry->dev	= dir->i_sb->s_dev;
 		__entry->ino	= dir->i_ino;
-		__entry->name	= dentry->d_name.name;
+		__assign_str(name, dentry->d_name.name);
 		__entry->cino	= ino;
 		__entry->err	= err;
 	),
 
 	TP_printk("dev = (%d,%d), pino = %lu, name:%s, ino:%u, err:%d",
 		show_dev_ino(__entry),
-		__entry->name,
+		__get_str(name),
 		__entry->cino,
 		__entry->err)
 );
-- 
2.33.0



