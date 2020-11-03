Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3F002A51B2
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730634AbgKCUnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:43:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:56614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729964AbgKCUnO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:43:14 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49C282224E;
        Tue,  3 Nov 2020 20:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436193;
        bh=J8KuJl1/K8rhrVW1l2iJSlUTzFLshYrulf04j/Hssg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1MULf3h9uDqnuWkMmT3384S+K2orwvWmYyaKkAs/ApYfRJmL7r8zCRVuh1wHPIq2Y
         v6394R/DCm4hPDzQhmAwA2/a6+vk6N+qqmJCs0r0PAaETnRbgLnkYava9PKNHpl6pi
         ailvrQa4cRf9AJMc8DpGBTv3NNgtcxseK5nXcgSI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Daniel W. S. Almeida" <dwlsalmeida@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 105/391] media: uvcvideo: Fix dereference of out-of-bound list iterator
Date:   Tue,  3 Nov 2020 21:32:36 +0100
Message-Id: <20201103203353.910358959@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel W. S. Almeida <dwlsalmeida@gmail.com>

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
index a30a8a731eda8..c13ed95cb06fe 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -1848,30 +1848,35 @@ int uvc_xu_ctrl_query(struct uvc_video_chain *chain,
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
2.27.0



