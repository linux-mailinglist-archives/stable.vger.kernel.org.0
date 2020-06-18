Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C034D1FE615
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbgFRCak (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:30:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:46072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728640AbgFRBPp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:15:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E69721D7D;
        Thu, 18 Jun 2020 01:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442945;
        bh=yAGnv5NF9mvvxUNTEYI6rE58f1spSCkxNZHtPu3k9a0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cu0zPtxq+H+gtMjvoCdlrlqjMBXHAKl9DrAoFXKYrGf4GxThLxMCkBkHbwAildDEm
         dzkoYRvb5H2uEGTjBpCvzvr0+btAQeSkgE4b99wqO1btWVok9kwXCXi7PxXtLFf+kf
         pU9hJkZsNI4KAmG0K5HP1zJT/thpwTP95fJJ9PuE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Max Staudt <max@enpas.org>, kernel test robot <lkp@intel.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 355/388] i2c: icy: Fix build with CONFIG_AMIGA_PCMCIA=n
Date:   Wed, 17 Jun 2020 21:07:32 -0400
Message-Id: <20200618010805.600873-355-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Staudt <max@enpas.org>

[ Upstream commit cdb555397f438592bab00599037c347b700cf397 ]

This has been found by the Kernel Test Robot:
http://lkml.iu.edu/hypermail/linux/kernel/2006.0/06862.html

With CONFIG_AMIGA_PCMCIA=n, io_mm.h does not pull in amigahw.h and
ZTWO_VADDR is undefined. Add forgotten include to i2c-icy.c

Fixes: 4768e90ecaec ("i2c: Add i2c-icy for I2C on m68k/Amiga")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Max Staudt <max@enpas.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-icy.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i2c/busses/i2c-icy.c b/drivers/i2c/busses/i2c-icy.c
index 271470f4d8a9..66c9923fc766 100644
--- a/drivers/i2c/busses/i2c-icy.c
+++ b/drivers/i2c/busses/i2c-icy.c
@@ -43,6 +43,7 @@
 #include <linux/i2c.h>
 #include <linux/i2c-algo-pcf.h>
 
+#include <asm/amigahw.h>
 #include <asm/amigaints.h>
 #include <linux/zorro.h>
 
-- 
2.25.1

