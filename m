Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B61817F1B4
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391813AbfHBJlP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:41:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:42718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391809AbfHBJlP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:41:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2AB42087E;
        Fri,  2 Aug 2019 09:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564738874;
        bh=/sGJVzo98w2BTi+g1+08yolXgzG0Zb45X9JsulVGuRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IwjNvxnK6+sNBuBpSx77ck9q6jfykqgGPRIXkStWv5KNcdIUqXMT4eE6jmU76IUDz
         UIQAJDFbXqDtyymmfAGYdAWR1m7t5yL8iNNa0ez6K/VSJAlAySyz9ia5/ycX68KkHq
         PQtGYXC38og9DO6DIsd0CsPyYmyQkQh0FPcn09fc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jungo Lin <jungo.lin@mediatek.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 014/223] media: media_device_enum_links32: clean a reserved field
Date:   Fri,  2 Aug 2019 11:33:59 +0200
Message-Id: <20190802092239.891285103@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



