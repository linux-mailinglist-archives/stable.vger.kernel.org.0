Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A32BA627EB2
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237420AbiKNMuj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:50:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237429AbiKNMui (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:50:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F44AF59B
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:50:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2E1261154
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:50:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0C1FC433C1;
        Mon, 14 Nov 2022 12:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430236;
        bh=COXJYXwjkRVyoHiepQqtGJG4HwhHICoCqa/450+VuG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eYQwXFhYuBbPDJpGkjYnEUIPFq3ujN0Z6PeAp1/UtaI/pr+0vPtxWTqsj/4NAOMeF
         Oyu4vda/GiebEVg1EwI+ZSsIBMU3aSGV5/H41DlTflAkWMln2mAFxbFDK0jfNbMPap
         OC4ftjmpdkjT7Y5RNn6oyxLjaTchDsaV2j2/2VCM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ash Logan <ash@heyquark.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 65/95] ALSA: usb-audio: Add quirk entry for M-Audio Micro
Date:   Mon, 14 Nov 2022 13:45:59 +0100
Message-Id: <20221114124445.243853465@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124442.530286937@linuxfoundation.org>
References: <20221114124442.530286937@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 2f01a612d4758b45f775dbb88a49cf534ba47275 upstream.

M-Audio Micro (0762:201a) defines the descriptor as vendor-specific,
while the content seems class-compliant.  Just overriding the probe
makes the device working.

Reported-by: Ash Logan <ash@heyquark.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/7ecd4417-d860-4773-c1c1-b07433342390@heyquark.com
Link: https://lore.kernel.org/r/20221108140721.24248-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks-table.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -2029,6 +2029,10 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 	}
 },
 {
+	/* M-Audio Micro */
+	USB_DEVICE_VENDOR_SPEC(0x0763, 0x201a),
+},
+{
 	USB_DEVICE_VENDOR_SPEC(0x0763, 0x2030),
 	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
 		/* .vendor_name = "M-Audio", */


