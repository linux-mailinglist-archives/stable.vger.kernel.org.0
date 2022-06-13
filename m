Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45EFC548A8F
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359014AbiFMNMR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376365AbiFMNK5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:10:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9221466ADA;
        Mon, 13 Jun 2022 04:21:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C8CA60F16;
        Mon, 13 Jun 2022 11:21:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94027C34114;
        Mon, 13 Jun 2022 11:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119309;
        bh=itQalIOuso+Bng4nmpzGu0Xrq8sW1YQxicUxo/mVZqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KLWkWlkSak2i2VzuO1k2X/BfWXj1V310FuW3A3hHeKQhvH+hk8YkbYKHMUvIHOhv4
         fFI0F10/ZJgRI4ObVhOav8pzqTmXNiKyB+Vp1badrCwg3ITXeD+C9Pxpj5+oAvUjDU
         qDEq5FAKhAX601IwYqXb/iFa3Uwk1TfyEIbnL9to=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        =?UTF-8?q?Andr=C3=A9=20Kapelrud?= <a.kapelrud@gmail.com>
Subject: [PATCH 5.15 215/247] ALSA: usb-audio: Set up (implicit) sync for Saffire 6
Date:   Mon, 13 Jun 2022 12:11:57 +0200
Message-Id: <20220613094929.460500591@linuxfoundation.org>
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

commit e0469d6581aecb0e34e2ec64f39f88e6985cc52f upstream.

Focusrite Saffire 6 has fixed audioformat quirks with multiple
endpoints assigned to a single altsetting.  Unfortunately the generic
parser couldn't detect the sync endpoint correctly as the implicit
sync due to the missing EP attribute bits.  In the former kernels, it
used to work somehow casually, but it's been broken for a while after
the large code change in 5.11.

This patch cures the regression by the following:
- Allow the static quirk table to provide the sync EP information;
  we just need to fill the fields and let the generic parser skipping
  parsing if sync_ep is already set.
- Add the sync endpoint information to the entry for Saffire 6.

Fixes: 7b0efea4baf0 ("ALSA: usb-audio: Add missing ep_idx in fixed EP quirks")
Reported-and-tested-by: André Kapelrud <a.kapelrud@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220606160910.6926-3-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/pcm.c          | 3 +++
 sound/usb/quirks-table.h | 7 ++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index b0369df53910..e692ae04436a 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -291,6 +291,9 @@ int snd_usb_audioformat_set_sync_ep(struct snd_usb_audio *chip,
 	bool is_playback;
 	int err;
 
+	if (fmt->sync_ep)
+		return 0; /* already set up */
+
 	alts = snd_usb_get_host_interface(chip, fmt->iface, fmt->altsetting);
 	if (!alts)
 		return 0;
diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index 78eb41b621d6..4f56e1784932 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -2658,7 +2658,12 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 					.nr_rates = 2,
 					.rate_table = (unsigned int[]) {
 						44100, 48000
-					}
+					},
+					.sync_ep = 0x82,
+					.sync_iface = 0,
+					.sync_altsetting = 1,
+					.sync_ep_idx = 1,
+					.implicit_fb = 1,
 				}
 			},
 			{
-- 
2.36.1



