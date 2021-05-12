Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F294C37C20B
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232615AbhELPGU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:06:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:56304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232299AbhELPDi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:03:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE31861927;
        Wed, 12 May 2021 14:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831535;
        bh=5oGwd9sVylZULCsNXIx2agLgt3eSZTfeNp4OHANUHQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O8w1YCszYwCIbyrlrGCaI+FDCe6Fvr1xn7jIdAcCSCoa0qwQs2LDKkmKIag/v2tI9
         /SuW5shEuFdUIERBV54P/83AJHPuGbtIlzAYMA0CLj5XTnjaYDTejg7AF4V6ByjTuW
         jqqVN0G/m0u7CCPFVytxzE6Uwn3LXZdu+5UsVo44=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 123/244] usb: gadget: r8a66597: Add missing null check on return from platform_get_resource
Date:   Wed, 12 May 2021 16:48:14 +0200
Message-Id: <20210512144746.955283320@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 9c2076090c2815fe7c49676df68dde7e60a9b9fc ]

The call to platform_get_resource can potentially return a NULL pointer
on failure, so add this check and return -EINVAL if it fails.

Fixes: c41442474a26 ("usb: gadget: R8A66597 peripheral controller support.")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Addresses-Coverity: ("Dereference null return")
Link: https://lore.kernel.org/r/20210406184510.433497-1-colin.king@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/r8a66597-udc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/gadget/udc/r8a66597-udc.c b/drivers/usb/gadget/udc/r8a66597-udc.c
index 11e25a3f4f1f..a766476fd742 100644
--- a/drivers/usb/gadget/udc/r8a66597-udc.c
+++ b/drivers/usb/gadget/udc/r8a66597-udc.c
@@ -1852,6 +1852,8 @@ static int r8a66597_probe(struct platform_device *pdev)
 		return PTR_ERR(reg);
 
 	ires = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!ires)
+		return -EINVAL;
 	irq = ires->start;
 	irq_trigger = ires->flags & IRQF_TRIGGER_MASK;
 
-- 
2.30.2



