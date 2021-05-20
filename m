Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7E9638A940
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237773AbhETLAc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:00:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:56958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239054AbhETK5x (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:57:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2AFA861CF9;
        Thu, 20 May 2021 10:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504934;
        bh=2fKbQnLZ9rcMKB/YD89KcbhKbvDanPeCFXWm9bkjNxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r865FLRKgeWo6g73tYsBTj+VJzKh6fVxoLSDE7RP3eSShYFqee8+DCibKtHl0W6L5
         sUEeTiJUS0ES94KpUro1hQ/KdjvctfEyDBik2KJbqakCc1Z0bKFYfqR11rOuJu1iL9
         BBwwMwWaoSFyTBAq9VBrshQkYM7BR1eJ/tr19WbQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 114/240] usb: gadget: r8a66597: Add missing null check on return from platform_get_resource
Date:   Thu, 20 May 2021 11:21:46 +0200
Message-Id: <20210520092112.501680277@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
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
index 230e3248f386..80503c3604ca 100644
--- a/drivers/usb/gadget/udc/r8a66597-udc.c
+++ b/drivers/usb/gadget/udc/r8a66597-udc.c
@@ -1855,6 +1855,8 @@ static int r8a66597_probe(struct platform_device *pdev)
 		return PTR_ERR(reg);
 
 	ires = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!ires)
+		return -EINVAL;
 	irq = ires->start;
 	irq_trigger = ires->flags & IRQF_TRIGGER_MASK;
 
-- 
2.30.2



