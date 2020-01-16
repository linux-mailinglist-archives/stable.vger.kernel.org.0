Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4258913FF0A
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388879AbgAPXkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:40:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:59684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390229AbgAPX1k (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:27:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C87020684;
        Thu, 16 Jan 2020 23:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217260;
        bh=Q38lxsXrd6RMZPU5R2oxnuqAMgrL9i1BFETIT3lzb5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IxDdSx8Y/USCSdcgzw9vGi25FRU+Hn8FJCBmuFH+zA34tqNbTcB35pKHzb+OeiBXx
         Fm4H4LNKqxTtzViCCoQk1KvhxBORZ8kNyh/ZFoutbCz6YUDU/zz6Zi37XGuwdCkg51
         UdhEqnYNERsB57GZ87ZsabqiDnF1C6aSzONIfVOk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gong Chen <gongchen4@huawei.com>,
        Sheng Yong <shengyong1@huawei.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.19 10/84] f2fs: check if file namelen exceeds max value
Date:   Fri, 17 Jan 2020 00:17:44 +0100
Message-Id: <20200116231714.780541022@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231713.087649517@linuxfoundation.org>
References: <20200116231713.087649517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sheng Yong <shengyong1@huawei.com>

commit 720db068634c91553a8e1d9a0fcd8c7050e06d2b upstream.

Dentry bitmap is not enough to detect incorrect dentries. So this patch
also checks the namelen value of a dentry.

Signed-off-by: Gong Chen <gongchen4@huawei.com>
Signed-off-by: Sheng Yong <shengyong1@huawei.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/dir.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -808,7 +808,8 @@ int f2fs_fill_dentries(struct dir_contex
 
 		/* check memory boundary before moving forward */
 		bit_pos += GET_DENTRY_SLOTS(le16_to_cpu(de->name_len));
-		if (unlikely(bit_pos > d->max)) {
+		if (unlikely(bit_pos > d->max ||
+				le16_to_cpu(de->name_len) > F2FS_NAME_LEN)) {
 			f2fs_msg(sbi->sb, KERN_WARNING,
 				"%s: corrupted namelen=%d, run fsck to fix.",
 				__func__, le16_to_cpu(de->name_len));


