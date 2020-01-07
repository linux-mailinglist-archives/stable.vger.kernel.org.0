Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17FA113333C
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729304AbgAGVFy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:05:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:53516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729111AbgAGVFx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:05:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83D472077B;
        Tue,  7 Jan 2020 21:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431153;
        bh=E9YejP0q1JBAbBCT8XUt7j/35G/ZSQogs0nU1uMbpwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1ZIUdRR7YlmARBHSXvnUFHrweRSOWV+x8fRBAUDlr3FB5cWAg8vow7YCW+sZMEb9g
         QXg35gMZYSDobXEPoO/TaUmP4Lh5RJ9d5kt/2Ic1FDMeRbmJMGld5EOnMb5PZj3ntj
         fnV1WQvmYsXwlVAYfEbu28LFARrKl5XY9Ss8UGrw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 4.19 056/115] locks: print unsigned ino in /proc/locks
Date:   Tue,  7 Jan 2020 21:54:26 +0100
Message-Id: <20200107205302.905844138@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205240.283674026@linuxfoundation.org>
References: <20200107205240.283674026@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

commit 98ca480a8f22fdbd768e3dad07024c8d4856576c upstream.

An ino is unsigned, so display it as such in /proc/locks.

Cc: stable@vger.kernel.org
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/locks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/locks.c
+++ b/fs/locks.c
@@ -2678,7 +2678,7 @@ static void lock_get_status(struct seq_f
 	}
 	if (inode) {
 		/* userspace relies on this representation of dev_t */
-		seq_printf(f, "%d %02x:%02x:%ld ", fl_pid,
+		seq_printf(f, "%d %02x:%02x:%lu ", fl_pid,
 				MAJOR(inode->i_sb->s_dev),
 				MINOR(inode->i_sb->s_dev), inode->i_ino);
 	} else {


