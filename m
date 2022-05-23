Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B22CC53198C
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241689AbiEWRbC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240832AbiEWR3I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:29:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7C6C2F3A9;
        Mon, 23 May 2022 10:26:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E3F961176;
        Mon, 23 May 2022 17:25:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D0F8C385A9;
        Mon, 23 May 2022 17:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326745;
        bh=DNfz1o6qKb6qIfL/FrsqbiDZgTcZ8zxQ00E+YIOP5tI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aXVTy7t13dpAekGyby1MHUvWAoxQtuTjAKFSq6sWBt2jdykf5AXSSDOAd57HkykW1
         zBxDYKcqaSowimcUGaLu+eQX84R9zfVZUHhfnvjqu8jfnQwUf0Bgb+DyrKt54ritq+
         hRuA4MtoUAYIGffAOSv3jgLQOenbABVKEjn53KUw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.17 046/158] ALSA: usb-audio: Restore Rane SL-1 quirk
Date:   Mon, 23 May 2022 19:03:23 +0200
Message-Id: <20220523165838.222504332@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 5c62383c06837b5719cd5447a5758b791279e653 upstream.

At cleaning up and moving the device rename from the quirk table to
its own table, we removed the entry for Rane SL-1 as we thought it's
only for renaming.  It turned out, however, that the quirk is required
for matching with the device that declares itself as no standard
audio but only as vendor-specific.

Restore the quirk entry for Rane SL-1 to fix the regression.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=215887
Fixes: 5436f59bc5bc ("ALSA: usb-audio: Move device rename and profile quirks to an internal table")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220516103112.12950-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks-table.h |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -3235,6 +3235,15 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 	}
 },
 
+/* Rane SL-1 */
+{
+	USB_DEVICE(0x13e5, 0x0001),
+	.driver_info = (unsigned long) & (const struct snd_usb_audio_quirk) {
+		.ifnum = QUIRK_ANY_INTERFACE,
+		.type = QUIRK_AUDIO_STANDARD_INTERFACE
+        }
+},
+
 /* disabled due to regression for other devices;
  * see https://bugzilla.kernel.org/show_bug.cgi?id=199905
  */


