Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B83337C8BE
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236711AbhELQM0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:12:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:34890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239027AbhELQHF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:07:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03ED961D0E;
        Wed, 12 May 2021 15:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833749;
        bh=nTIRnDruiozt48EnkzzPMjoni5i2+tipW2+sdS0xD38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qbnZaFdy+KpAmLosmJIrajaOcjm1o2JmqvYvoQXVIgYcrnwi9FhZzGu8JGQ9cGk3W
         Z4S6Y4GTHiiyElvBsOZXGG2eAY0DkpCygJH6rhDm9N7OSjErSMn0uO9xGeYmJ4unqQ
         e1lXMWk+kFH2KTs6t5KapGw5KhYp+pLIrpRNqrDg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 273/601] usb: gadget: r8a66597: Add missing null check on return from platform_get_resource
Date:   Wed, 12 May 2021 16:45:50 +0200
Message-Id: <20210512144836.806626755@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
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
index 896c1a016d55..65cae4883454 100644
--- a/drivers/usb/gadget/udc/r8a66597-udc.c
+++ b/drivers/usb/gadget/udc/r8a66597-udc.c
@@ -1849,6 +1849,8 @@ static int r8a66597_probe(struct platform_device *pdev)
 		return PTR_ERR(reg);
 
 	ires = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!ires)
+		return -EINVAL;
 	irq = ires->start;
 	irq_trigger = ires->flags & IRQF_TRIGGER_MASK;
 
-- 
2.30.2



