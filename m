Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8AD13FDF3
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390874AbgAPXbJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:31:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:38738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391461AbgAPXbE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:31:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40105206D9;
        Thu, 16 Jan 2020 23:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217463;
        bh=riP4oTvFvZlV7vKpQziT3Vb6pAwNprRtfkS3JCfULKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uwnfuG4HcnHIe3nKZS73QkV4kSoW/ZViSzrjo1WUYnYPtSJNE2WHCO7cLoNb6L+UX
         EA1Cu3kUGJYNjSTUwiQWf0gE1CLQkBQRnh7avVP7q4a0mg5GDOVQqQS8/wtY10yCLd
         FvhqJ10obKEw9TCGINkzrC9mqxWjxeCgAy/taFew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabian Henneke <fabian.henneke@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 01/71] hidraw: Return EPOLLOUT from hidraw_poll
Date:   Fri, 17 Jan 2020 00:17:59 +0100
Message-Id: <20200116231709.604353412@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231709.377772748@linuxfoundation.org>
References: <20200116231709.377772748@linuxfoundation.org>
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
index 5652bd0ffb4d..1ac82e194818 100644
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



