Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C13723FDC8E
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344476AbhIAMvY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:51:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:54326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346414AbhIAMuM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:50:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D85E2611C5;
        Wed,  1 Sep 2021 12:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630500099;
        bh=pwuwk1VumsflOclvyV0Xrw7TvDv9wcZugJN3n83RWfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wut+8OCHLFaOoWG5WidF6+wvH7+AbPDznwzTE7pwTuLu6Zcd1ux1ldUbyd36KBLnp
         +Lh+fTYVyAiUXBwWmOMaJrWS2HL5rpz/vRk5s4gr0PymwIfc+ISAzxD+B5nDh7n1h2
         P0sPnOOt1fMfAzWWW/+Ohrdq3dALQt+Fh1lzzZ2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 069/113] usb: gadget: u_audio: fix race condition on endpoint stop
Date:   Wed,  1 Sep 2021 14:28:24 +0200
Message-Id: <20210901122304.292452499@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit 068fdad20454f815e61e6f6eb9f051a8b3120e88 ]

If the endpoint completion callback is call right after the ep_enabled flag
is cleared and before usb_ep_dequeue() is call, we could do a double free
on the request and the associated buffer.

Fix this by clearing ep_enabled after all the endpoint requests have been
dequeued.

Fixes: 7de8681be2cd ("usb: gadget: u_audio: Free requests only after callback")
Cc: stable <stable@vger.kernel.org>
Reported-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20210827092927.366482-1-jbrunet@baylibre.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/u_audio.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/function/u_audio.c b/drivers/usb/gadget/function/u_audio.c
index 5fbceee897a3..3b613ca06ae5 100644
--- a/drivers/usb/gadget/function/u_audio.c
+++ b/drivers/usb/gadget/function/u_audio.c
@@ -312,8 +312,6 @@ static inline void free_ep(struct uac_rtd_params *prm, struct usb_ep *ep)
 	if (!prm->ep_enabled)
 		return;
 
-	prm->ep_enabled = false;
-
 	audio_dev = uac->audio_dev;
 	params = &audio_dev->params;
 
@@ -331,11 +329,12 @@ static inline void free_ep(struct uac_rtd_params *prm, struct usb_ep *ep)
 		}
 	}
 
+	prm->ep_enabled = false;
+
 	if (usb_ep_disable(ep))
 		dev_err(uac->card->dev, "%s:%d Error!\n", __func__, __LINE__);
 }
 
-
 int u_audio_start_capture(struct g_audio *audio_dev)
 {
 	struct snd_uac_chip *uac = audio_dev->uac;
-- 
2.30.2



