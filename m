Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEF94A967A
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357681AbiBDJ01 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:26:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357979AbiBDJY7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:24:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CA65C06173D;
        Fri,  4 Feb 2022 01:24:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 299C4B836F3;
        Fri,  4 Feb 2022 09:24:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54167C004E1;
        Fri,  4 Feb 2022 09:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966697;
        bh=tTUbBlWGxGlAA/M3iRfxvQhYj3pYTSvQpKE+09KRzqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KvnL2MEPwtFGcuvkPgqgW91Rx4YkzWvVyHv6DR2QjpH8a8+JDJBczYInsIWEXojvz
         nhWxu3kGLmSF06ugtRvtW4rsisTJI8qH1t8Bad1+LkduGDJYktMS40o7s9NIL8HI8Y
         Vy8e4DYHJFd1sjtlYdrpa4biVZVdtx8X08T9P2Go=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "J. Bruce Fields" <bfields@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.16 11/43] lockd: fix failure to cleanup client locks
Date:   Fri,  4 Feb 2022 10:22:18 +0100
Message-Id: <20220204091917.547635687@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220204091917.166033635@linuxfoundation.org>
References: <20220204091917.166033635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: J. Bruce Fields <bfields@redhat.com>

commit d19a7af73b5ecaac8168712d18be72b9db166768 upstream.

In my testing, we're sometimes hitting the request->fl_flags & FL_EXISTS
case in posix_lock_inode, presumably just by random luck since we're not
actually initializing fl_flags here.

This probably didn't matter before commit 7f024fcd5c97 ("Keep read and
write fds with each nlm_file") since we wouldn't previously unlock
unless we knew there were locks.

But now it causes lockd to give up on removing more locks.

We could just initialize fl_flags, but really it seems dubious to be
calling vfs_lock_file with random values in some of the fields.

Fixes: 7f024fcd5c97 ("Keep read and write fds with each nlm_file")
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
[ cel: fixed checkpatch.pl nit ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/lockd/svcsubs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/lockd/svcsubs.c
+++ b/fs/lockd/svcsubs.c
@@ -180,6 +180,7 @@ static int nlm_unlock_files(struct nlm_f
 {
 	struct file_lock lock;
 
+	locks_init_lock(&lock);
 	lock.fl_type  = F_UNLCK;
 	lock.fl_start = 0;
 	lock.fl_end   = OFFSET_MAX;


