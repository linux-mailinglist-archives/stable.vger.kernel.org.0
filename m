Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7AD383860
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343724AbhEQPwR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:52:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:45460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345105AbhEQPuN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:50:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B48C2613B0;
        Mon, 17 May 2021 14:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262739;
        bh=eFLFcCVjj/Juat7SVA7Sv9+IO9Wv0EhmVYpN/GkN9u4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xqUWHg0GNe89hJ2RWT/fkAERF0uoRweX72wZSJz+a5k72rHb9eH/ZV5g+YtfhkDN/
         RL/dOXXTnQQAd88qnESWk28n515BmfmgYVSoWqnIE6CnWr1k60uCxcdlewuGFemWmz
         mH/V7gNfTxVFNiuex6kFaUgUhzIWrMPA18hTXkxk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Enderborg <peter.enderborg@sony.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.10 286/289] debugfs: Make debugfs_allow RO after init
Date:   Mon, 17 May 2021 16:03:31 +0200
Message-Id: <20210517140314.774159493@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
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


