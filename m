Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39459506F7
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729163AbfFXKDB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:03:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:34292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729479AbfFXKDB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:03:01 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 865AF213F2;
        Mon, 24 Jun 2019 10:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370580;
        bh=8p6CvQoZsI1qstbo/MkDljlgLADsxNqe5SQqKr0Q8wY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M+QxH1IrGTpD9nG4j3DsJ+yOiMVCDnUuGpsu6YtApe96pN3P1zfShv9yHVS19T5+j
         QGdig9bdR8CklZrJQDMiga/CG7X299KxKyfv1Xln9T7KHGLl1ePCts/GW2U531kCDl
         bLLQmjhd9XL6dmDdfa0DSujk5bisHtx6Gn5d9cZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 09/90] ovl: fix bogus -Wmaybe-unitialized warning
Date:   Mon, 24 Jun 2019 17:55:59 +0800
Message-Id: <20190624092314.600497388@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092313.788773607@linuxfoundation.org>
References: <20190624092313.788773607@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 1dac6f5b0ed2601be21bb4e27a44b0c3e667b7f4 ]

gcc gets a bit confused by the logic in ovl_setup_trap() and
can't figure out whether the local 'trap' variable in the caller
was initialized or not:

fs/overlayfs/super.c: In function 'ovl_fill_super':
fs/overlayfs/super.c:1333:4: error: 'trap' may be used uninitialized in this function [-Werror=maybe-uninitialized]
    iput(trap);
    ^~~~~~~~~~
fs/overlayfs/super.c:1312:17: note: 'trap' was declared here

Reword slightly to make it easier for the compiler to understand.

Fixes: 146d62e5a586 ("ovl: detect overlapping layers")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index d6e60a7156a1..2d028c02621f 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -996,8 +996,8 @@ static int ovl_setup_trap(struct super_block *sb, struct dentry *dir,
 	int err;
 
 	trap = ovl_get_trap_inode(sb, dir);
-	err = PTR_ERR(trap);
-	if (IS_ERR(trap)) {
+	err = PTR_ERR_OR_ZERO(trap);
+	if (err) {
 		if (err == -ELOOP)
 			pr_err("overlayfs: conflicting %s path\n", name);
 		return err;
-- 
2.20.1



