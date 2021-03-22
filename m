Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97BCF3441D0
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:37:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbhCVMgS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:36:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:56134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231685AbhCVMem (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:34:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 868836191A;
        Mon, 22 Mar 2021 12:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416482;
        bh=z3f1V9uZjD/V19KIeAUNsK2dX+kH3ujXiRjv4WcmBXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yvzQFQHPsS2Wms8mSFqcHonbRLkfcmIAKUDiqSQ5nhsRdY1cpc4xqApdMNuyZ3dLk
         DLtjo4gKfZ9A7GsAfaPpv/sUfOt5M0y4GqalEPtJ8iuiy7/YWknxBZB7yUcVlYG8YN
         mzKlEaBLBfqPR600p7vYmnTlou566Bux6gFZRfLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+628472a2aac693ab0fcd@syzkaller.appspotmail.com,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.11 112/120] ext4: fix timer use-after-free on failed mount
Date:   Mon, 22 Mar 2021 13:28:15 +0100
Message-Id: <20210322121933.396744528@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 2a4ae3bcdf05b8639406eaa09a2939f3c6dd8e75 upstream.

When filesystem mount fails because of corrupted filesystem we first
cancel the s_err_report timer reminding fs errors every day and only
then we flush s_error_work. However s_error_work may report another fs
error and re-arm timer thus resulting in timer use-after-free. Fix the
problem by first flushing the work and only after that canceling the
s_err_report timer.

Reported-by: syzbot+628472a2aac693ab0fcd@syzkaller.appspotmail.com
Fixes: 2d01ddc86606 ("ext4: save error info to sb through journal if available")
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20210315165906.2175-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5149,8 +5149,8 @@ failed_mount_wq:
 failed_mount3a:
 	ext4_es_unregister_shrinker(sbi);
 failed_mount3:
-	del_timer_sync(&sbi->s_err_report);
 	flush_work(&sbi->s_error_work);
+	del_timer_sync(&sbi->s_err_report);
 	if (sbi->s_mmp_tsk)
 		kthread_stop(sbi->s_mmp_tsk);
 failed_mount2:


