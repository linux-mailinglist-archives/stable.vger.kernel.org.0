Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E23562E648A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633122AbgL1PwL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:52:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:40444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403853AbgL1NkM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:40:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68C28205CB;
        Mon, 28 Dec 2020 13:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162772;
        bh=k9eOuaPTiFozOgNF9rx9KZ06evrYinSvgIJmaQqBn34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UGTZLPsIlJWLZG58xDQSYgYfRdll1A9d/RHxCEh6cCyKecknS+4QfELRpT2LJl1U6
         p6aLmY3znWlOXC/8aKsXxSQEVS1YRV7RokfC9Y9njjDd2TMxDQN5fBbhigb9y2aqYG
         4SuyLPnGvD1mIgTJ81ezdeXKrOreCfj+VU8zGO/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        EJ Hsu <ejh@nvidia.com>, Peter Chen <peter.chen@nxp.com>,
        Will McVicker <willmcvicker@google.com>
Subject: [PATCH 5.4 056/453] USB: gadget: f_rndis: fix bitrate for SuperSpeed and above
Date:   Mon, 28 Dec 2020 13:44:52 +0100
Message-Id: <20201228124939.944846922@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will McVicker <willmcvicker@google.com>

commit b00f444f9add39b64d1943fa75538a1ebd54a290 upstream.

Align the SuperSpeed Plus bitrate for f_rndis to match f_ncm's ncm_bitrate
defined by commit 1650113888fe ("usb: gadget: f_ncm: add SuperSpeed descriptors
for CDC NCM").

Cc: Felipe Balbi <balbi@kernel.org>
Cc: EJ Hsu <ejh@nvidia.com>
Cc: Peter Chen <peter.chen@nxp.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Will McVicker <willmcvicker@google.com>
Reviewed-by: Peter Chen <peter.chen@nxp.com>
Link: https://lore.kernel.org/r/20201127140559.381351-2-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/function/f_rndis.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/f_rndis.c
+++ b/drivers/usb/gadget/function/f_rndis.c
@@ -87,8 +87,10 @@ static inline struct f_rndis *func_to_rn
 /* peak (theoretical) bulk transfer rate in bits-per-second */
 static unsigned int bitrate(struct usb_gadget *g)
 {
+	if (gadget_is_superspeed(g) && g->speed >= USB_SPEED_SUPER_PLUS)
+		return 4250000000U;
 	if (gadget_is_superspeed(g) && g->speed == USB_SPEED_SUPER)
-		return 13 * 1024 * 8 * 1000 * 8;
+		return 3750000000U;
 	else if (gadget_is_dualspeed(g) && g->speed == USB_SPEED_HIGH)
 		return 13 * 512 * 8 * 1000 * 8;
 	else


