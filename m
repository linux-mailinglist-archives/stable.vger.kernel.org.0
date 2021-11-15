Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4B5451FE7
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353323AbhKPApp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:45:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:44648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343785AbhKOTWD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:22:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDCA663388;
        Mon, 15 Nov 2021 18:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001964;
        bh=5Gnvu4l/mw3nqh33uP1ZBV9eq5h0bZTuf6rqVGPReUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QquqDDPilD8SyZDS9bIvpyiRxiYX+32I7aULkwmXgCylTyusodKGCSgdjuT7zlXTq
         99riMXu28o5s2DVMs9PGFlxW9SoQ86KZf5mrUhbJ5uhR2VlU3s02LFgNNlgYYZloj2
         YZCo/YM3GR2arVYNi93u4NHmefGOQGL/Zi2bh0OA=
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
Subject: [PATCH 5.15 388/917] media: i2c: ths8200 needs V4L2_ASYNC
Date:   Mon, 15 Nov 2021 17:58:03 +0100
Message-Id: <20211115165441.926115004@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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
index 08feb3e8c1bf6..6157e73eef24e 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -597,6 +597,7 @@ config VIDEO_AK881X
 config VIDEO_THS8200
 	tristate "Texas Instruments THS8200 video encoder"
 	depends on VIDEO_V4L2 && I2C
+	select V4L2_ASYNC
 	help
 	  Support for the Texas Instruments THS8200 video encoder.
 
-- 
2.33.0



