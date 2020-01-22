Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19A31144F02
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729187AbgAVJde (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:33:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:47456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729971AbgAVJde (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:33:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37E5524672;
        Wed, 22 Jan 2020 09:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579685613;
        bh=h75wv1ygov80rZ4QFyPJPfICGEtZEMxnledRf1EoPfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ERQGTl1SR7zWIreeEfwdnM8U/1ieORs965aPDUbpEhAHzqtXcdH4xwG1rtC8foBWi
         AXy0iMxY2zyiWZVt9kDsVEqA1RrlbHS3T4hOERFT57AdyGM3C7pFFCIKLJnEBWTez4
         4mkq+NoiXNbinX+4IH0kjsXQS56ymzxxBxsXuTLs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabian Henneke <fabian.henneke@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 01/97] hidraw: Return EPOLLOUT from hidraw_poll
Date:   Wed, 22 Jan 2020 10:28:05 +0100
Message-Id: <20200122092755.916344554@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092755.678349497@linuxfoundation.org>
References: <20200122092755.678349497@linuxfoundation.org>
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

From: Fabian Henneke <fabian.henneke@gmail.com>

[ Upstream commit 378b80370aa1fe50f9c48a3ac8af3e416e73b89f ]

Always return EPOLLOUT from hidraw_poll when a device is connected.
This is safe since writes are always possible (but will always block).

hidraw does not support non-blocking writes and instead always calls
blocking backend functions on write requests. Hence, so far, a call to
poll never returned EPOLLOUT, which confuses tools like socat.

Signed-off-by: Fabian Henneke <fabian.henneke@gmail.com>
In-reply-to: <CA+hv5qkyis03CgYTWeWX9cr0my-d2Oe+aZo+mjmWRXgjrGqyrw@mail.gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hidraw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index 750c16897130..225456c1a39a 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -260,7 +260,7 @@ static unsigned int hidraw_poll(struct file *file, poll_table *wait)
 
 	poll_wait(file, &list->hidraw->wait, wait);
 	if (list->head != list->tail)
-		return POLLIN | POLLRDNORM;
+		return POLLIN | POLLRDNORM | POLLOUT;
 	if (!list->hidraw->exist)
 		return POLLERR | POLLHUP;
 	return 0;
-- 
2.20.1



