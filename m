Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52F45960D6
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 15:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730004AbfHTNnc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 09:43:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:39308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730871AbfHTNnb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 09:43:31 -0400
Received: from sasha-vm.mshome.net (unknown [12.236.144.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E8DE22DA7;
        Tue, 20 Aug 2019 13:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566308610;
        bh=XUoIc2KHqVMThX9S+sl+WxBiHhZcXkyJqYSy2y8+sYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nR6yUhKShAS8LAe5KMiXk8OpMq4oonNEctw1JxixqkcT/J0XrbtfuuYLtpAktCYCl
         JTN0GgMSA41Spah62eU3nYM0AtmO/O+jtZbhCLMGLekrkNNSlFgD5Iivve6ETpQZju
         lLFWxL4CeYBDh9XwG9KEDDKwpERbRAVEaC46Sa2I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 3/4] usb: host: fotg2: restart hcd after port reset
Date:   Tue, 20 Aug 2019 09:43:24 -0400
Message-Id: <20190820134325.11825-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190820134325.11825-1-sashal@kernel.org>
References: <20190820134325.11825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Ulli Kroll <ulli.kroll@googlemail.com>

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
index 2341af4f34909..11b3a8c57eabc 100644
--- a/drivers/usb/host/fotg210-hcd.c
+++ b/drivers/usb/host/fotg210-hcd.c
@@ -1653,6 +1653,10 @@ static int fotg210_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
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

