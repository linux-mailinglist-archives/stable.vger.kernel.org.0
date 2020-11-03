Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91F042A5213
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731197AbgKCUqa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:46:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:35816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731208AbgKCUq1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:46:27 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF2B6223EA;
        Tue,  3 Nov 2020 20:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436387;
        bh=ACKsQsvChLqxsx3QbiEmD+pdDGb80t11UsKutP3gTi4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FZsieAxkKqGMy1B3MlTUwrwVFyYtYEtHqP4PN/yQEY+jLRDTEI937PJYmelPHjimo
         ZgakVQ+pQo369Rmu/ey0Cfk5UhU2FKPCc8ubB3gNyGQEsTkoXUNBVbm9zGisrHc7qS
         7r4SHPa9gQnM/0+Bm21mqN8zp42n0rOUIhku+tF0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Denis Efremov <efremov@linux.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.9 229/391] btrfs: use kvzalloc() to allocate clone_roots in btrfs_ioctl_send()
Date:   Tue,  3 Nov 2020 21:34:40 +0100
Message-Id: <20201103203402.416771608@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Denis Efremov <efremov@linux.com>

commit 8eb2fd00153a3a96a19c62ac9c6d48c2efebe5e8 upstream.

btrfs_ioctl_send() used open-coded kvzalloc implementation earlier.
The code was accidentally replaced with kzalloc() call [1]. Restore
the original code by using kvzalloc() to allocate sctx->clone_roots.

[1] https://patchwork.kernel.org/patch/9757891/#20529627

Fixes: 818e010bf9d0 ("btrfs: replace opencoded kvzalloc with the helper")
CC: stable@vger.kernel.org # 4.14+
Signed-off-by: Denis Efremov <efremov@linux.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/send.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -7300,7 +7300,7 @@ long btrfs_ioctl_send(struct file *mnt_f
 
 	alloc_size = sizeof(struct clone_root) * (arg->clone_sources_count + 1);
 
-	sctx->clone_roots = kzalloc(alloc_size, GFP_KERNEL);
+	sctx->clone_roots = kvzalloc(alloc_size, GFP_KERNEL);
 	if (!sctx->clone_roots) {
 		ret = -ENOMEM;
 		goto out;


