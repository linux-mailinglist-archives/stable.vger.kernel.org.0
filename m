Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A62513A516
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729893AbgANKEd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:04:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:60246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725820AbgANKEd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:04:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2F0F2465B;
        Tue, 14 Jan 2020 10:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996272;
        bh=jifw3t86RPlobOIv0GBU83DATCCEB+SoFTw7iSeOiZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nhXr5hT2OA/D0+WGtI2UKKB7RlpzySN/hIXDMcDjl40ACwkKkOuKav6vHk5br3H3d
         u4x9l2yHzxTJRs8RcIs5gu/DOhlSp2tJvir9aKipTzlEW+VkpPzRptflSslW8LBFH3
         wamTDp0jxVnAIaOLAhTTsQ5/Oyh7ZCOd3fj+/DBU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.4 19/78] HID: hidraw: Fix returning EPOLLOUT from hidraw_poll
Date:   Tue, 14 Jan 2020 11:00:53 +0100
Message-Id: <20200114094356.291519748@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094352.428808181@linuxfoundation.org>
References: <20200114094352.428808181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcel Holtmann <marcel@holtmann.org>

commit 9f3b61dc1dd7b81e99e7ed23776bb64a35f39e1a upstream.

When polling a connected /dev/hidrawX device, it is useful to get the
EPOLLOUT when writing is possible. Since writing is possible as soon as
the device is connected, always return it.

Right now EPOLLOUT is only returned when there are also input reports
are available. This works if devices start sending reports when
connected, but some HID devices might need an output report first before
sending any input reports. This change will allow using EPOLLOUT here as
well.

Fixes: 378b80370aa1 ("hidraw: Return EPOLLOUT from hidraw_poll")
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Cc: stable@vger.kernel.org
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hidraw.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -252,10 +252,10 @@ static __poll_t hidraw_poll(struct file
 
 	poll_wait(file, &list->hidraw->wait, wait);
 	if (list->head != list->tail)
-		return EPOLLIN | EPOLLRDNORM | EPOLLOUT;
+		return EPOLLIN | EPOLLRDNORM;
 	if (!list->hidraw->exist)
 		return EPOLLERR | EPOLLHUP;
-	return 0;
+	return EPOLLOUT | EPOLLWRNORM;
 }
 
 static int hidraw_open(struct inode *inode, struct file *file)


