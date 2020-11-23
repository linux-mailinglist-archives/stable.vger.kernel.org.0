Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6C6E2C0AB4
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730022AbgKWMZj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:25:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:35228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730012AbgKWMZe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:25:34 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6086C20728;
        Mon, 23 Nov 2020 12:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134332;
        bh=62mRLKe/RfL8XyA1xT2Hd0cAz3QYSgm+0D81JsL+fYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lwLzUZuYx0UDUNNeItJfEIgkDS/J4yzfi2CupL4BtfFH2ZxoYLPx0rzvA46eEIYc/
         Ix8mMjuB8ZovFOlYp1GIY37FlIHGRZLJzxKog2QM+3V4xKG5dPVesW9rYz3tNZWf+E
         ORyFmnoHaz24AwVpXYveV8zbUsoOyCpgHfPs2Y5w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yicong Yang <yangyicong@hisilicon.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 33/47] libfs: fix error cast of negative value in simple_attr_write()
Date:   Mon, 23 Nov 2020 13:22:19 +0100
Message-Id: <20201123121807.157295339@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121805.530891002@linuxfoundation.org>
References: <20201123121805.530891002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yicong Yang <yangyicong@hisilicon.com>

[ Upstream commit 488dac0c9237647e9b8f788b6a342595bfa40bda ]

The attr->set() receive a value of u64, but simple_strtoll() is used for
doing the conversion.  It will lead to the error cast if user inputs a
negative value.

Use kstrtoull() instead of simple_strtoll() to convert a string got from
the user to an unsigned value.  The former will return '-EINVAL' if it
gets a negetive value, but the latter can't handle the situation
correctly.  Make 'val' unsigned long long as what kstrtoull() takes,
this will eliminate the compile warning on no 64-bit architectures.

Fixes: f7b88631a897 ("fs/libfs.c: fix simple_attr_write() on 32bit machines")
Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Link: https://lkml.kernel.org/r/1605341356-11872-1-git-send-email-yangyicong@hisilicon.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/libfs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index 278457f221482..835d25e335095 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -865,7 +865,7 @@ ssize_t simple_attr_write(struct file *file, const char __user *buf,
 			  size_t len, loff_t *ppos)
 {
 	struct simple_attr *attr;
-	u64 val;
+	unsigned long long val;
 	size_t size;
 	ssize_t ret;
 
@@ -883,7 +883,9 @@ ssize_t simple_attr_write(struct file *file, const char __user *buf,
 		goto out;
 
 	attr->set_buf[size] = '\0';
-	val = simple_strtoll(attr->set_buf, NULL, 0);
+	ret = kstrtoull(attr->set_buf, 0, &val);
+	if (ret)
+		goto out;
 	ret = attr->set(attr->data, val);
 	if (ret == 0)
 		ret = len; /* on success, claim we got the whole input */
-- 
2.27.0



