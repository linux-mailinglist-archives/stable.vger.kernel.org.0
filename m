Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04AE9226674
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732089AbgGTQDV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:03:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:37614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732425AbgGTQDT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:03:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6B9E20672;
        Mon, 20 Jul 2020 16:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260999;
        bh=Z9eIgK61mjS4Ul2PRXMOZ1S4VcotxUTrQE+5+4dWKuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m128PxrXx8FKh8jM6YB2Spm6E0Yb3phMNIeaRcWzpuZSCnwviVw6Eq2JkPvaWGjW7
         N7WOTx92FPlDinoNFyTxq0M2KYcYF4mflCk6bTw0ckXh30KqA7WSLJqw+dt3SHYWsz
         +U1UaZSi0xfiarj/Gtx+v34I7WSyoJHqeIQrDhYQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Priebe <s.priebe@profihost.ag>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.4 173/215] fuse: ignore data argument of mount(..., MS_REMOUNT)
Date:   Mon, 20 Jul 2020 17:37:35 +0200
Message-Id: <20200720152828.408019065@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit e8b20a474cf2c42698d1942f939ff2128819f151 upstream.

The command

  mount -o remount -o unknownoption /mnt/fuse

succeeds on kernel versions prior to v5.4 and fails on kernel version at or
after.  This is because fuse_parse_param() rejects any unrecognised options
in case of FS_CONTEXT_FOR_RECONFIGURE, just as for FS_CONTEXT_FOR_MOUNT.

This causes a regression in case the fuse filesystem is in fstab, since
remount sends all options found there to the kernel; even ones that are
meant for the initial mount and are consumed by the userspace fuse server.

Fix this by ignoring mount options, just as fuse_remount_fs() did prior to
the conversion to the new API.

Reported-by: Stefan Priebe <s.priebe@profihost.ag>
Fixes: c30da2e981a7 ("fuse: convert to use the new mount API")
Cc: <stable@vger.kernel.org> # v5.4
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fuse/inode.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -473,6 +473,13 @@ static int fuse_parse_param(struct fs_co
 	struct fuse_fs_context *ctx = fc->fs_private;
 	int opt;
 
+	/*
+	 * Ignore options coming from mount(MS_REMOUNT) for backward
+	 * compatibility.
+	 */
+	if (fc->purpose == FS_CONTEXT_FOR_RECONFIGURE)
+		return 0;
+
 	opt = fs_parse(fc, &fuse_fs_parameters, param, &result);
 	if (opt < 0)
 		return opt;


