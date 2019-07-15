Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C42E69669
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 17:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388108AbfGOOIT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:08:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:58324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388474AbfGOOIR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:08:17 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27BEB2081C;
        Mon, 15 Jul 2019 14:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199696;
        bh=DFKCF5t4ld05/ZNuT6Ta+3nNlNLCVq+XxwCK4tQ93jU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vMoRC+v1wtZuxXslxq0CNQhz5Adxl0cPbfzf7EVu3M2g791wsUxllO/uQ7D+eMjwt
         PBE0nuNHqYhp09VQlGIiJEtlgkgfNSwL7YcnIpAzTLNYxjr2mh2NTj890L1D/DGaRH
         q5DhL5/R5cYOWnOmJ8D377LlBC+FyaQra5SBwUJ8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>,
        syzbot+2e1ef9188251d9cc7944@syzkaller.appspotmail.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 075/219] media: uvcvideo: Fix access to uninitialized fields on probe error
Date:   Mon, 15 Jul 2019 10:01:16 -0400
Message-Id: <20190715140341.6443-75-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715140341.6443-1-sashal@kernel.org>
References: <20190715140341.6443-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

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

