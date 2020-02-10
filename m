Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3D9D157A37
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728856AbgBJNVP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:21:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:59498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728798AbgBJMhd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:37:33 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1088020838;
        Mon, 10 Feb 2020 12:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338253;
        bh=P2P9PPE0X1cAHxUj8UmWpDqIIESyqK2eK64QMFd/H7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ahRVUxZCnx0Ii01dSVMsfHNe2gGBKrdhpnZByjwyeHdl/p2vDifVayg/h2pBkAB1U
         3oMznm0SjAY5TjFjMp9ligrB9PYLRUMUdFdxtRJbjXek+tF2ggVTzNqwGLNElyPWbi
         hr9/nd7d3UJ9OrImN29Xcw9KuyaRP7iqUZbLJOiI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Boris Gjenero <boris.gjenero@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.4 117/309] ovl: fix lseek overflow on 32bit
Date:   Mon, 10 Feb 2020 04:31:13 -0800
Message-Id: <20200210122417.776025947@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit a4ac9d45c0cd14a2adc872186431c79804b77dbf upstream.

ovl_lseek() is using ssize_t to return the value from vfs_llseek().  On a
32-bit kernel ssize_t is a 32-bit signed int, which overflows above 2 GB.

Assign the return value of vfs_llseek() to loff_t to fix this.

Reported-by: Boris Gjenero <boris.gjenero@gmail.com>
Fixes: 9e46b840c705 ("ovl: support stacked SEEK_HOLE/SEEK_DATA")
Cc: <stable@vger.kernel.org> # v4.19
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/overlayfs/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -146,7 +146,7 @@ static loff_t ovl_llseek(struct file *fi
 	struct inode *inode = file_inode(file);
 	struct fd real;
 	const struct cred *old_cred;
-	ssize_t ret;
+	loff_t ret;
 
 	/*
 	 * The two special cases below do not need to involve real fs,


