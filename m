Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B39217FE64
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbgCJMpa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:45:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:48130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727559AbgCJMp3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:45:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2227A246A2;
        Tue, 10 Mar 2020 12:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844328;
        bh=+cAswMxICauY55nftB9OIrbu+ADdoLTyXUMn+AqHzDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Msfsk2f7E3DvBE5IJ0AbBRHBmviI/nt4g/qM6BWJXA/OoWf57ImnEIpOaKRF8zYiF
         LJW5UyeVAkuj4uzZeFpAyNAQMOFgf81d+ex34MVWxJsDqUnp9/7SmeXbLsrM6AvDUd
         nBKKqFS7caJRJ0faSzXenI/potrZ2otAtl5feOnI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Aleksa Sarai <cyphar@cyphar.com>
Subject: [PATCH 4.9 42/88] namei: only return -ECHILD from follow_dotdot_rcu()
Date:   Tue, 10 Mar 2020 13:38:50 +0100
Message-Id: <20200310123616.295697790@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123606.543939933@linuxfoundation.org>
References: <20200310123606.543939933@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aleksa Sarai <cyphar@cyphar.com>

commit 2b98149c2377bff12be5dd3ce02ae0506e2dd613 upstream.

It's over-zealous to return hard errors under RCU-walk here, given that
a REF-walk will be triggered for all other cases handling ".." under
RCU.

The original purpose of this check was to ensure that if a rename occurs
such that a directory is moved outside of the bind-mount which the
resolution started in, it would be detected and blocked to avoid being
able to mess with paths outside of the bind-mount. However, triggering a
new REF-walk is just as effective a solution.

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Fixes: 397d425dc26d ("vfs: Test for and handle paths that are unreachable from their mnt_root")
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1370,7 +1370,7 @@ static int follow_dotdot_rcu(struct name
 			nd->path.dentry = parent;
 			nd->seq = seq;
 			if (unlikely(!path_connected(&nd->path)))
-				return -ENOENT;
+				return -ECHILD;
 			break;
 		} else {
 			struct mount *mnt = real_mount(nd->path.mnt);


