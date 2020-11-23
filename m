Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6442C0B31
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388025AbgKWNVG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:21:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:51194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732121AbgKWMio (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:38:44 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC0F02076E;
        Mon, 23 Nov 2020 12:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135123;
        bh=dgVuDh2GXuI7HQa+oO0rr1S4SG+f7PWa0Qrjleo+wu4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L3te3WzFtbZ9eZwFmlUJwcSHJM0hI5nWrt2K+0Qp0SeLwy/DclZAJt5c3fg3v9LxQ
         46or8BEx62CjlGoy16Yib1rkBOixYKrBHHWcOjxvdXVom4pHMoVH+6hE/nLEk8xrYK
         15f4VEtD3wL1pSpOPW97SmwXeV+F/mmYFOO+xMig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yicong Yang <yangyicong@hisilicon.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 112/158] libfs: fix error cast of negative value in simple_attr_write()
Date:   Mon, 23 Nov 2020 13:22:20 +0100
Message-Id: <20201123121825.344489004@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
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
index 5fd9cc0e2ac9e..247b58a68240a 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -887,7 +887,7 @@ ssize_t simple_attr_write(struct file *file, const char __user *buf,
 			  size_t len, loff_t *ppos)
 {
 	struct simple_attr *attr;
-	u64 val;
+	unsigned long long val;
 	size_t size;
 	ssize_t ret;
 
@@ -905,7 +905,9 @@ ssize_t simple_attr_write(struct file *file, const char __user *buf,
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



