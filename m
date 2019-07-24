Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94AE773DF4
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390473AbfGXTpC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:45:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:48202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390367AbfGXTpB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:45:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C2F921873;
        Wed, 24 Jul 2019 19:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997500;
        bh=cCppwSJr0bjofVcvvvUKG96XlUL3Q5a7Qy/PHYVQ6EU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TaTIHN4hT46KnifsC9TiISPQie8rXfQB0fHbnunmLppZIuU/FrRIF1bq3/Je+eZuw
         Fhd44z6+zEoMX3dvqj+RhOuUqxlu1SrxEXIlwjnIOfkTO0TSyfO5eJzJcYB+Z3xn5I
         dgiKR2QHrX8lrcjhP3Smwk0VunhfTk1ye1JYYDvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 046/371] media: mc-device.c: dont memset __user pointer contents
Date:   Wed, 24 Jul 2019 21:16:38 +0200
Message-Id: <20190724191728.152569610@linuxfoundation.org>
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

[ Upstream commit 518fa4e0e0da97ea2e17c95ab57647ce748a96e2 ]

You can't memset the contents of a __user pointer. Instead, call copy_to_user to
copy links.reserved (which is zeroed) to the user memory.

This fixes this sparse warning:

SPARSE:drivers/media/mc/mc-device.c drivers/media/mc/mc-device.c:521:16:  warning: incorrect type in argument 1 (different address spaces)

Fixes: f49308878d720 ("media: media_device_enum_links32: clean a reserved field")

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/media-device.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 6893843edada..8e2a66493e62 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -518,8 +518,9 @@ static long media_device_enum_links32(struct media_device *mdev,
 	if (ret)
 		return ret;
 
-	memset(ulinks->reserved, 0, sizeof(ulinks->reserved));
-
+	if (copy_to_user(ulinks->reserved, links.reserved,
+			 sizeof(ulinks->reserved)))
+		return -EFAULT;
 	return 0;
 }
 
-- 
2.20.1



