Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA3D24AB32
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 02:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbgHTAIk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 20:08:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:60544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728182AbgHTADB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Aug 2020 20:03:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D152E207FB;
        Thu, 20 Aug 2020 00:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597881780;
        bh=TEnAfCRFKqzWR8b/LmW6mBYUZ01Boo0wZb54NQoT21g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1c5WCkDvTyY/sjU70QMq/QYidOJYlCci9JuZIyfwHURoZzqYneURNIV+YYPFU5DWB
         9Mp3H69XR7KxUX7+z3MFsYQLrzZtkJOR8dgrTZ8Vrtg0dZz1/Vgdpb3cOq/efsQxr8
         yER9cupSQ8IExt0H6zdLYzgjkXNXYkCIYWN8DCzc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Helge Deller <deller@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Laurent Vivier <laurent@vivier.eu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 22/22] fs/signalfd.c: fix inconsistent return codes for signalfd4
Date:   Wed, 19 Aug 2020 20:02:29 -0400
Message-Id: <20200820000229.215333-22-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200820000229.215333-1-sashal@kernel.org>
References: <20200820000229.215333-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

[ Upstream commit a089e3fd5a82aea20f3d9ec4caa5f4c65cc2cfcc ]

The kernel signalfd4() syscall returns different error codes when called
either in compat or native mode.  This behaviour makes correct emulation
in qemu and testing programs like LTP more complicated.

Fix the code to always return -in both modes- EFAULT for unaccessible user
memory, and EINVAL when called with an invalid signal mask.

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Laurent Vivier <laurent@vivier.eu>
Link: http://lkml.kernel.org/r/20200530100707.GA10159@ls3530.fritz.box
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/signalfd.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/signalfd.c b/fs/signalfd.c
index 44b6845b071c3..5b78719be4455 100644
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -314,9 +314,10 @@ SYSCALL_DEFINE4(signalfd4, int, ufd, sigset_t __user *, user_mask,
 {
 	sigset_t mask;
 
-	if (sizemask != sizeof(sigset_t) ||
-	    copy_from_user(&mask, user_mask, sizeof(mask)))
+	if (sizemask != sizeof(sigset_t))
 		return -EINVAL;
+	if (copy_from_user(&mask, user_mask, sizeof(mask)))
+		return -EFAULT;
 	return do_signalfd4(ufd, &mask, flags);
 }
 
@@ -325,9 +326,10 @@ SYSCALL_DEFINE3(signalfd, int, ufd, sigset_t __user *, user_mask,
 {
 	sigset_t mask;
 
-	if (sizemask != sizeof(sigset_t) ||
-	    copy_from_user(&mask, user_mask, sizeof(mask)))
+	if (sizemask != sizeof(sigset_t))
 		return -EINVAL;
+	if (copy_from_user(&mask, user_mask, sizeof(mask)))
+		return -EFAULT;
 	return do_signalfd4(ufd, &mask, 0);
 }
 
-- 
2.25.1

