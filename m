Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBD43CA932
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbhGOTFp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:05:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:39500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243669AbhGOTEi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:04:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19153613D1;
        Thu, 15 Jul 2021 19:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375626;
        bh=OTxsgqVgi1Gufn4LEmptwvp+ZGtUdUp4cG7hu4xj9Pk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iyC1IaDpTQ8lfBuFm3VzH7hdunMo+1/E8nTZ3QikW6UYTbFsFDjH8ydkbsGUW8RRt
         Ccj+dQ5Sl8yWMZ2t7kf4urKr+uzdelrCW2uSY1MhYaYfaLfZtsVW/04Xsta5B3Fjlj
         9OOxoNHtMmEoE49op4rRpSZ3Bj/hqc+RvC9YEs7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>,
        Maxime Ripard <maxime@cerno.tech>
Subject: [PATCH 5.12 168/242] drm/vc4: txp: Properly set the possible_crtcs mask
Date:   Thu, 15 Jul 2021 20:38:50 +0200
Message-Id: <20210715182622.835172841@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

commit bf6de8e61509f3c957d7f75f017b18d40a18a950 upstream.

The current code does a binary OR on the possible_crtcs variable of the
TXP encoder, while we want to set it to that value instead.

Cc: <stable@vger.kernel.org> # v5.9+
Fixes: 39fcb2808376 ("drm/vc4: txp: Turn the TXP into a CRTC of its own")
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20210507150515.257424-2-maxime@cerno.tech
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/vc4/vc4_txp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/vc4/vc4_txp.c
+++ b/drivers/gpu/drm/vc4/vc4_txp.c
@@ -507,7 +507,7 @@ static int vc4_txp_bind(struct device *d
 		return ret;
 
 	encoder = &txp->connector.encoder;
-	encoder->possible_crtcs |= drm_crtc_mask(crtc);
+	encoder->possible_crtcs = drm_crtc_mask(crtc);
 
 	ret = devm_request_irq(dev, irq, vc4_txp_interrupt, 0,
 			       dev_name(dev), txp);


