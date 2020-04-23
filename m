Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E55A1B6845
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728594AbgDWXNr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:13:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49998 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728485AbgDWXGu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:50 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvY-0004mt-Sy; Fri, 24 Apr 2020 00:06:40 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvV-00E6vU-3i; Fri, 24 Apr 2020 00:06:37 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jiri Kosina" <jkosina@suse.cz>,
        "Linus Torvalds" <torvalds@linux-foundation.org>
Date:   Fri, 24 Apr 2020 00:06:38 +0100
Message-ID: <lsq.1587683028.439244510@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 171/245] HID: hidraw, uhid: Always report EPOLLOUT
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Kosina <jkosina@suse.cz>

commit 9e635c2851df6caee651e589fbf937b637973c91 upstream.

hidraw and uhid device nodes are always available for writing so we should
always report EPOLLOUT and EPOLLWRNORM bits, not only in the cases when
there is nothing to read.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Fixes: be54e7461ffdc ("HID: uhid: Fix returning EPOLLOUT from uhid_char_poll")
Fixes: 9f3b61dc1dd7b ("HID: hidraw: Fix returning EPOLLOUT from hidraw_poll")
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
[bwh: Backported to 3.16:
 - Use unsigned int type instead of __poll_t
 - s/EPOLL/POLL/g]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hid/hidraw.c | 7 ++++---
 drivers/hid/uhid.c   | 5 +++--
 2 files changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -262,13 +262,14 @@ out:
 static unsigned int hidraw_poll(struct file *file, poll_table *wait)
 {
 	struct hidraw_list *list = file->private_data;
+	unsigned int mask = POLLOUT | POLLWRNORM; /* hidraw is always writable */
 
 	poll_wait(file, &list->hidraw->wait, wait);
 	if (list->head != list->tail)
-		return POLLIN | POLLRDNORM;
+		mask |= POLLIN | POLLRDNORM;
 	if (!list->hidraw->exist)
-		return POLLERR | POLLHUP;
-	return POLLOUT | POLLWRNORM;
+		mask |= POLLERR | POLLHUP;
+	return mask;
 }
 
 static int hidraw_open(struct inode *inode, struct file *file)
--- a/drivers/hid/uhid.c
+++ b/drivers/hid/uhid.c
@@ -720,13 +720,14 @@ unlock:
 static unsigned int uhid_char_poll(struct file *file, poll_table *wait)
 {
 	struct uhid_device *uhid = file->private_data;
+	unsigned int mask = POLLOUT | POLLWRNORM; /* uhid is always writable */
 
 	poll_wait(file, &uhid->waitq, wait);
 
 	if (uhid->head != uhid->tail)
-		return POLLIN | POLLRDNORM;
+		mask |= POLLIN | POLLRDNORM;
 
-	return POLLOUT | POLLWRNORM;
+	return mask;
 }
 
 static const struct file_operations uhid_fops = {

