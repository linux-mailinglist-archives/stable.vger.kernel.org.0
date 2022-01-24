Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 541F9497E01
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 12:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237567AbiAXLbB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 06:31:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237517AbiAXLbA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 06:31:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15CB5C06173B
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 03:31:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D08CEB80CD1
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 11:30:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDE6EC340E1;
        Mon, 24 Jan 2022 11:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643023857;
        bh=JYA+XQRW9R37r/C20mYdGi+BRwrjAFOm1mpVGoCLC28=;
        h=Subject:To:Cc:From:Date:From;
        b=nwpnqqInOtj8ZHRZKa23zoYQoBQgIqdEx1vFuCjhlRiMCMt/RzSiQAV1y/uN1KeTc
         wChh8qx0QVmBtTfU6/m7xIrBitxTrxXLnLjrmeMEIL74G8+lJIKzUqHzp2zGmam3h7
         SIsO3clxGxjhXhsc1y+kYo3ptU8AsLuqTF0hpv9A=
Subject: FAILED: patch "[PATCH] drm/vc4: hdmi: Fix HPD GPIO detection" failed to apply to 5.15-stable tree
To:     maxime@cerno.tech, dave.stevenson@raspberrypi.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 Jan 2022 12:30:54 +0100
Message-ID: <1643023854125129@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e32e5723256a99c5324824503572f743377dd0fe Mon Sep 17 00:00:00 2001
From: Maxime Ripard <maxime@cerno.tech>
Date: Mon, 25 Oct 2021 17:28:55 +0200
Subject: [PATCH] drm/vc4: hdmi: Fix HPD GPIO detection

Prior to commit 6800234ceee0 ("drm/vc4: hdmi: Convert to gpiod"), in the
detect hook, if we had an HPD GPIO we would only rely on it and return
whatever state it was in.

However, that commit changed that by mistake to only consider the case
where we have a GPIO and it returns a logical high, and would fall back
to the other methods otherwise.

Since we can read the EDIDs when the HPD signal is low on some displays,
we changed the detection status from disconnected to connected, and we
would ignore an HPD pulse.

Fixes: 6800234ceee0 ("drm/vc4: hdmi: Convert to gpiod")
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Link: https://lore.kernel.org/r/20211025152903.1088803-3-maxime@cerno.tech

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 6469645a7ad5..07a67bf6d3a8 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -170,9 +170,9 @@ vc4_hdmi_connector_detect(struct drm_connector *connector, bool force)
 
 	WARN_ON(pm_runtime_resume_and_get(&vc4_hdmi->pdev->dev));
 
-	if (vc4_hdmi->hpd_gpio &&
-	    gpiod_get_value_cansleep(vc4_hdmi->hpd_gpio)) {
-		connected = true;
+	if (vc4_hdmi->hpd_gpio) {
+		if (gpiod_get_value_cansleep(vc4_hdmi->hpd_gpio))
+			connected = true;
 	} else if (HDMI_READ(HDMI_HOTPLUG) & VC4_HDMI_HOTPLUG_CONNECTED) {
 		connected = true;
 	}

