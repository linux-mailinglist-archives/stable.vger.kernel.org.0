Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC66F13FCD9
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729351AbgAPXTY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:19:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:45134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729300AbgAPXTY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:19:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C396F2073A;
        Thu, 16 Jan 2020 23:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216763;
        bh=7Aqib8JCONQVzpqSk85YgURpZfClIXobDqC47p+rDhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vZEM/z9jec+jbpldQsdOdsDY1ftSadY8qcYeekJjqgOP4D34v3uRqz3LZLQyWyik1
         DswHL0wgdS9+bEGZvXey7/zSmcP2ruclXSjw2WAOIoKGKYe1cwxVtPcs/kxp+tEuDB
         pe0RhBZwPMwhoQJMWHvqjXYPj+l1d1KngUsgASyI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 001/203] HID: hidraw, uhid: Always report EPOLLOUT
Date:   Fri, 17 Jan 2020 00:15:18 +0100
Message-Id: <20200116231745.317249555@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

[ Upstream commit 9e635c2851df6caee651e589fbf937b637973c91 ]

hidraw and uhid device nodes are always available for writing so we should
always report EPOLLOUT and EPOLLWRNORM bits, not only in the cases when
there is nothing to read.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Fixes: be54e7461ffdc ("HID: uhid: Fix returning EPOLLOUT from uhid_char_poll")
Fixes: 9f3b61dc1dd7b ("HID: hidraw: Fix returning EPOLLOUT from hidraw_poll")
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hidraw.c |    7 ++++---
 drivers/hid/uhid.c   |    5 +++--
 2 files changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -249,13 +249,14 @@ out:
 static __poll_t hidraw_poll(struct file *file, poll_table *wait)
 {
 	struct hidraw_list *list = file->private_data;
+	__poll_t mask = EPOLLOUT | EPOLLWRNORM; /* hidraw is always writable */
 
 	poll_wait(file, &list->hidraw->wait, wait);
 	if (list->head != list->tail)
-		return EPOLLIN | EPOLLRDNORM;
+		mask |= EPOLLIN | EPOLLRDNORM;
 	if (!list->hidraw->exist)
-		return EPOLLERR | EPOLLHUP;
-	return EPOLLOUT | EPOLLWRNORM;
+		mask |= EPOLLERR | EPOLLHUP;
+	return mask;
 }
 
 static int hidraw_open(struct inode *inode, struct file *file)
--- a/drivers/hid/uhid.c
+++ b/drivers/hid/uhid.c
@@ -766,13 +766,14 @@ unlock:
 static __poll_t uhid_char_poll(struct file *file, poll_table *wait)
 {
 	struct uhid_device *uhid = file->private_data;
+	__poll_t mask = EPOLLOUT | EPOLLWRNORM; /* uhid is always writable */
 
 	poll_wait(file, &uhid->waitq, wait);
 
 	if (uhid->head != uhid->tail)
-		return EPOLLIN | EPOLLRDNORM;
+		mask |= EPOLLIN | EPOLLRDNORM;
 
-	return EPOLLOUT | EPOLLWRNORM;
+	return mask;
 }
 
 static const struct file_operations uhid_fops = {


