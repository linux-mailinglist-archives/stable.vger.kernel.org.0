Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A04F21574A4
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727641AbgBJMfD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:35:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:51130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727600AbgBJMfC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:35:02 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 077FF214DB;
        Mon, 10 Feb 2020 12:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338102;
        bh=jy5JOodwvlwm7Ucf+eZv1S4++d87MwsN5hfxCWrT4X4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OSbDyinGB93lgV2wgKWp2t42QI6MxgGfFWfKltOIG9OlfTCLqF9jV6qLO5Bk10LNl
         JwesnzWVdKtVSMYCT2nUJBgmylMyX2K4UfqRZpQXGV7tu34YQblnaEz52soFhvgwfY
         v2l0h2LbhtDguXWDOz5f4MgUPi35P7S0GEuLYFjY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Boris Gjenero <boris.gjenero@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 002/195] ovl: fix lseek overflow on 32bit
Date:   Mon, 10 Feb 2020 04:31:00 -0800
Message-Id: <20200210122305.999066195@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
References: <20200210122305.731206734@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

[ Upstream commit a4ac9d45c0cd14a2adc872186431c79804b77dbf ]

ovl_lseek() is using ssize_t to return the value from vfs_llseek().  On a
32-bit kernel ssize_t is a 32-bit signed int, which overflows above 2 GB.

Assign the return value of vfs_llseek() to loff_t to fix this.

Reported-by: Boris Gjenero <boris.gjenero@gmail.com>
Fixes: 9e46b840c705 ("ovl: support stacked SEEK_HOLE/SEEK_DATA")
Cc: <stable@vger.kernel.org> # v4.19
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 0bd276e4ccbee..fa5ac5de807c5 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -149,7 +149,7 @@ static loff_t ovl_llseek(struct file *file, loff_t offset, int whence)
 	struct inode *inode = file_inode(file);
 	struct fd real;
 	const struct cred *old_cred;
-	ssize_t ret;
+	loff_t ret;
 
 	/*
 	 * The two special cases below do not need to involve real fs,
-- 
2.20.1



