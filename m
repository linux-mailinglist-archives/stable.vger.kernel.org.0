Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98F3D3837B5
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244319AbhEQPql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:46:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:52118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242762AbhEQPoC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:44:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CCA261950;
        Mon, 17 May 2021 14:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262586;
        bh=eFLFcCVjj/Juat7SVA7Sv9+IO9Wv0EhmVYpN/GkN9u4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zrRT4HdDsZRJsn1h/fWd7RhOMJOTBQeQbf3967wkvqg1SdKtW89Yy5ajjT8cnhGSa
         yO2gS17Kw+YBlpt2NVCkS5OwFR63fwwluY/lUPoCsXs8iUxRav8Mtc8Mjd00BC+wSA
         GE6b6lhk8HIQyapLTMdF0SzLVFLjJ4iWHjOtvZ1Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Enderborg <peter.enderborg@sony.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.11 326/329] debugfs: Make debugfs_allow RO after init
Date:   Mon, 17 May 2021 16:03:57 +0200
Message-Id: <20210517140313.113166635@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit 312723a0b34d6d110aa4427a982536bb36ab8471 upstream.

Since debugfs_allow is only set at boot time during __init, make it
read-only after being set.

Fixes: a24c6f7bc923 ("debugfs: Add access restriction option")
Cc: Peter Enderborg <peter.enderborg@sony.com>
Reviewed-by: Peter Enderborg <peter.enderborg@sony.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20210405213959.3079432-1-keescook@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/debugfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -35,7 +35,7 @@
 static struct vfsmount *debugfs_mount;
 static int debugfs_mount_count;
 static bool debugfs_registered;
-static unsigned int debugfs_allow = DEFAULT_DEBUGFS_ALLOW_BITS;
+static unsigned int debugfs_allow __ro_after_init = DEFAULT_DEBUGFS_ALLOW_BITS;
 
 /*
  * Don't allow access attributes to be changed whilst the kernel is locked down


