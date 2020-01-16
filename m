Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 889AF13FDAF
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389207AbgAPX2F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:28:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:60554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389219AbgAPX2E (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:28:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B840A20684;
        Thu, 16 Jan 2020 23:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217284;
        bh=101cqP0KzlxnkRcjGmNRCeYL9xUc37fL65nI2lSgZso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QkVqJtX/EYze+ZxLdWT0439N7NlwU/1PX4LtHMhhD5867fBdMRk/u4KSBZFxg0OBK
         4NcsxW341lC+G/nvxCB0LMNIlOmogZKM/BVgAmYee4zq6wyC2wg8KEMjLWa66IFXJ6
         V1uzimty5Dmiyd9ofgk7eviyJOQoOmF6k7MMJIxQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 02/84] HID: hidraw: Fix returning EPOLLOUT from hidraw_poll
Date:   Fri, 17 Jan 2020 00:17:36 +0100
Message-Id: <20200116231713.508100390@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231713.087649517@linuxfoundation.org>
References: <20200116231713.087649517@linuxfoundation.org>
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
index c75b66d58636..a025b6961896 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -260,10 +260,10 @@ static __poll_t hidraw_poll(struct file *file, poll_table *wait)
 
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
-- 
2.20.1



