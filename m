Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09C2B13FE92
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389100AbgAPXgj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:36:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:39842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403950AbgAPXbb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:31:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F31DF20684;
        Thu, 16 Jan 2020 23:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217490;
        bh=KzzGoiUefA+UiWCziIFSnQB/+nCuUdc0IuaC+BAlcOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iP69qk8kle7bAb9PQZEZjH0CKvCU39xpbUEecTy+CX91ZzcstE/ZtyYmCQsgbMzPu
         aP77GgnfV2h7G7kD6tlfmkhIHwG2MtBYiX2bPW2f8KrakEQZS7nGb5HVPCFH3pA/vk
         Xh3n4GrGUxVDh0CHsCM4+DUNmVU/dbDvog8ymqvA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 02/71] HID: hidraw: Fix returning EPOLLOUT from hidraw_poll
Date:   Fri, 17 Jan 2020 00:18:00 +0100
Message-Id: <20200116231709.755803954@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231709.377772748@linuxfoundation.org>
References: <20200116231709.377772748@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcel Holtmann <marcel@holtmann.org>

[ Upstream commit 9f3b61dc1dd7b81e99e7ed23776bb64a35f39e1a ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hidraw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index 1ac82e194818..1abf5008def0 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -260,10 +260,10 @@ static unsigned int hidraw_poll(struct file *file, poll_table *wait)
 
 	poll_wait(file, &list->hidraw->wait, wait);
 	if (list->head != list->tail)
-		return POLLIN | POLLRDNORM | POLLOUT;
+		return POLLIN | POLLRDNORM;
 	if (!list->hidraw->exist)
 		return POLLERR | POLLHUP;
-	return 0;
+	return POLLOUT | POLLWRNORM;
 }
 
 static int hidraw_open(struct inode *inode, struct file *file)
-- 
2.20.1



