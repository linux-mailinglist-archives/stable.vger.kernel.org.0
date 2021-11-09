Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7C9A44B8B8
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345613AbhKIWps (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:45:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:36040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346135AbhKIWnp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:43:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F28F61A40;
        Tue,  9 Nov 2021 22:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496674;
        bh=9L5S1wNQqgRAGnTg268+P/TH/VccBWxuhv9lCpuuxG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TLVmEPJtQd7iVmRO46/j4y8RvGbh5B//LlOUSsmgP12odBFjOUk7kN5tDYW3c8QGE
         1Rltp6EzOWZIweSfbeZd+3JwsFg/23r/LqQJORpOpX6ll+3OEZDTJzaC/XBNGuJOer
         Bim/yo2uBdTF+oYLpGv0Q7vSsfbcg2i8mANaWIglNxNVsP/2ceDk7EDt2p2jjQTaIB
         ywV5k17u8mdcbPnes2gSTu6dMwZkbhois4RSaGajooO0V0BEBoiZ/cpOphv8hh6uDJ
         Ics3CzXls5/35Krmr+JJJXEZx0DRs8ptPYUQ9Gz++Xv+OPhZr8BAcaZk7mFZN92cmI
         FMrriiXSQDbnA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 05/12] usb: host: ohci-tmio: check return value after calling platform_get_resource()
Date:   Tue,  9 Nov 2021 17:24:19 -0500
Message-Id: <20211109222426.1236575-5-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109222426.1236575-1-sashal@kernel.org>
References: <20211109222426.1236575-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 9eff2b2e59fda25051ab36cd1cb5014661df657b ]

It will cause null-ptr-deref if platform_get_resource() returns NULL,
we need check the return value.

Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20211011134920.118477-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/ohci-tmio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/ohci-tmio.c b/drivers/usb/host/ohci-tmio.c
index 9c9e97294c18d..4d42ae3b2fd6d 100644
--- a/drivers/usb/host/ohci-tmio.c
+++ b/drivers/usb/host/ohci-tmio.c
@@ -199,7 +199,7 @@ static int ohci_hcd_tmio_drv_probe(struct platform_device *dev)
 	if (usb_disabled())
 		return -ENODEV;
 
-	if (!cell)
+	if (!cell || !regs || !config || !sram)
 		return -EINVAL;
 
 	if (irq < 0)
-- 
2.33.0

