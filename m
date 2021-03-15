Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39C2033B564
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbhCONyS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:54:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:57050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230499AbhCONxr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:53:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 983C264EF4;
        Mon, 15 Mar 2021 13:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816427;
        bh=eIQ1Dx6r4nTfUikTFLl1a1FCC6RAXUFnnPDny7KbnQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hWmAkpvu02SvZf8K1XBHu6NYMKhcr0AhorKZ/epMRhIAU7lz5upPR6c81Pp/fynqm
         dS/K4RCPjJysfa1i1Ra/A+fvf5T9MVI+EMqAMcgLuk5M9h1VELl6OzXJG/Y4dkGbuB
         3/aP86sx6D0aB2U1Sw2O/hYKKhcWYFibfcTc6ONE=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chen <peter.chen@freescale.com>,
        Ruslan Bilovol <ruslan.bilovol@gmail.com>
Subject: [PATCH 4.9 32/78] usb: gadget: f_uac2: always increase endpoint max_packet_size by one audio slot
Date:   Mon, 15 Mar 2021 14:51:55 +0100
Message-Id: <20210315135213.123273333@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135212.060847074@linuxfoundation.org>
References: <20210315135212.060847074@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Ruslan Bilovol <ruslan.bilovol@gmail.com>

commit 789ea77310f0200c84002884ffd628e2baf3ad8a upstream.

As per UAC2 Audio Data Formats spec (2.3.1.1 USB Packets),
if the sampling rate is a constant, the allowable variation
of number of audio slots per virtual frame is +/- 1 audio slot.

It means that endpoint should be able to accept/send +1 audio
slot.

Previous endpoint max_packet_size calculation code
was adding sometimes +1 audio slot due to DIV_ROUND_UP
behaviour which was rounding up to closest integer.
However this doesn't work if the numbers are divisible.

It had no any impact with Linux hosts which ignore
this issue, but in case of more strict Windows it
caused rejected enumeration

Thus always add +1 audio slot to endpoint's max packet size

Fixes: 913e4a90b6f9 ("usb: gadget: f_uac2: finalize wMaxPacketSize according to bandwidth")
Cc: Peter Chen <peter.chen@freescale.com>
Cc: <stable@vger.kernel.org> #v4.3+
Signed-off-by: Ruslan Bilovol <ruslan.bilovol@gmail.com>
Link: https://lore.kernel.org/r/1614599375-8803-2-git-send-email-ruslan.bilovol@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_uac2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/f_uac2.c
+++ b/drivers/usb/gadget/function/f_uac2.c
@@ -997,7 +997,7 @@ static int set_ep_max_packet_size(const
 	}
 
 	max_size_bw = num_channels(chmask) * ssize *
-		DIV_ROUND_UP(srate, factor / (1 << (ep_desc->bInterval - 1)));
+		((srate / (factor / (1 << (ep_desc->bInterval - 1)))) + 1);
 	ep_desc->wMaxPacketSize = cpu_to_le16(min_t(u16, max_size_bw,
 						    max_size_ep));
 


