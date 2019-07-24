Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3330C73A36
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391313AbfGXTrz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:47:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:54812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391323AbfGXTry (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:47:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A732F214AF;
        Wed, 24 Jul 2019 19:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997673;
        bh=POqmnfsdjW2YE7RA6gm2zgkT5QX5hLbLBVi5trCiFas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cJSAivacrz1ERibywTYMhrtF8Bq0FX2+v1BjkHW38UISXnfs34ZCmpPD03Duwiz8T
         2En0MaA+WXUv6mC8qsp8Qk79QR9OqdTPZKlbwLlYoojxtbP/cNVhgFhEK50j3Hwslb
         ExjMFWBGfRXuJZul3KjcV392k/Wpx6hcaL/O3mhQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        syzbot+2e1ef9188251d9cc7944@syzkaller.appspotmail.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 077/371] media: uvcvideo: Fix access to uninitialized fields on probe error
Date:   Wed, 24 Jul 2019 21:17:09 +0200
Message-Id: <20190724191730.667452864@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 11a087f484bf15ff65f0a9f277aa5a61fd07ed2a ]

We need to check whether this work we are canceling actually is
initialized.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Reported-by: syzbot+2e1ef9188251d9cc7944@syzkaller.appspotmail.com
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_ctrl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index 14cff91b7aea..aa021498036a 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -2350,7 +2350,9 @@ void uvc_ctrl_cleanup_device(struct uvc_device *dev)
 	struct uvc_entity *entity;
 	unsigned int i;
 
-	cancel_work_sync(&dev->async_ctrl.work);
+	/* Can be uninitialized if we are aborting on probe error. */
+	if (dev->async_ctrl.work.func)
+		cancel_work_sync(&dev->async_ctrl.work);
 
 	/* Free controls and control mappings for all entities. */
 	list_for_each_entry(entity, &dev->entities, list) {
-- 
2.20.1



