Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86B1C2E4000
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439246AbgL1OX4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:23:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:60020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439240AbgL1OX4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:23:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA75C22CAF;
        Mon, 28 Dec 2020 14:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165395;
        bh=hBUNVKBil8CIRkRX0SEmR023sBelO4cWLfyYWBPcvaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h+3WToUo9iynsFjTa2YRf/hXI1EJ9rhY/DioDNdQ7XnlG4p6LzO2tYt7r/sAJthmK
         HWYAI/lSuSS53tLvkRmw0OHu5mryRm4tkpwpzcJ3lFnn/eKqhSwpbhlN1VU3r9cynL
         Ul55ks6hvNYlQW3Q9hP6iDx+1IY6EOhexiauTO4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Joan=20Bruguera=20Mic=C3=B3?= <joanbrugueram@gmail.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 509/717] proc mountinfo: make splice available again
Date:   Mon, 28 Dec 2020 13:48:27 +0100
Message-Id: <20201228125045.347625595@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 14e3e989f6a5d9646b6cf60690499cc8bdc11f7d ]

Since commit 36e2c7421f02 ("fs: don't allow splice read/write without
explicit ops") we've required that file operation structures explicitly
enable splice support, rather than falling back to the default handlers.

Most /proc files use the indirect 'struct proc_ops' to describe their
file operations, and were fixed up to support splice earlier in commits
40be821d627c..b24c30c67863, but the mountinfo files interact with the
VFS directly using their own 'struct file_operations' and got missed as
a result.

This adds the necessary support for splice to work for /proc/*/mountinfo
and friends.

Reported-by: Joan Bruguera Micó <joanbrugueram@gmail.com>
Reported-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=209971
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc_namespace.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/fs/proc_namespace.c
+++ b/fs/proc_namespace.c
@@ -320,7 +320,8 @@ static int mountstats_open(struct inode
 
 const struct file_operations proc_mounts_operations = {
 	.open		= mounts_open,
-	.read		= seq_read,
+	.read_iter	= seq_read_iter,
+	.splice_read	= generic_file_splice_read,
 	.llseek		= seq_lseek,
 	.release	= mounts_release,
 	.poll		= mounts_poll,
@@ -328,7 +329,8 @@ const struct file_operations proc_mounts
 
 const struct file_operations proc_mountinfo_operations = {
 	.open		= mountinfo_open,
-	.read		= seq_read,
+	.read_iter	= seq_read_iter,
+	.splice_read	= generic_file_splice_read,
 	.llseek		= seq_lseek,
 	.release	= mounts_release,
 	.poll		= mounts_poll,
@@ -336,7 +338,8 @@ const struct file_operations proc_mounti
 
 const struct file_operations proc_mountstats_operations = {
 	.open		= mountstats_open,
-	.read		= seq_read,
+	.read_iter	= seq_read_iter,
+	.splice_read	= generic_file_splice_read,
 	.llseek		= seq_lseek,
 	.release	= mounts_release,
 };


