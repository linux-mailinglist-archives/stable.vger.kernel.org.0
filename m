Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF65169444
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 16:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404272AbfGOOhJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:37:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:58238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404253AbfGOOhI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:37:08 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46976217F4;
        Mon, 15 Jul 2019 14:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563201427;
        bh=CrjBV49IGhU+4qNoawhl4ZxsHGG8qL2L8GJ2OBQdp0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rwc1fLaqLJfQe9Cw70M9i6kTffaLztq+Bg96A1Uv79++W4L0IQFUlEPPR0NBQ/ncP
         xXI0KvZ8T/G3LSy0yjhY5dorKHEbiGUrynWgRp76QUJ0jFxSAkDqJ64bhVRfGhyWwt
         8URkGukCRO+D8JhcnWApWaX6ypNY0EkRT2Aqz7MQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jungo Lin <jungo.lin@mediatek.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 10/73] media: media_device_enum_links32: clean a reserved field
Date:   Mon, 15 Jul 2019 10:35:26 -0400
Message-Id: <20190715143629.10893-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715143629.10893-1-sashal@kernel.org>
References: <20190715143629.10893-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jungo Lin <jungo.lin@mediatek.com>

[ Upstream commit f49308878d7202e07d8761238e01bd0e5fce2750 ]

In v4l2-compliance utility, test MEDIA_IOC_ENUM_ENTITIES
will check whether reserved field of media_links_enum filled
with zero.

However, for 32 bit program, the reserved field is missing
copy from kernel space to user space in media_device_enum_links32
function.

This patch adds the cleaning a reserved field logic in
media_device_enum_links32 function.

Signed-off-by: Jungo Lin <jungo.lin@mediatek.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/media-device.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 6f46c59415fe..6062c0cfa632 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -474,6 +474,7 @@ static long media_device_enum_links32(struct media_device *mdev,
 {
 	struct media_links_enum links;
 	compat_uptr_t pads_ptr, links_ptr;
+	int ret;
 
 	memset(&links, 0, sizeof(links));
 
@@ -485,7 +486,13 @@ static long media_device_enum_links32(struct media_device *mdev,
 	links.pads = compat_ptr(pads_ptr);
 	links.links = compat_ptr(links_ptr);
 
-	return media_device_enum_links(mdev, &links);
+	ret = media_device_enum_links(mdev, &links);
+	if (ret)
+		return ret;
+
+	memset(ulinks->reserved, 0, sizeof(ulinks->reserved));
+
+	return 0;
 }
 
 #define MEDIA_IOC_ENUM_LINKS32		_IOWR('|', 0x02, struct media_links_enum32)
-- 
2.20.1

