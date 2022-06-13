Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0211549480
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359425AbiFMNNW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:13:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376330AbiFMNKv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:10:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCA4A666B7;
        Mon, 13 Jun 2022 04:21:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63A99B80E59;
        Mon, 13 Jun 2022 11:21:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C34E2C34114;
        Mon, 13 Jun 2022 11:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119306;
        bh=7RUlMWfljiidExMpp+ECfZuNrzYH/eWjg+U8SwDpDkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0vXT/tUBZto5483+GdJj1fD6GRe5+0N40+dzVPa8ZRAM4hq2YEpDhEO7wQZ8/wcIQ
         rI6aPQ+JGQtqvkxQ/qwOalbpdBTAotfwhGHMBl7yguEsIdVDmBS5tia7TCQacWYQ4n
         eC7MxqyXwvflCdTXUiZuuvk9W9Hj88m0jjmh2b/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        =?UTF-8?q?Andr=C3=A9=20Kapelrud?= <a.kapelrud@gmail.com>
Subject: [PATCH 5.15 214/247] ALSA: usb-audio: Skip generic sync EP parse for secondary EP
Date:   Mon, 13 Jun 2022 12:11:56 +0200
Message-Id: <20220613094929.429570327@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094922.843438024@linuxfoundation.org>
References: <20220613094922.843438024@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit efb75df105e82f076a85b9f2d81410428bcb55fc upstream.

When ep_idx is already non-zero, it means usually a capture stream
that is set up explicity by a fixed-format quirk, and applying the
check for generic (non-implicit-fb) sync EPs might hit incorrectly,
resulting in a bogus sync endpoint for the capture stream.

This patch adds a check for the ep_idx and skip if it's a secondary
endpoint.  It's a part of the fixes for regressions on Saffire 6.

Fixes: 7b0efea4baf0 ("ALSA: usb-audio: Add missing ep_idx in fixed EP quirks")
Reported-and-tested-by: André Kapelrud <a.kapelrud@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220606160910.6926-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/pcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index b470404a5376..b0369df53910 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -304,7 +304,7 @@ int snd_usb_audioformat_set_sync_ep(struct snd_usb_audio *chip,
 	 * Generic sync EP handling
 	 */
 
-	if (altsd->bNumEndpoints < 2)
+	if (fmt->ep_idx > 0 || altsd->bNumEndpoints < 2)
 		return 0;
 
 	is_playback = !(get_endpoint(alts, 0)->bEndpointAddress & USB_DIR_IN);
-- 
2.36.1



