Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0A98101698
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:55:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731599AbfKSFyt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:54:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:53008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732200AbfKSFys (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:54:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0F522084D;
        Tue, 19 Nov 2019 05:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142888;
        bh=TPrIXpFHMn6cXPFaNNnmHnpk5EEQhbToYpDBo9dmzzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HnBjvOkoVrFAoPBfb4qr+cw4z0CaI0vW92KqzJ+t2MS2E69PvixVWap+WVCCmVLk5
         flas43WS96qj9KRLAaugxar+9HNfICBLw5cvs6jjpJTsvxgYVKRqr+B5+3Iz4Szfu5
         buPimi95ehAbB8moSrm4F1Ih9WT/L5bPGUYFmsH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 235/239] usb: xhci-mtk: fix ISOC error when interval is zero
Date:   Tue, 19 Nov 2019 06:20:35 +0100
Message-Id: <20191119051342.579810327@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunfeng Yun <chunfeng.yun@mediatek.com>

[ Upstream commit 87173acc0d8f0987bda8827da35fff67f52ad15d ]

If the interval equal zero, needn't round up to power of two
for the number of packets in each ESIT, so fix it.

Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-mtk-sch.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-mtk-sch.c b/drivers/usb/host/xhci-mtk-sch.c
index 6e7ddf6cafae1..defaf950e6314 100644
--- a/drivers/usb/host/xhci-mtk-sch.c
+++ b/drivers/usb/host/xhci-mtk-sch.c
@@ -122,7 +122,9 @@ static void setup_sch_info(struct usb_device *udev,
 		}
 
 		if (ep_type == ISOC_IN_EP || ep_type == ISOC_OUT_EP) {
-			if (esit_pkts <= sch_ep->esit)
+			if (sch_ep->esit == 1)
+				sch_ep->pkts = esit_pkts;
+			else if (esit_pkts <= sch_ep->esit)
 				sch_ep->pkts = 1;
 			else
 				sch_ep->pkts = roundup_pow_of_two(esit_pkts)
-- 
2.20.1



