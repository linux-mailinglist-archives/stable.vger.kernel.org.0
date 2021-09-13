Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 999D0409234
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244417AbhIMOJL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:09:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:55996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343979AbhIMOHJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:07:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42EAF61A82;
        Mon, 13 Sep 2021 13:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540418;
        bh=HVmiHrBeFNiqaH8sduhcxvABJ2yP4wydtgEcHmO945o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VIBBizvgW207SSLmHygibgyxxMlsKwptqZO6jhnAoIRIIWtbd/qrGFTZmwJOqdGpc
         PgtM7vqULB1cE46Qefo9LODcuWiusYFclu3xKhmoZBQ07HFjjSadhkOPpjimLQAx5w
         v0YSgcsBjdEUBUs7nbE5GvSSMx+pBNk5UNRrcE/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 185/300] usb: phy: twl6030: add IRQ checks
Date:   Mon, 13 Sep 2021 15:14:06 +0200
Message-Id: <20210913131115.641811586@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Shtylyov <s.shtylyov@omp.ru>

[ Upstream commit 0881e22c06e66af0b64773c91c8868ead3d01aa1 ]

The driver neglects to check the result of platform_get_irq()'s calls and
blithely passes the negative error codes to request_threaded_irq() (which
takes *unsigned* IRQ #), causing them both to fail with -EINVAL, overriding
an original error code.  Stop calling request_threaded_irq() with the
invalid IRQ #s.

Fixes: c33fad0c3748 ("usb: otg: Adding twl6030-usb transceiver driver for OMAP4430")
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Link: https://lore.kernel.org/r/9507f50b-50f1-6dc4-f57c-3ed4e53a1c25@omp.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/phy/phy-twl6030-usb.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/phy/phy-twl6030-usb.c b/drivers/usb/phy/phy-twl6030-usb.c
index 8ba6c5a91557..ab3c38a7d8ac 100644
--- a/drivers/usb/phy/phy-twl6030-usb.c
+++ b/drivers/usb/phy/phy-twl6030-usb.c
@@ -348,6 +348,11 @@ static int twl6030_usb_probe(struct platform_device *pdev)
 	twl->irq2		= platform_get_irq(pdev, 1);
 	twl->linkstat		= MUSB_UNKNOWN;
 
+	if (twl->irq1 < 0)
+		return twl->irq1;
+	if (twl->irq2 < 0)
+		return twl->irq2;
+
 	twl->comparator.set_vbus	= twl6030_set_vbus;
 	twl->comparator.start_srp	= twl6030_start_srp;
 
-- 
2.30.2



