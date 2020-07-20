Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8317522684B
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387666AbgGTQNn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:13:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:53724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388136AbgGTQNk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:13:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37BA120734;
        Mon, 20 Jul 2020 16:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261619;
        bh=hRF5xXYQb2JblcGP2n9ndxkhrq+atP2E9XBJF5Slttc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bs7HX4Af+pBmUgtgo+lTTGDoewf0yUX8KYrvKw4uzj91QKlBI5fGkYLeimdCg329H
         biZ1XE7xs1wJ31FjnlKHcYI9D912b/KzeI8DQH4b8Eo+QNddh12zi3EHxq2O1rINFY
         QrCLxCV3yPBz4+THGlecoxLRgxuZ1t6DqCEGS8qI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Priebe <s.priebe@profihost.ag>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.7 182/244] fuse: ignore data argument of mount(..., MS_REMOUNT)
Date:   Mon, 20 Jul 2020 17:37:33 +0200
Message-Id: <20200720152834.497235240@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
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
@@ -468,6 +468,13 @@ static int fuse_parse_param(struct fs_co
 	struct fuse_fs_context *ctx = fc->fs_private;
 	int opt;
 
+	/*
+	 * Ignore options coming from mount(MS_REMOUNT) for backward
+	 * compatibility.
+	 */
+	if (fc->purpose == FS_CONTEXT_FOR_RECONFIGURE)
+		return 0;
+
 	opt = fs_parse(fc, fuse_fs_parameters, param, &result);
 	if (opt < 0)
 		return opt;


