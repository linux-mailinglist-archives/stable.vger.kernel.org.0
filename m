Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 596EDB5CDE
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730164AbfIRGZk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:25:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:46706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729428AbfIRGZj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:25:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C3CE21920;
        Wed, 18 Sep 2019 06:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787938;
        bh=TDQtsNsNqnnTlw/BrxgM+zecyV9TXa5Q7nNcLGbRio8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vrjtyfyPdjjtYNWhrTVDLGvOf1KKfFVAeVUoJIZNrRqI4uRYpigG66s1iO7PZdG4J
         JdIOOC/aAF2Lth68lfBQT/XxcFbI3812U9b1tUTGPnCSarl3tTeUPIGV9GAzqK+R/S
         ecQNzc9B8VmMPdizPoo6LWawRje/5tZuAmZSpAUc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot+0849c524d9c634f5ae66@syzkaller.appspotmail.com
Subject: [PATCH 5.2 04/85] isdn/capi: check message length in capi_write()
Date:   Wed, 18 Sep 2019 08:18:22 +0200
Message-Id: <20190918061234.266484082@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061234.107708857@linuxfoundation.org>
References: <20190918061234.107708857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit fe163e534e5eecdfd7b5920b0dfd24c458ee85d6 ]

syzbot reported:

    BUG: KMSAN: uninit-value in capi_write+0x791/0xa90 drivers/isdn/capi/capi.c:700
    CPU: 0 PID: 10025 Comm: syz-executor379 Not tainted 4.20.0-rc7+ #2
    Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
    Call Trace:
      __dump_stack lib/dump_stack.c:77 [inline]
      dump_stack+0x173/0x1d0 lib/dump_stack.c:113
      kmsan_report+0x12e/0x2a0 mm/kmsan/kmsan.c:613
      __msan_warning+0x82/0xf0 mm/kmsan/kmsan_instr.c:313
      capi_write+0x791/0xa90 drivers/isdn/capi/capi.c:700
      do_loop_readv_writev fs/read_write.c:703 [inline]
      do_iter_write+0x83e/0xd80 fs/read_write.c:961
      vfs_writev fs/read_write.c:1004 [inline]
      do_writev+0x397/0x840 fs/read_write.c:1039
      __do_sys_writev fs/read_write.c:1112 [inline]
      __se_sys_writev+0x9b/0xb0 fs/read_write.c:1109
      __x64_sys_writev+0x4a/0x70 fs/read_write.c:1109
      do_syscall_64+0xbc/0xf0 arch/x86/entry/common.c:291
      entry_SYSCALL_64_after_hwframe+0x63/0xe7
    [...]

The problem is that capi_write() is reading past the end of the message.
Fix it by checking the message's length in the needed places.

Reported-and-tested-by: syzbot+0849c524d9c634f5ae66@syzkaller.appspotmail.com
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/isdn/capi/capi.c          |   10 +++++++++-
 include/uapi/linux/isdn/capicmd.h |    1 +
 2 files changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -688,6 +688,9 @@ capi_write(struct file *file, const char
 	if (!cdev->ap.applid)
 		return -ENODEV;
 
+	if (count < CAPIMSG_BASELEN)
+		return -EINVAL;
+
 	skb = alloc_skb(count, GFP_USER);
 	if (!skb)
 		return -ENOMEM;
@@ -698,7 +701,8 @@ capi_write(struct file *file, const char
 	}
 	mlen = CAPIMSG_LEN(skb->data);
 	if (CAPIMSG_CMD(skb->data) == CAPI_DATA_B3_REQ) {
-		if ((size_t)(mlen + CAPIMSG_DATALEN(skb->data)) != count) {
+		if (count < CAPI_DATA_B3_REQ_LEN ||
+		    (size_t)(mlen + CAPIMSG_DATALEN(skb->data)) != count) {
 			kfree_skb(skb);
 			return -EINVAL;
 		}
@@ -711,6 +715,10 @@ capi_write(struct file *file, const char
 	CAPIMSG_SETAPPID(skb->data, cdev->ap.applid);
 
 	if (CAPIMSG_CMD(skb->data) == CAPI_DISCONNECT_B3_RESP) {
+		if (count < CAPI_DISCONNECT_B3_RESP_LEN) {
+			kfree_skb(skb);
+			return -EINVAL;
+		}
 		mutex_lock(&cdev->lock);
 		capincci_free(cdev, CAPIMSG_NCCI(skb->data));
 		mutex_unlock(&cdev->lock);
--- a/include/uapi/linux/isdn/capicmd.h
+++ b/include/uapi/linux/isdn/capicmd.h
@@ -16,6 +16,7 @@
 #define CAPI_MSG_BASELEN		8
 #define CAPI_DATA_B3_REQ_LEN		(CAPI_MSG_BASELEN+4+4+2+2+2)
 #define CAPI_DATA_B3_RESP_LEN		(CAPI_MSG_BASELEN+4+2)
+#define CAPI_DISCONNECT_B3_RESP_LEN	(CAPI_MSG_BASELEN+4)
 
 /*----- CAPI commands -----*/
 #define CAPI_ALERT		    0x01


