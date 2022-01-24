Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15D09499FD1
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1842213AbiAXXBQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:01:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354423AbiAXWlr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:41:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0391C04D63F;
        Mon, 24 Jan 2022 13:05:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90FDF60B03;
        Mon, 24 Jan 2022 21:05:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6990EC340E5;
        Mon, 24 Jan 2022 21:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058300;
        bh=F/hEJXjFztjsMlfPfO2E5y342r2bldbSUn26RRHGDXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=beR10tR+1/VatBFJHR3y45Lb027ac9sQu29J7xwxwOiiXKBZ6ViWuqlb4DKC7kKx0
         xD36JtSzgKtVq1lffy6KSaHw+JTt908OOpm4nzX+uY/lpZVnjaH8asW3Yt0fg5zncQ
         AQOSvr8BjG/vUmID9ggvf0ufyVszHGv1AJa8G9pM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ricardo Ribalda <ribalda@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0245/1039] media: uvcvideo: Avoid invalid memory access
Date:   Mon, 24 Jan 2022 19:33:54 +0100
Message-Id: <20220124184133.563200222@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit f0577b1b6394f954903fcc67e12fe9e7001dafd6 ]

If mappings points to an invalid memory, we will be invalid accessing
it. Solve it by initializing the value of the variable mapping and by
changing the order in the conditional statement (to avoid accessing
mapping->id if not needed).

Fix:
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN NOPTI

Fixes: 6350d6a4ed487 ("media: uvcvideo: Set error_idx during ctrl_commit errors")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_ctrl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index 30bfe9069a1fb..9a25d60292558 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -1638,7 +1638,7 @@ static int uvc_ctrl_find_ctrl_idx(struct uvc_entity *entity,
 				  struct v4l2_ext_controls *ctrls,
 				  struct uvc_control *uvc_control)
 {
-	struct uvc_control_mapping *mapping;
+	struct uvc_control_mapping *mapping = NULL;
 	struct uvc_control *ctrl_found;
 	unsigned int i;
 
-- 
2.34.1



