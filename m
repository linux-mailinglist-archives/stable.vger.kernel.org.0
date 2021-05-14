Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3CAE38086D
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 13:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbhENL1g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 07:27:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:56880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229445AbhENL1g (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 May 2021 07:27:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6C8D61457;
        Fri, 14 May 2021 11:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620991583;
        bh=sEJ2ZnGgka6AMHfswnCfQN5+yKHh6h8UbPzcqIBLCbM=;
        h=Subject:To:From:Date:From;
        b=jdB8sW0e0gKmbLe73Sf8T9xjYIGnsD1oILH5oSgWc/dlikewGjffy5rAodtJ8jOAt
         n9I7gCpo/BD9HU68jcFcZ6jaJ11pjwkOm4GLu2X6Zq0dq2TpAzQqdRFMOgL9dsAXkF
         11e19TYzYEqsfalZQpVpbixcxcUA5qWPblooR41Q=
Subject: patch "uio_hv_generic: Fix a memory leak in error handling paths" added to char-misc-linus
To:     christophe.jaillet@wanadoo.fr, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 14 May 2021 13:26:12 +0200
Message-ID: <1620991572133169@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    uio_hv_generic: Fix a memory leak in error handling paths

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 3ee098f96b8b6c1a98f7f97915f8873164e6af9d Mon Sep 17 00:00:00 2001
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Sun, 9 May 2021 09:13:03 +0200
Subject: uio_hv_generic: Fix a memory leak in error handling paths

If 'vmbus_establish_gpadl()' fails, the (recv|send)_gpadl will not be
updated and 'hv_uio_cleanup()' in the error handling path will not be
able to free the corresponding buffer.

In such a case, we need to free the buffer explicitly.

Fixes: cdfa835c6e5e ("uio_hv_generic: defer opening vmbus until first use")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/4fdaff557deef6f0475d02ba7922ddbaa1ab08a6.1620544055.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/uio/uio_hv_generic.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/uio/uio_hv_generic.c b/drivers/uio/uio_hv_generic.c
index 0330ba99730e..eebc399f2cc7 100644
--- a/drivers/uio/uio_hv_generic.c
+++ b/drivers/uio/uio_hv_generic.c
@@ -296,8 +296,10 @@ hv_uio_probe(struct hv_device *dev,
 
 	ret = vmbus_establish_gpadl(channel, pdata->recv_buf,
 				    RECV_BUFFER_SIZE, &pdata->recv_gpadl);
-	if (ret)
+	if (ret) {
+		vfree(pdata->recv_buf);
 		goto fail_close;
+	}
 
 	/* put Global Physical Address Label in name */
 	snprintf(pdata->recv_name, sizeof(pdata->recv_name),
@@ -316,8 +318,10 @@ hv_uio_probe(struct hv_device *dev,
 
 	ret = vmbus_establish_gpadl(channel, pdata->send_buf,
 				    SEND_BUFFER_SIZE, &pdata->send_gpadl);
-	if (ret)
+	if (ret) {
+		vfree(pdata->send_buf);
 		goto fail_close;
+	}
 
 	snprintf(pdata->send_name, sizeof(pdata->send_name),
 		 "send:%u", pdata->send_gpadl);
-- 
2.31.1


