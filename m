Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF91B7F41C
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 12:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404619AbfHBJle (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:41:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:43186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391012AbfHBJla (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:41:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E844216C8;
        Fri,  2 Aug 2019 09:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564738889;
        bh=qpd/yOb7hCGGWr5xjoaoJ/O2mcFbfXdzoQlG2AbF0zs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DExCKmEW4rXlvUgOSJTXBxH23OV+itRb9mGMs21glDAzOlJv3clJB4SsNjzN3rAkQ
         FTOe/bgYUsuRy9V67IIZP+ACCe5IX7+OpnQHtx8IphLTsajEwa8eWcsmAw3GcG3ChH
         iVy28QW87PfzbBjHNvDWYb+eFes2wCPIzya4HjSA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 020/223] media: mc-device.c: dont memset __user pointer contents
Date:   Fri,  2 Aug 2019 11:34:05 +0200
Message-Id: <20190802092240.375444660@linuxfoundation.org>
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
index 6062c0cfa632..73a2dba475d0 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -490,8 +490,9 @@ static long media_device_enum_links32(struct media_device *mdev,
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



