Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3C301451E4
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729605AbgAVJbT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:31:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:43274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729637AbgAVJbT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:31:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CEC1A2467C;
        Wed, 22 Jan 2020 09:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579685478;
        bh=ESPBaorZREIc1Iodc78RRklB2074hleeUq2CS2ya8QA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z3mh0ukLyHosPEz5Kj0RUptyNNYKaqiJ4h88zgN7Lbs03RLnZrW+0N2frl3uP/sQl
         2DVo2jMYTUyn8+v4QVsmBxsbVMOs92J4Dag5iPmP+5kFot9uyeci6YTdBrOX/FZ+ru
         wT8xnr1DFNim8LRLqw3FNCQdA0H/P3Zo27A4CTgc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 03/76] HID: hidraw, uhid: Always report EPOLLOUT
Date:   Wed, 22 Jan 2020 10:28:19 +0100
Message-Id: <20200122092752.061247214@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092751.587775548@linuxfoundation.org>
References: <20200122092751.587775548@linuxfoundation.org>
User-Agent: quilt/0.66
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
 drivers/hid/hidraw.c | 7 ++++---
 drivers/hid/uhid.c   | 5 +++--
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index e60d9c88bd35..ef9e196b54a5 100644
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
diff --git a/drivers/hid/uhid.c b/drivers/hid/uhid.c
index ea0c860ee842..a7ba4db8cff7 100644
--- a/drivers/hid/uhid.c
+++ b/drivers/hid/uhid.c
@@ -769,13 +769,14 @@ unlock:
 static unsigned int uhid_char_poll(struct file *file, poll_table *wait)
 {
 	struct uhid_device *uhid = file->private_data;
+	unsigned int mask = POLLOUT | POLLWRNORM; /* uhid is always writable */
 
 	poll_wait(file, &uhid->waitq, wait);
 
 	if (uhid->head != uhid->tail)
-		return POLLIN | POLLRDNORM;
+		mask |= POLLIN | POLLRDNORM;
 
-	return EPOLLOUT | EPOLLWRNORM;
+	return mask;
 }
 
 static const struct file_operations uhid_fops = {
-- 
2.20.1



