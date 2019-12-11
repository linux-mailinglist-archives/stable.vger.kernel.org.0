Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E158811B6BE
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:02:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730522AbfLKQCt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 11:02:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:36042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730908AbfLKPNH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:13:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BAFB2467C;
        Wed, 11 Dec 2019 15:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077186;
        bh=5xNR6jI9+0OjgRnmsvUhBM684dKe2zQ9o5G22OtrEhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LAiDJCai6UOxF7paoO3wRuWRRuqBkmbTNw/sgYTfsrjKd+Jmux5FghjDLMGwmuzEO
         ZZZgiJ/1P9ioBPIDj4iIJgFGIdph2WG0og0SInu9qqfxhknktOh7aqRRIe4s65xr1F
         jXGUZLRcZrbj/BuZq75u4ns50IKmtTWsRUOuy1CU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillem Jover <guillem@hadrons.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 014/105] aio: Fix io_pgetevents() struct __compat_aio_sigset layout
Date:   Wed, 11 Dec 2019 16:05:03 +0100
Message-Id: <20191211150224.289343749@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.153659747@linuxfoundation.org>
References: <20191211150221.153659747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillem Jover <guillem@hadrons.org>

[ Upstream commit 97eba80fcca754856d09e048f469db22773bec68 ]

This type is used to pass the sigset_t from userland to the kernel,
but it was using the kernel native pointer type for the member
representing the compat userland pointer to the userland sigset_t.

This messes up the layout, and makes the kernel eat up both the
userland pointer and the size members into the kernel pointer, and
then reads garbage into the kernel sigsetsize. Which makes the sigset_t
size consistency check fail, and consequently the syscall always
returns -EINVAL.

This breaks both libaio and strace on 32-bit userland running on 64-bit
kernels. And there are apparently no users in the wild of the current
broken layout (at least according to codesearch.debian.org and a brief
check over github.com search). So it looks safe to fix this directly
in the kernel, instead of either letting userland deal with this
permanently with the additional overhead or trying to make the syscall
infer what layout userland used, even though this is also being worked
around in libaio to temporarily cope with kernels that have not yet
been fixed.

We use a proper compat_uptr_t instead of a compat_sigset_t pointer.

Fixes: 7a074e96dee6 ("aio: implement io_pgetevents")
Signed-off-by: Guillem Jover <guillem@hadrons.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/aio.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 01e0fb9ae45ae..0d9a559d488c1 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -2179,7 +2179,7 @@ SYSCALL_DEFINE5(io_getevents_time32, __u32, ctx_id,
 #ifdef CONFIG_COMPAT
 
 struct __compat_aio_sigset {
-	compat_sigset_t __user	*sigmask;
+	compat_uptr_t		sigmask;
 	compat_size_t		sigsetsize;
 };
 
@@ -2193,7 +2193,7 @@ COMPAT_SYSCALL_DEFINE6(io_pgetevents,
 		struct old_timespec32 __user *, timeout,
 		const struct __compat_aio_sigset __user *, usig)
 {
-	struct __compat_aio_sigset ksig = { NULL, };
+	struct __compat_aio_sigset ksig = { 0, };
 	struct timespec64 t;
 	bool interrupted;
 	int ret;
@@ -2204,7 +2204,7 @@ COMPAT_SYSCALL_DEFINE6(io_pgetevents,
 	if (usig && copy_from_user(&ksig, usig, sizeof(ksig)))
 		return -EFAULT;
 
-	ret = set_compat_user_sigmask(ksig.sigmask, ksig.sigsetsize);
+	ret = set_compat_user_sigmask(compat_ptr(ksig.sigmask), ksig.sigsetsize);
 	if (ret)
 		return ret;
 
@@ -2228,7 +2228,7 @@ COMPAT_SYSCALL_DEFINE6(io_pgetevents_time64,
 		struct __kernel_timespec __user *, timeout,
 		const struct __compat_aio_sigset __user *, usig)
 {
-	struct __compat_aio_sigset ksig = { NULL, };
+	struct __compat_aio_sigset ksig = { 0, };
 	struct timespec64 t;
 	bool interrupted;
 	int ret;
@@ -2239,7 +2239,7 @@ COMPAT_SYSCALL_DEFINE6(io_pgetevents_time64,
 	if (usig && copy_from_user(&ksig, usig, sizeof(ksig)))
 		return -EFAULT;
 
-	ret = set_compat_user_sigmask(ksig.sigmask, ksig.sigsetsize);
+	ret = set_compat_user_sigmask(compat_ptr(ksig.sigmask), ksig.sigsetsize);
 	if (ret)
 		return ret;
 
-- 
2.20.1



