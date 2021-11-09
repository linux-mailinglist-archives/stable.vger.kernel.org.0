Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D086C44B7B2
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344282AbhKIWgn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:36:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:56332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345392AbhKIWd6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:33:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2EB8861AEB;
        Tue,  9 Nov 2021 22:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496518;
        bh=wywaTOUg4rQhajJSmVTWOlOkW6JYAOE/z69eL1ZC92g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jvCVMR14eTv0gR8qE/a2+sCoI4urVg09Zuqgk1UmRm/6Q7eh00JTQHuQaX9xKLo7P
         MhQYlmG2vhp/4fkcvCAt/Uy2tjeyhx/WIhyWAQYso9Nnz9FG12hB2AdAglVkYyWot/
         ULLTk4gVL4PPt1vuZjIXZcySbfDTg03DE3L/KTC6Tu9eOimZmgOM2EAaD/UxAjPwaB
         iXUMDhf2UMz5890vtYfbTBtbNPynOkpmmEsey+fPDy7/rLCVY3uRkOLWUzizSmj6yQ
         dPJ6H2NLgMD+XZI8L72h+S+2J93/Dtmxo9nQf7DELNLruRm1rlGOCfK1+6YyRFC8RE
         vAmikuQlOFIvw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 34/50] usb: host: ohci-tmio: check return value after calling platform_get_resource()
Date:   Tue,  9 Nov 2021 17:20:47 -0500
Message-Id: <20211109222103.1234885-34-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109222103.1234885-1-sashal@kernel.org>
References: <20211109222103.1234885-1-sashal@kernel.org>
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
index 08ec2ab0d95a5..3f3d62dc06746 100644
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

