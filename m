Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFC8124F54F
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729445AbgHXIrS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:47:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:46786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729442AbgHXIrR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:47:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F25A204FD;
        Mon, 24 Aug 2020 08:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258837;
        bh=TEnAfCRFKqzWR8b/LmW6mBYUZ01Boo0wZb54NQoT21g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qp9nyVYC7XDAE7E2yEuQBeoaZxBn9keOShPA1p030C4d6y1P4I57JzboXnR1lng79
         THA9c4tayL4erocadFIXCLa1wJ+vewW/ukUWmUy9BwPMACpsIfhw4eUufzhLGA2GbT
         T3U92veHjvP4hOYUDBW3dzcZ8Jddpgp7rWAknSb0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Laurent Vivier <laurent@vivier.eu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 062/107] fs/signalfd.c: fix inconsistent return codes for signalfd4
Date:   Mon, 24 Aug 2020 10:30:28 +0200
Message-Id: <20200824082408.199169881@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082405.020301642@linuxfoundation.org>
References: <20200824082405.020301642@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



