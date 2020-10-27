Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E25629B465
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1783324AbgJ0PBf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:01:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:35508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1788993AbgJ0PBe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:01:34 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82F0F22264;
        Tue, 27 Oct 2020 15:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810894;
        bh=jtGQ8oWjGlnOaSQogygLYVgLNL9hKq+39NrN7rVjIgw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fUH6Q5qy/McLZgt6ujQL/6Kzh6DtJAPNHW2XCgpAuwOz3BmozOPynI2OuE+eAkldH
         /zfx3ictwzHp8yH7l7LT3RlFdmY+SpLlJkeLQxEGIL1xhPWXPwmiJHNvVbGTFWLoAC
         9SUW4Scj5d9U+mDRLNLlsONNw1wIkTWr13WJFOP8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 300/633] bus: mhi: core: Fix the building of MHI module
Date:   Tue, 27 Oct 2020 14:50:43 +0100
Message-Id: <20201027135536.735683643@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit 5fc4997fd9d065c98fb312ef56ffadffccc6d61d ]

The Kbuild rule to build MHI should use the append operator. This fixes
the below warning reported by Kbuild test bot.

WARNING: modpost: missing MODULE_LICENSE() in
drivers/bus/mhi/core/main.o
WARNING: modpost: missing MODULE_LICENSE() in drivers/bus/mhi/core/pm.o
WARNING: modpost: missing MODULE_LICENSE() in
drivers/bus/mhi/core/boot.o

Fixes: 0cbf260820fa ("bus: mhi: core: Add support for registering MHI controllers")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20200929175218.8178-19-manivannan.sadhasivam@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/mhi/core/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bus/mhi/core/Makefile b/drivers/bus/mhi/core/Makefile
index 66e2700c9032a..bc1469778cf87 100644
--- a/drivers/bus/mhi/core/Makefile
+++ b/drivers/bus/mhi/core/Makefile
@@ -1,3 +1,3 @@
-obj-$(CONFIG_MHI_BUS) := mhi.o
+obj-$(CONFIG_MHI_BUS) += mhi.o
 
 mhi-y := init.o main.o pm.o boot.o
-- 
2.25.1



