Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF1A311B640
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731534AbfLKPN5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:13:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:38306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731529AbfLKPN4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:13:56 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54F8824658;
        Wed, 11 Dec 2019 15:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077236;
        bh=h5BqO0kEAfb6H6DsIZdtIPBAb14QrKDF4MSEnkQtzaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oFZ3/jopD77B03NPpCDy7pqJ0SAUEGSqB3tAf8AaOP51+PDzHCKfZnCAQK9UQ5EAK
         nk9pWlLjCvSYA9GkDaTaousui3qcFHJzas1v+YYwtdkwUnALH6fTkGG/mXy9Bks8Sa
         QiAlr7JEKMBZDMWA9JU95fD7mYzMMel5F2pXyRxU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.4 114/134] um: virtio: Keep reading on -EAGAIN
Date:   Wed, 11 Dec 2019 10:11:30 -0500
Message-Id: <20191211151150.19073-114-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 7e60746005573a06149cdee7acedf428906f3a59 ]

When we get an interrupt from the socket getting readable,
and start reading, there's a possibility for a race. This
depends on the implementation of the device, but e.g. with
qemu's libvhost-user, we can see:

 device                 virtio_uml
---------------------------------------
  write header
                         get interrupt
                         read header
                         read body -> returns -EAGAIN
  write body

The -EAGAIN return is because the socket is non-blocking,
and then this leads us to abandon this message.

In fact, we've already read the header, so when the get
another signal/interrupt for the body, we again read it
as though it's a new message header, and also abandon it
for the same reason (wrong size etc.)

This essentially breaks things, and if that message was
one that required a response, it leads to a deadlock as
the device is waiting for the response but we'll never
reply.

Fix this by spinning on -EAGAIN as well when we read the
message body. We need to handle -EAGAIN as "no message"
while reading the header, since we share an interrupt.

Note that this situation is highly unlikely to occur in
normal usage, since there will be very few messages and
only in the startup phase. With the inband call feature
this does tend to happen (eventually) though.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/virtio_uml.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/um/drivers/virtio_uml.c b/arch/um/drivers/virtio_uml.c
index fc8c52cff5aa8..c5643a59a8c76 100644
--- a/arch/um/drivers/virtio_uml.c
+++ b/arch/um/drivers/virtio_uml.c
@@ -83,7 +83,7 @@ static int full_sendmsg_fds(int fd, const void *buf, unsigned int len,
 	return 0;
 }
 
-static int full_read(int fd, void *buf, int len)
+static int full_read(int fd, void *buf, int len, bool abortable)
 {
 	int rc;
 
@@ -93,7 +93,7 @@ static int full_read(int fd, void *buf, int len)
 			buf += rc;
 			len -= rc;
 		}
-	} while (len && (rc > 0 || rc == -EINTR));
+	} while (len && (rc > 0 || rc == -EINTR || (!abortable && rc == -EAGAIN)));
 
 	if (rc < 0)
 		return rc;
@@ -104,7 +104,7 @@ static int full_read(int fd, void *buf, int len)
 
 static int vhost_user_recv_header(int fd, struct vhost_user_msg *msg)
 {
-	return full_read(fd, msg, sizeof(msg->header));
+	return full_read(fd, msg, sizeof(msg->header), true);
 }
 
 static int vhost_user_recv(int fd, struct vhost_user_msg *msg,
@@ -118,7 +118,7 @@ static int vhost_user_recv(int fd, struct vhost_user_msg *msg,
 	size = msg->header.size;
 	if (size > max_payload_size)
 		return -EPROTO;
-	return full_read(fd, &msg->payload, size);
+	return full_read(fd, &msg->payload, size, false);
 }
 
 static int vhost_user_recv_resp(struct virtio_uml_device *vu_dev,
-- 
2.20.1

