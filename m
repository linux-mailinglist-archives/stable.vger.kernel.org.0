Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1B5B1B67A6
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728946AbgDWXIY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:08:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51046 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728676AbgDWXHA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:07:00 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvm-0004z3-85; Fri, 24 Apr 2020 00:06:54 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvk-00E73d-1A; Fri, 24 Apr 2020 00:06:52 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Max Kellermann" <max@duempel.org>,
        "Mauro Carvalho Chehab" <mchehab@osg.samsung.com>
Date:   Fri, 24 Apr 2020 00:07:47 +0100
Message-ID: <lsq.1587683028.792912257@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 240/245] [media] media-devnode: add missing mutex
 lock in error handler
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

From: Max Kellermann <max@duempel.org>

commit 88336e174645948da269e1812f138f727cd2896b upstream.

We should protect the device unregister patch too, at the error
condition.

Signed-off-by: Max Kellermann <max@duempel.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/media-devnode.c | 3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/media/media-devnode.c
+++ b/drivers/media/media-devnode.c
@@ -282,8 +282,11 @@ int __must_check media_devnode_register(
 	return 0;
 
 error:
+	mutex_lock(&media_devnode_lock);
 	cdev_del(&mdev->cdev);
 	clear_bit(mdev->minor, media_devnode_nums);
+	mutex_unlock(&media_devnode_lock);
+
 	return ret;
 }
 

