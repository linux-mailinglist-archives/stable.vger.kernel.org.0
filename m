Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 052A8411BB2
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345168AbhITRBk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:01:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:51846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344785AbhITQ7i (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:59:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E4A3613CE;
        Mon, 20 Sep 2021 16:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156750;
        bh=c25asRwqYAQOjVBY8o5GjpFWgQbiQ0BNFR+/EROjpyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=joyTO/KV/rd5fEw6jiMfiIVepIP9kpI+0hbzMk8EYxbmuAB2IcGdjlkKyiDo15RwS
         n8rU2gN5iPtoAdU8goMK230f4E2hQ76ubbMtUdf0SHLEPTR+cwTsneg4LIT4kdE6z2
         yiJS2VpRoSsOU/a3UzlOH0EzcCTC8g4+dkEbyH68=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 067/175] usb: phy: twl6030: add IRQ checks
Date:   Mon, 20 Sep 2021 18:41:56 +0200
Message-Id: <20210920163920.252015975@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163918.068823680@linuxfoundation.org>
References: <20210920163918.068823680@linuxfoundation.org>
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
index cf0b67433ac9..ccb36e240953 100644
--- a/drivers/usb/phy/phy-twl6030-usb.c
+++ b/drivers/usb/phy/phy-twl6030-usb.c
@@ -352,6 +352,11 @@ static int twl6030_usb_probe(struct platform_device *pdev)
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



