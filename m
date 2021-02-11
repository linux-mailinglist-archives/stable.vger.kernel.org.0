Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB9CD318E08
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbhBKPTm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:19:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:51648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230097AbhBKPNT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:13:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2707664EF2;
        Thu, 11 Feb 2021 15:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613055892;
        bh=Tu/ihzwj0fdIKZC3D8WmvryBsJDFFHOXxBFv25QlwuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KaJkMuVU1FYkbfKAjn8rXIsd8aCiTAsKDoZJuYAGHe2lG9lNlLkbcFO70WRaGeBJe
         9KqhzDgTBQze0OXeXmmXFVcN2olearzOxXqp/YYEyHlA1H2Vd4/0p5VdEpuxM30aYn
         5vkGHW578IxU7JKzjW+Gi+jP4bRNEITL3jEmbo4I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Joachim Henke <joachim.henke@t-systems.com>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 49/54] nilfs2: make splice write available again
Date:   Thu, 11 Feb 2021 16:02:33 +0100
Message-Id: <20210211150155.010025735@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211150152.885701259@linuxfoundation.org>
References: <20210211150152.885701259@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joachim Henke <joachim.henke@t-systems.com>

commit a35d8f016e0b68634035217d06d1c53863456b50 upstream.

Since 5.10, splice() or sendfile() to NILFS2 return EINVAL.  This was
caused by commit 36e2c7421f02 ("fs: don't allow splice read/write
without explicit ops").

This patch initializes the splice_write field in file_operations, like
most file systems do, to restore the functionality.

Link: https://lkml.kernel.org/r/1612784101-14353-1-git-send-email-konishi.ryusuke@gmail.com
Signed-off-by: Joachim Henke <joachim.henke@t-systems.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>	[5.10+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/file.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nilfs2/file.c
+++ b/fs/nilfs2/file.c
@@ -141,6 +141,7 @@ const struct file_operations nilfs_file_
 	/* .release	= nilfs_release_file, */
 	.fsync		= nilfs_sync_file,
 	.splice_read	= generic_file_splice_read,
+	.splice_write   = iter_file_splice_write,
 };
 
 const struct inode_operations nilfs_file_inode_operations = {


