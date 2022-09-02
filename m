Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7665AB04C
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237909AbiIBMwM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237830AbiIBMvU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:51:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AF0B1274B;
        Fri,  2 Sep 2022 05:37:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5553FB82A77;
        Fri,  2 Sep 2022 12:35:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FDCAC433D7;
        Fri,  2 Sep 2022 12:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662122120;
        bh=rvsRqFwA2k2w3Fi1nbNzzjO0ZKeucinFjbQ5L5lGwKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L65w096k/3SHDC0tN9VwF/m1tZh04hHaychVyZ0HFXdiiiE/EyXs3ucx/+crp9X/C
         cRfWquzj2qdKd0ymBMm7A9QDxlieRMCEw0qujKt7fyk0HxIqTCG+KZ92BC/SutHlP/
         JvvKHyQDc5kZtnaCgrpLHlJ/kiZKk0ePIoQzDdg0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lennert Van Alboom <lennert@vanalboom.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.19 19/72] ALSA: usb-audio: Add quirk for LH Labs Geek Out HD Audio 1V5
Date:   Fri,  2 Sep 2022 14:18:55 +0200
Message-Id: <20220902121405.408654318@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.772492078@linuxfoundation.org>
References: <20220902121404.772492078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 5f3d9e8161bb8cb23ab3b4678cd13f6e90a06186 upstream.

The USB DAC from LH Labs (2522:0007) seems requiring the same quirk as
Sony Walkman to set up the interface like UAC1; otherwise it gets the
constant errors "usb_set_interface failed (-71)".  This patch adds a
quirk entry for addressing the buggy behavior.

Reported-by: Lennert Van Alboom <lennert@vanalboom.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/T3VPXtCc4uFws9Gfh2RjX6OdwM1RqfC6VqQr--_LMDyB2x5N3p9_q6AtPna17IXhHwBtcJVdXuS80ZZSCMjh_BafIbnzJPhbrkmhmWS6DlI=@vanalboom.org
Link: https://lore.kernel.org/r/20220828074143.14736-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1903,6 +1903,8 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_SHARE_MEDIA_DEVICE | QUIRK_FLAG_ALIGN_TRANSFER),
 	DEVICE_FLG(0x21b4, 0x0081, /* AudioQuest DragonFly */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
+	DEVICE_FLG(0x2522, 0x0007, /* LH Labs Geek Out HD Audio 1V5 */
+		   QUIRK_FLAG_SET_IFACE_FIRST),
 	DEVICE_FLG(0x2708, 0x0002, /* Audient iD14 */
 		   QUIRK_FLAG_IGNORE_CTL_ERROR),
 	DEVICE_FLG(0x2912, 0x30c8, /* Audioengine D1 */


