Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0747304B77
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 22:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727369AbhAZEp0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:45:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:59514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727858AbhAYSnM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:43:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DAD62074B;
        Mon, 25 Jan 2021 18:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600117;
        bh=5qBzbaZXjTiDq+6bsXtOagtpeT15Qc472HhJY2nqsvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IPdWdBHo1TS89gES6O96m9lC35Q8/cM1q8wyTsf7ODYkxxDp8kI9VNrOPspYuK+Ui
         tRvEnebP7Zw7h377qafNU3KQcdP7vbRG6/MHF7r4XP9RvpTf0YxjjpgMx/g9d/zRhQ
         Lcg2QhXxan1ljFSy/NC+KwC4mBDakL4pdiiPqXSg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        Joel Stanley <joel@jms.id.au>,
        Ryan Chen <ryan_chen@aspeedtech.com>
Subject: [PATCH 4.19 38/58] usb: gadget: aspeed: fix stop dma register setting.
Date:   Mon, 25 Jan 2021 19:39:39 +0100
Message-Id: <20210125183158.353592123@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183156.702907356@linuxfoundation.org>
References: <20210125183156.702907356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ryan Chen <ryan_chen@aspeedtech.com>

commit 4e0dcf62ab4cf917d0cbe751b8bf229a065248d4 upstream.

The vhub engine has two dma mode, one is descriptor list, another
is single stage DMA. Each mode has different stop register setting.
Descriptor list operation (bit2) : 0 disable reset, 1: enable reset
Single mode operation (bit0) : 0 : disable, 1: enable

Fixes: 7ecca2a4080c ("usb/gadget: Add driver for Aspeed SoC virtual hub")
Cc: stable <stable@vger.kernel.org>
Acked-by: Felipe Balbi <balbi@kernel.org>
Acked-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Ryan Chen <ryan_chen@aspeedtech.com>
Link: https://lore.kernel.org/r/20210108081238.10199-2-ryan_chen@aspeedtech.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/udc/aspeed-vhub/epn.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/udc/aspeed-vhub/epn.c
+++ b/drivers/usb/gadget/udc/aspeed-vhub/epn.c
@@ -420,7 +420,10 @@ static void ast_vhub_stop_active_req(str
 	u32 state, reg, loops;
 
 	/* Stop DMA activity */
-	writel(0, ep->epn.regs + AST_VHUB_EP_DMA_CTLSTAT);
+	if (ep->epn.desc_mode)
+		writel(VHUB_EP_DMA_CTRL_RESET, ep->epn.regs + AST_VHUB_EP_DMA_CTLSTAT);
+	else
+		writel(0, ep->epn.regs + AST_VHUB_EP_DMA_CTLSTAT);
 
 	/* Wait for it to complete */
 	for (loops = 0; loops < 1000; loops++) {


