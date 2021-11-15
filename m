Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7E9451E68
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242654AbhKPAfz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:35:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:45204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344865AbhKOTZh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F17E3633F0;
        Mon, 15 Nov 2021 19:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003153;
        bh=muAIcByDL+6/H+q8zkMKg4uAmO9mDUkD0D2OKVw4uy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vIQgG5kQo1L2CFEo6M2M1wj/kt938Npn0wR/7qu3RdxD3mAeVKy9XMVvR/GS+/HIe
         /XIn6LeRFQRpkVt7DZqSID6wOKP+4Oug6bNk/ay6SeLXvSrYN8hN9wXltJnIio+YbE
         1i1Bnjbv+TmTIhoIPnibvSpMuocJl6qPvSn/qiNw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Florent Revest <revest@chromium.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 830/917] seq_file: fix passing wrong private data
Date:   Mon, 15 Nov 2021 18:05:25 +0100
Message-Id: <20211115165457.194045489@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>

[ Upstream commit 10a6de19cad6efb9b49883513afb810dc265fca2 ]

DEFINE_PROC_SHOW_ATTRIBUTE() is supposed to be used to define a series
of functions and variables to register proc file easily. And the users
can use proc_create_data() to pass their own private data and get it
via seq->private in the callback. Unfortunately, the proc file system
use PDE_DATA() to get private data instead of inode->i_private. So fix
it. Fortunately, there only one user of it which does not pass any
private data, so this bug does not break any in-tree codes.

Link: https://lkml.kernel.org/r/20211029032638.84884-1-songmuchun@bytedance.com
Fixes: 97a32539b956 ("proc: convert everything to "struct proc_ops"")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Florent Revest <revest@chromium.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/seq_file.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
index dd99569595fd3..5733890df64f5 100644
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -194,7 +194,7 @@ static const struct file_operations __name ## _fops = {			\
 #define DEFINE_PROC_SHOW_ATTRIBUTE(__name)				\
 static int __name ## _open(struct inode *inode, struct file *file)	\
 {									\
-	return single_open(file, __name ## _show, inode->i_private);	\
+	return single_open(file, __name ## _show, PDE_DATA(inode));	\
 }									\
 									\
 static const struct proc_ops __name ## _proc_ops = {			\
-- 
2.33.0



