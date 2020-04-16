Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3CD11AC29A
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896218AbgDPNaV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:30:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:40520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896206AbgDPNaU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:30:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 497FD20767;
        Thu, 16 Apr 2020 13:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587043819;
        bh=TN8Jsvc4R6VFu2iQk7i/opH8BrugUejtTWKPKNSGQOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sDRfM1jMRoxfxD1fF2NhMwDk194SYolsk/9rRwhB3oTOWKo9qSkqB03IeFyBs0Svw
         ngtROKxqe12c9NNIxReG/tM1YgUKHTsRuf75lXysM8Mhtlr933ADTaHK30sU06lT08
         samTD+tNuE/A49zUUkw8gbs4Uv7WunHWJPX9kHqU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jessica Yu <jeyu@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jeff Vander Stoep <jeffv@google.com>,
        Kees Cook <keescook@chromium.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        NeilBrown <neilb@suse.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 112/146] fs/filesystems.c: downgrade user-reachable WARN_ONCE() to pr_warn_once()
Date:   Thu, 16 Apr 2020 15:24:13 +0200
Message-Id: <20200416131257.982156775@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131242.353444678@linuxfoundation.org>
References: <20200416131242.353444678@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 26c5d78c976ca298e59a56f6101a97b618ba3539 upstream.

After request_module(), nothing is stopping the module from being
unloaded until someone takes a reference to it via try_get_module().

The WARN_ONCE() in get_fs_type() is thus user-reachable, via userspace
running 'rmmod' concurrently.

Since WARN_ONCE() is for kernel bugs only, not for user-reachable
situations, downgrade this warning to pr_warn_once().

Keep it printed once only, since the intent of this warning is to detect
a bug in modprobe at boot time.  Printing the warning more than once
wouldn't really provide any useful extra information.

Fixes: 41124db869b7 ("fs: warn in case userspace lied about modprobe return")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Jessica Yu <jeyu@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jeff Vander Stoep <jeffv@google.com>
Cc: Jessica Yu <jeyu@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: NeilBrown <neilb@suse.com>
Cc: <stable@vger.kernel.org>		[4.13+]
Link: http://lkml.kernel.org/r/20200312202552.241885-3-ebiggers@kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/filesystems.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/filesystems.c
+++ b/fs/filesystems.c
@@ -267,7 +267,9 @@ struct file_system_type *get_fs_type(con
 	fs = __get_fs_type(name, len);
 	if (!fs && (request_module("fs-%.*s", len, name) == 0)) {
 		fs = __get_fs_type(name, len);
-		WARN_ONCE(!fs, "request_module fs-%.*s succeeded, but still no fs?\n", len, name);
+		if (!fs)
+			pr_warn_once("request_module fs-%.*s succeeded, but still no fs?\n",
+				     len, name);
 	}
 
 	if (dot && fs && !(fs->fs_flags & FS_HAS_SUBTYPE)) {


