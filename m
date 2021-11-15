Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2586450DF4
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:06:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239762AbhKOSJe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:09:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:46080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239728AbhKOSEm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:04:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF3386101B;
        Mon, 15 Nov 2021 17:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997930;
        bh=TBI3aO7xF0u1trT5ru+rFS23Y1JCnXCPXJA1PDBjIPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CDBWlpuXiEYhjavKYoi3ih8o2jP9kJPVf7O1J5mTNFmGBATzgn8vo6Il36BVDiK+X
         W9DyUHLgklesDlJ+cIWu0OWIKZWDIItnRJTgMRT8X4SF9ATVq0/XK+TM0ubEGx1UXr
         oq5W1WRL8yMCl7W2jqhAmQW7IfRY9iVBbvYFFOUw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Lad Prabhakar <prabhakar.csengg@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 294/575] media: i2c: ths8200 needs V4L2_ASYNC
Date:   Mon, 15 Nov 2021 18:00:19 +0100
Message-Id: <20211115165353.946824789@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit e4625044d656f3c33ece0cc9da22577bc10ca5d3 ]

Fix the build errors reported by the kernel test robot by
selecting V4L2_ASYNC:

mips-linux-ld: drivers/media/i2c/ths8200.o: in function `ths8200_remove':
ths8200.c:(.text+0x1ec): undefined reference to `v4l2_async_unregister_subdev'
mips-linux-ld: drivers/media/i2c/ths8200.o: in function `ths8200_probe':
ths8200.c:(.text+0x404): undefined reference to `v4l2_async_register_subdev'

Fixes: ed29f89497006 ("media: i2c: ths8200: support asynchronous probing")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Lad Prabhakar <prabhakar.csengg@gmail.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 878f66ef2719f..5f5a3915ac778 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -595,6 +595,7 @@ config VIDEO_AK881X
 config VIDEO_THS8200
 	tristate "Texas Instruments THS8200 video encoder"
 	depends on VIDEO_V4L2 && I2C
+	select V4L2_ASYNC
 	help
 	  Support for the Texas Instruments THS8200 video encoder.
 
-- 
2.33.0



