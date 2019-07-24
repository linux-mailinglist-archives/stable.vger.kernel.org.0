Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29FFC73E12
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390781AbfGXToP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:44:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390770AbfGXToO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:44:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61B2A214AF;
        Wed, 24 Jul 2019 19:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997453;
        bh=G5+9tOKfggG9ArmxDYJRKpm1HlpZ+AmbuewaNhRrSb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jmcAVLyrdAfVEhIotQ520ZMjcvKd12oD9YkuHmzGlM24ODNGPJ8795XE8IbLCJVtY
         bUpAYgTe3I14c5eBvXbaIy8pnIwdNYEHmEwbKBVBikbdpLSYuX5EpHh1Fj57eVftMY
         E8xh7c38n5cBrNTIvvPWZcSA6N8pi5v4g2mFU8q8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jungo Lin <jungo.lin@mediatek.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 029/371] media: media_device_enum_links32: clean a reserved field
Date:   Wed, 24 Jul 2019 21:16:21 +0200
Message-Id: <20190724191726.684945920@linuxfoundation.org>
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
index b8ec88612df7..6893843edada 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -502,6 +502,7 @@ static long media_device_enum_links32(struct media_device *mdev,
 {
 	struct media_links_enum links;
 	compat_uptr_t pads_ptr, links_ptr;
+	int ret;
 
 	memset(&links, 0, sizeof(links));
 
@@ -513,7 +514,13 @@ static long media_device_enum_links32(struct media_device *mdev,
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



