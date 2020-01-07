Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9250133271
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730019AbgAGVKu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:10:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:37948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729845AbgAGVKt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:10:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C05BD20880;
        Tue,  7 Jan 2020 21:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431449;
        bh=WOF13kCPCcTW6cAaL9ZLhlIwTnYRqtW4gFeYeUxvNqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i6brtEN5OVplCkOWZW/X69gOLJpVeqWnudM/0MnshA6hkiczsFZ3T8Ba7f8EfYTwt
         fCQYef6Nl43l+h6FeCW6UUMk0cODToOWnUHGA7Vx7ETUWu9YdyZUqDx6BzeHyDVIKY
         oYpLjRpuHfhGEh097BB+C9LqWqGhbp/XgDuLObxc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4.14 60/74] fix compat handling of FICLONERANGE, FIDEDUPERANGE and FS_IOC_FIEMAP
Date:   Tue,  7 Jan 2020 21:55:25 +0100
Message-Id: <20200107205224.868091005@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205135.369001641@linuxfoundation.org>
References: <20200107205135.369001641@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit 6b2daec19094a90435abe67d16fb43b1a5527254 upstream.

Unlike FICLONE, all of those take a pointer argument; they do need
compat_ptr() applied to arg.

Fixes: d79bdd52d8be ("vfs: wire up compat ioctl for CLONE/CLONE_RANGE")
Fixes: 54dbc1517237 ("vfs: hoist the btrfs deduplication ioctl to the vfs")
Fixes: ceac204e1da9 ("fs: make fiemap work from compat_ioctl")
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/compat_ioctl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -1577,9 +1577,10 @@ COMPAT_SYSCALL_DEFINE3(ioctl, unsigned i
 #endif
 
 	case FICLONE:
+		goto do_ioctl;
 	case FICLONERANGE:
 	case FIDEDUPERANGE:
-		goto do_ioctl;
+		goto found_handler;
 
 	case FIBMAP:
 	case FIGETBSZ:


