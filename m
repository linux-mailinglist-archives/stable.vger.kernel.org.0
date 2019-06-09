Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADCB63A8EC
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388447AbfFIRFo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:05:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:45086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388881AbfFIRFo (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:05:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FAC820840;
        Sun,  9 Jun 2019 17:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099943;
        bh=ZE0NAmr0n9AzbL8uNX7qO2fpOL804Ofd56fCOpy3g58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j8nylH5ng/uhPPlh4Yq1I1/4kQaHp4/YFtMsu34J0GNggu/8FhlMDhGVCKgbmA68Q
         6U1/wOPZcGgtLbnljBJHBELAku631llSNIBYrjzedS2i0UUsSheT67/IzGJm/6TbI1
         CANTSxjy7CTAm8bCOJY1FYB9EpD/M6si5YnBagLY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gavin Li <git@thegavinli.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.4 221/241] brcmfmac: fix incorrect event channel deduction
Date:   Sun,  9 Jun 2019 18:42:43 +0200
Message-Id: <20190609164155.064480735@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gavin Li <git@thegavinli.com>

commit 8e290cecdd0178f3d4cf7d463c51dc7e462843b4 upstream.

brcmf_sdio_fromevntchan() was being called on the the data frame
rather than the software header, causing some frames to be
mischaracterized as on the event channel rather than the data channel.

This fixes a major performance regression (due to dropped packets). With
this patch the download speed jumped from 1Mbit/s back up to 40MBit/s due
to the sheer amount of packets being incorrectly processed.

Fixes: c56caa9db8ab ("brcmfmac: screening firmware event packet")
Signed-off-by: Gavin Li <git@thegavinli.com>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
[kvalo@codeaurora.org: improve commit logs based on email discussion]
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
[bwh: Backported to 4.4: adjust filename]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/brcm80211/brcmfmac/sdio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
@@ -1765,7 +1765,7 @@ static u8 brcmf_sdio_rxglom(struct brcmf
 					   pfirst->len, pfirst->next,
 					   pfirst->prev);
 			skb_unlink(pfirst, &bus->glom);
-			if (brcmf_sdio_fromevntchan(pfirst->data))
+			if (brcmf_sdio_fromevntchan(&dptr[SDPCM_HWHDR_LEN]))
 				brcmf_rx_event(bus->sdiodev->dev, pfirst);
 			else
 				brcmf_rx_frame(bus->sdiodev->dev, pfirst,


