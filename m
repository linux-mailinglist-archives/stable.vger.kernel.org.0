Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0624B1C452D
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731213AbgEDSBp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:01:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:57376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731203AbgEDSBm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:01:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DB90206B8;
        Mon,  4 May 2020 18:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615301;
        bh=PZfauH4491WPHaB4fDnCfLRZc8zUXeJQPOQuPy6eoM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g515IMJfq3NafDF1B1Fzbx3YOtdc3cg8kpEsIxfRyLW3mb0ktP/GdxzSsF/fAf1lo
         wx5HFsX4BLBhTtcMmp6LHyDX+Ibe3sn+vtA0vp+cvpPjDeGtWvbjJKLdB8BQi7ZyPG
         nYLPWILiwtwpHEtgqqwTPl5ko+LXHgdXRt9xb2pk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wu Bo <wubo40@huawei.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 08/37] ALSA: hda/hdmi: fix without unlocked before return
Date:   Mon,  4 May 2020 19:57:21 +0200
Message-Id: <20200504165449.583755570@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165448.264746645@linuxfoundation.org>
References: <20200504165448.264746645@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wu Bo <wubo40@huawei.com>

commit a2f647240998aa49632fb09b01388fdf2b87acfc upstream.

Fix the following coccicheck warning:
sound/pci/hda/patch_hdmi.c:1852:2-8: preceding lock on line 1846

After add sanity check to pass klockwork check,
The spdif_mutex should be unlock before return true
in check_non_pcm_per_cvt().

Fixes: 960a581e22d9 ("ALSA: hda: fix some klockwork scan warnings")
Signed-off-by: Wu Bo <wubo40@huawei.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1587907042-694161-1-git-send-email-wubo40@huawei.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_hdmi.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1848,8 +1848,10 @@ static bool check_non_pcm_per_cvt(struct
 	/* Add sanity check to pass klockwork check.
 	 * This should never happen.
 	 */
-	if (WARN_ON(spdif == NULL))
+	if (WARN_ON(spdif == NULL)) {
+		mutex_unlock(&codec->spdif_mutex);
 		return true;
+	}
 	non_pcm = !!(spdif->status & IEC958_AES0_NONAUDIO);
 	mutex_unlock(&codec->spdif_mutex);
 	return non_pcm;


