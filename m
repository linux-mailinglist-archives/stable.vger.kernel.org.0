Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75D0612EE77
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:40:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730869AbgABWiw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:38:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:53578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731360AbgABWit (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:38:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DEB524650;
        Thu,  2 Jan 2020 22:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004729;
        bh=OtxbCXFjP2oaiM7NLaEynn8akiAk4XtBtfpzFMuzhDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RvNF3X2E/YCdkLQx5fX3nnK7UxYMoiKL6ZqMb/aIe/4GuyDMncDxOQtTkK7Y/qV+o
         A5C4kyvQo1/C4uKzQGli/H6IZW/N1u7Jpca35T2TQ3t+uvShnLOUIv9XaFfFW3ftUV
         TAumWf4sLa3RTq2X/Wr5+jVNWnc0kdlcr+wEQLXY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+3031f712c7ad5dd4d926@syzkaller.appspotmail.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Siddharth Chandrasekaran <csiddharth@vmware.com>
Subject: [PATCH 4.4 129/137] filldir[64]: remove WARN_ON_ONCE() for bad directory entries
Date:   Thu,  2 Jan 2020 23:08:22 +0100
Message-Id: <20200102220604.479039672@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220546.618583146@linuxfoundation.org>
References: <20200102220546.618583146@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit b9959c7a347d6adbb558fba7e36e9fef3cba3b07 upstream.

This was always meant to be a temporary thing, just for testing and to
see if it actually ever triggered.

The only thing that reported it was syzbot doing disk image fuzzing, and
then that warning is expected.  So let's just remove it before -rc4,
because the extra sanity testing should probably go to -stable, but we
don't want the warning to do so.

Reported-by: syzbot+3031f712c7ad5dd4d926@syzkaller.appspotmail.com
Fixes: 8a23eb804ca4 ("Make filldir[64]() verify the directory entry filename is valid")
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Siddharth Chandrasekaran <csiddharth@vmware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/readdir.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -77,9 +77,9 @@ EXPORT_SYMBOL(iterate_dir);
  */
 static int verify_dirent_name(const char *name, int len)
 {
-	if (WARN_ON_ONCE(!len))
+	if (!len)
 		return -EIO;
-	if (WARN_ON_ONCE(memchr(name, '/', len)))
+	if (memchr(name, '/', len))
 		return -EIO;
 	return 0;
 }


