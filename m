Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BED3A8FC7
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388958AbfIDSFr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:05:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:47408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389315AbfIDSFq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:05:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAAD9206B8;
        Wed,  4 Sep 2019 18:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620345;
        bh=KjgzAgObt+LH3gTEUmL2iFES4O6uq6NbqBIm2PA4h/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YAAd1h1nKpJ1RyCBNtpSXwMnX5yAJO/pUvzhGsESebnqosorzLwuJV5lEVibroHI5
         /h5YURmNYrcMXBJXj8vga73wUMFmLEtF1GYxcVlziuMrpb15dgxJh16CqY/flvDxfn
         VDPUcPG7fIJ6dpcdQ2lx3BeGpv3Z9zBrgJOsLP00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 23/93] usb: host: fotg2: restart hcd after port reset
Date:   Wed,  4 Sep 2019 19:53:25 +0200
Message-Id: <20190904175305.292139421@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175302.845828956@linuxfoundation.org>
References: <20190904175302.845828956@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 777758888ffe59ef754cc39ab2f275dc277732f4 ]

On the Gemini SoC the FOTG2 stalls after port reset
so restart the HCD after each port reset.

Signed-off-by: Hans Ulli Kroll <ulli.kroll@googlemail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20190810150458.817-1-linus.walleij@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/fotg210-hcd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/host/fotg210-hcd.c b/drivers/usb/host/fotg210-hcd.c
index e64eb47770c8b..2d5a72c15069e 100644
--- a/drivers/usb/host/fotg210-hcd.c
+++ b/drivers/usb/host/fotg210-hcd.c
@@ -1627,6 +1627,10 @@ static int fotg210_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 			/* see what we found out */
 			temp = check_reset_complete(fotg210, wIndex, status_reg,
 					fotg210_readl(fotg210, status_reg));
+
+			/* restart schedule */
+			fotg210->command |= CMD_RUN;
+			fotg210_writel(fotg210, fotg210->command, &fotg210->regs->command);
 		}
 
 		if (!(temp & (PORT_RESUME|PORT_RESET))) {
-- 
2.20.1



