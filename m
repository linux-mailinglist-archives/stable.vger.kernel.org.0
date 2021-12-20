Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C997447AC79
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236175AbhLTOoI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:44:08 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36148 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234263AbhLTOmg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:42:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14F33611A3;
        Mon, 20 Dec 2021 14:42:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB88AC36AE7;
        Mon, 20 Dec 2021 14:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011355;
        bh=vyuJDzt3YPOOYl/pk+FF5P1CFQ5tVNE/L2Hp447pxCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R27SlHXAbQKtf3DRZFFxA7zpD44VhaYcDs9M/S1qgJyFb5DHjmjASwJFWX4Te9XcG
         4p8IPS0n0FaZUf2JJ4XOlReuEWY9Q1hfTMzVr4vBk4lkLh3mEdtxw3mX6vZjUlv1dQ
         GbOlL8L/aPKSZJMqUXJtAuLt6JVDDG+7PI84ZblM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        syzbot+9f747458f5990eaa8d43@syzkaller.appspotmail.com
Subject: [PATCH 4.19 49/56] fuse: annotate lock in fuse_reverse_inval_entry()
Date:   Mon, 20 Dec 2021 15:34:42 +0100
Message-Id: <20211220143025.077655964@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143023.451982183@linuxfoundation.org>
References: <20211220143023.451982183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit bda9a71980e083699a0360963c0135657b73f47a upstream.

Add missing inode lock annotatation; found by syzbot.

Reported-and-tested-by: syzbot+9f747458f5990eaa8d43@syzkaller.appspotmail.com
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -984,7 +984,7 @@ int fuse_reverse_inval_entry(struct supe
 	if (!parent)
 		return -ENOENT;
 
-	inode_lock(parent);
+	inode_lock_nested(parent, I_MUTEX_PARENT);
 	if (!S_ISDIR(parent->i_mode))
 		goto unlock;
 


