Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 503C44A9630
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241710AbiBDJX7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:23:59 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42420 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357221AbiBDJXH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:23:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33842615A5;
        Fri,  4 Feb 2022 09:23:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F43EC004E1;
        Fri,  4 Feb 2022 09:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966586;
        bh=tTUbBlWGxGlAA/M3iRfxvQhYj3pYTSvQpKE+09KRzqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fs4EAAR8gpz7MmIWc698a2HyBQotPqXWgyk7oRBUL2yRxYSGyySut5pUPV9z0v3vA
         QOj3TPiBcDp7HrU54becujwlMfLYrJ4b2xQmEMxpO46LUGfjWAcUudhFqA3Nf8SMuc
         jPr2IF4onVzXQ714DuplOPRMrZUmPLdYCf6lwF4Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "J. Bruce Fields" <bfields@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 10/32] lockd: fix failure to cleanup client locks
Date:   Fri,  4 Feb 2022 10:22:20 +0100
Message-Id: <20220204091915.606336966@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220204091915.247906930@linuxfoundation.org>
References: <20220204091915.247906930@linuxfoundation.org>
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


