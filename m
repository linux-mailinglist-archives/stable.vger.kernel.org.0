Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0544743A343
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238519AbhJYT5o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:57:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:41884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238392AbhJYTzm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:55:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F9A060FDC;
        Mon, 25 Oct 2021 19:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635191160;
        bh=1Qphw2Zf2mTEDHBQFsniF+QrGgGB+5zc/tgk1HJmttI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WTTNRhBBBkbcxJqiMeRn8OmOOYsjGJB9ysQWcEn1dywjmi/ygVTGEwpS2w7Ddcpf1
         nTI5r7M5n17d8ieGIUO494oPRtjarkZwdlIs5ZEt9isLFUfYF6UAXS7SvBYKxkMM8U
         dO+ySZBmgs6vNWNaic32fKZzwTs/3dOaadSV3od4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Kent <raven@themaw.net>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5.14 160/169] autofs: fix wait name hash calculation in autofs_wait()
Date:   Mon, 25 Oct 2021 21:15:41 +0200
Message-Id: <20211025191037.705260758@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ian Kent <raven@themaw.net>

commit 25f54d08f12feb593e62cc2193fedefaf7825301 upstream.

There's a mistake in commit 2be7828c9fefc ("get rid of autofs_getpath()")
that affects kernels from v5.13.0, basically missed because of me not
fully testing the change for Al.

The problem is that the hash calculation for the wait name qstr hasn't
been updated to account for the change to use dentry_path_raw(). This
prevents the correct matching an existing wait resulting in multiple
notifications being sent to the daemon for the same mount which must
not occur.

The problem wasn't discovered earlier because it only occurs when
multiple processes trigger a request for the same mount concurrently
so it only shows up in more aggressive testing.

Fixes: 2be7828c9fefc ("get rid of autofs_getpath()")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/autofs/waitq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/autofs/waitq.c
+++ b/fs/autofs/waitq.c
@@ -358,7 +358,7 @@ int autofs_wait(struct autofs_sb_info *s
 		qstr.len = strlen(p);
 		offset = p - name;
 	}
-	qstr.hash = full_name_hash(dentry, name, qstr.len);
+	qstr.hash = full_name_hash(dentry, qstr.name, qstr.len);
 
 	if (mutex_lock_interruptible(&sbi->wq_mutex)) {
 		kfree(name);


