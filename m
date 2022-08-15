Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE7F95934B4
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 20:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234642AbiHOSOz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:14:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233092AbiHOSOX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:14:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 491502A940;
        Mon, 15 Aug 2022 11:14:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7AC66126D;
        Mon, 15 Aug 2022 18:14:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5E31C433D6;
        Mon, 15 Aug 2022 18:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587242;
        bh=OulFKFL7KovR2r6EPGY1gNLGYVPmkKMFn3kUuRZ3tqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0GArjA4ClM1VUi0xwvcZFeZ8KoxSjY6+2OxumJTGZ79hLSEOMdzg1JZZ3gT0NqHqn
         gsJ3eEgll+pO9BKFyvCiB2KdZ//No2r465yUg/IA36ctcMUEhmrfYEnqRktnReJV2u
         m9ePgL1uF7aAZ7BKW7fiTJqmCF7J4r8jhJmLSE58=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 008/779] ALSA: usb-audio: Add quirk for Behringer UMC202HD
Date:   Mon, 15 Aug 2022 19:54:12 +0200
Message-Id: <20220815180337.528098567@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

commit e086c37f876fd1f551e2b4f9be97d4a1923cd219 upstream.

Just like other Behringer models, UMC202HD (USB ID 1397:0507) requires
the quirk for the stable streaming, too.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=215934
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220722143948.29804-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1843,6 +1843,8 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_SHARE_MEDIA_DEVICE | QUIRK_FLAG_ALIGN_TRANSFER),
 	DEVICE_FLG(0x1395, 0x740a, /* Sennheiser DECT */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
+	DEVICE_FLG(0x1397, 0x0507, /* Behringer UMC202HD */
+		   QUIRK_FLAG_PLAYBACK_FIRST | QUIRK_FLAG_GENERIC_IMPLICIT_FB),
 	DEVICE_FLG(0x1397, 0x0508, /* Behringer UMC204HD */
 		   QUIRK_FLAG_PLAYBACK_FIRST | QUIRK_FLAG_GENERIC_IMPLICIT_FB),
 	DEVICE_FLG(0x1397, 0x0509, /* Behringer UMC404HD */


