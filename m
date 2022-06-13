Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0B16548EE3
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380645AbiFMN7P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381394AbiFMN4c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:56:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 793F28AE42;
        Mon, 13 Jun 2022 04:37:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0343612D0;
        Mon, 13 Jun 2022 11:37:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF11AC34114;
        Mon, 13 Jun 2022 11:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120221;
        bh=IBXMgi2m7jjJOg4V5lMk5wKC20WA1H57SOGcxCiq9to=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cu78cq8NblrXYQLwqeLRuJuEzRjWnskLBRfGxmY4D2gyzvhvw2/koub2DDgjYSvEK
         LgA0hr+12NY6bWeyd5cbeaezWVBUIq0s1+oHr6wQLE9YZCS3gtdmUUvjbu8Fu0T872
         VI8Bu1neAWoU1NrzvX2KBj70wQvJVUYQxMaPQvLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        =?UTF-8?q?Andr=C3=A9=20Kapelrud?= <a.kapelrud@gmail.com>
Subject: [PATCH 5.18 294/339] ALSA: usb-audio: Set up (implicit) sync for Saffire 6
Date:   Mon, 13 Jun 2022 12:11:59 +0200
Message-Id: <20220613094935.549912505@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
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
 sound/usb/pcm.c          |    3 +++
 sound/usb/quirks-table.h |    7 ++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -291,6 +291,9 @@ int snd_usb_audioformat_set_sync_ep(stru
 	bool is_playback;
 	int err;
 
+	if (fmt->sync_ep)
+		return 0; /* already set up */
+
 	alts = snd_usb_get_host_interface(chip, fmt->iface, fmt->altsetting);
 	if (!alts)
 		return 0;
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


