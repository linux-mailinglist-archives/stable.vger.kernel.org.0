Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB04C37C173
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 16:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232169AbhELPAU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:00:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:46434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231373AbhELO61 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 10:58:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50A6F61438;
        Wed, 12 May 2021 14:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831366;
        bh=gDHr0Bow97m9Fu/6THO3/RCY4+8E9v28DICv6HS0IXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q3o3mrywcQfrUtyC9faY1S9weP6j066y/0UgcJnieQ8OSkCy0rjLF0Wki7vfMMHvd
         4bUDtYFSoBCxmG5VKbKdzEkxBrhhZjOkZFHFx5QXY6KCUr/ZRVV8qUY4zG/gcLC+5/
         M1eI1vHy3Hd4ybZBch6Tg2ksLoXgWbR8OHrY4h7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabian Vogt <fabian@ritter-vogt.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 092/244] fotg210-udc: Mask GRP2 interrupts we dont handle
Date:   Wed, 12 May 2021 16:47:43 +0200
Message-Id: <20210512144745.963423883@linuxfoundation.org>
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

From: Fabian Vogt <fabian@ritter-vogt.de>

[ Upstream commit 9aee3a23d6455200702f3a57e731fa11e8408667 ]

Currently it leaves unhandled interrupts unmasked, but those are never
acked. In the case of a "device idle" interrupt, this leads to an
effectively frozen system until plugging it in.

Fixes: b84a8dee23fd ("usb: gadget: add Faraday fotg210_udc driver")
Signed-off-by: Fabian Vogt <fabian@ritter-vogt.de>
Link: https://lore.kernel.org/r/20210324141115.9384-5-fabian@ritter-vogt.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/fotg210-udc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/gadget/udc/fotg210-udc.c b/drivers/usb/gadget/udc/fotg210-udc.c
index b2c75c8ca3d7..c287dc7d430f 100644
--- a/drivers/usb/gadget/udc/fotg210-udc.c
+++ b/drivers/usb/gadget/udc/fotg210-udc.c
@@ -1026,6 +1026,12 @@ static void fotg210_init(struct fotg210_udc *fotg210)
 	value &= ~DMCR_GLINT_EN;
 	iowrite32(value, fotg210->reg + FOTG210_DMCR);
 
+	/* enable only grp2 irqs we handle */
+	iowrite32(~(DISGR2_DMA_ERROR | DISGR2_RX0BYTE_INT | DISGR2_TX0BYTE_INT
+		    | DISGR2_ISO_SEQ_ABORT_INT | DISGR2_ISO_SEQ_ERR_INT
+		    | DISGR2_RESM_INT | DISGR2_SUSP_INT | DISGR2_USBRST_INT),
+		  fotg210->reg + FOTG210_DMISGR2);
+
 	/* disable all fifo interrupt */
 	iowrite32(~(u32)0, fotg210->reg + FOTG210_DMISGR1);
 
-- 
2.30.2



