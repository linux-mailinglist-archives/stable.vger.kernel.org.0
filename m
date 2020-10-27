Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18AB9299F15
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438768AbgJ0AGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:06:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:53650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437769AbgJ0AEt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 20:04:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BE5E20791;
        Tue, 27 Oct 2020 00:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603757088;
        bh=jiLgywdeFaaW3YAtsRFsT4zumVnQ4Ma6mwFwdQXqcgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=efPfb+n1wneexSKFw21Z0dNMvWD40hMFJeI0CbtQYBhZ9jpblAEJyofC3zIVkgIbQ
         1J8t2jrCMUbMLWsRkdT4D7MaYwR9GY+zGfXdLC5fnAbFmArie69MLb9v3gdZsKcYCA
         0lFWmyct36KHYqb39+/2FCxFR2sAaMXQfEmFSbK8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Daniel W. S. Almeida" <dwlsalmeida@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 27/60] media: uvcvideo: Fix dereference of out-of-bound list iterator
Date:   Mon, 26 Oct 2020 20:03:42 -0400
Message-Id: <20201027000415.1026364-27-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201027000415.1026364-1-sashal@kernel.org>
References: <20201027000415.1026364-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Daniel W. S. Almeida" <dwlsalmeida@gmail.com>

[ Upstream commit f875bcc375c738bf2f599ff2e1c5b918dbd07c45 ]

Fixes the following coccinelle report:

drivers/media/usb/uvc/uvc_ctrl.c:1860:5-11:
ERROR: invalid reference to the index variable of the iterator on line 1854

by adding a boolean variable to check if the loop has found the

Found using - Coccinelle (http://coccinelle.lip6.fr)

[Replace cursor variable with bool found]

Signed-off-by: Daniel W. S. Almeida <dwlsalmeida@gmail.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_ctrl.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index f2854337cdcac..262b7ba4674a7 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -1849,30 +1849,35 @@ int uvc_xu_ctrl_query(struct uvc_video_chain *chain,
 {
 	struct uvc_entity *entity;
 	struct uvc_control *ctrl;
-	unsigned int i, found = 0;
+	unsigned int i;
+	bool found;
 	u32 reqflags;
 	u16 size;
 	u8 *data = NULL;
 	int ret;
 
 	/* Find the extension unit. */
+	found = false;
 	list_for_each_entry(entity, &chain->entities, chain) {
 		if (UVC_ENTITY_TYPE(entity) == UVC_VC_EXTENSION_UNIT &&
-		    entity->id == xqry->unit)
+		    entity->id == xqry->unit) {
+			found = true;
 			break;
+		}
 	}
 
-	if (entity->id != xqry->unit) {
+	if (!found) {
 		uvc_trace(UVC_TRACE_CONTROL, "Extension unit %u not found.\n",
 			xqry->unit);
 		return -ENOENT;
 	}
 
 	/* Find the control and perform delayed initialization if needed. */
+	found = false;
 	for (i = 0; i < entity->ncontrols; ++i) {
 		ctrl = &entity->controls[i];
 		if (ctrl->index == xqry->selector - 1) {
-			found = 1;
+			found = true;
 			break;
 		}
 	}
-- 
2.25.1

