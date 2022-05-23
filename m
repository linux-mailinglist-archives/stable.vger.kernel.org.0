Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83AC15316D5
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240521AbiEWR22 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:28:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240772AbiEWR0E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:26:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ABB4E22;
        Mon, 23 May 2022 10:21:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD192B81219;
        Mon, 23 May 2022 17:18:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F6C0C3411C;
        Mon, 23 May 2022 17:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326316;
        bh=DNfz1o6qKb6qIfL/FrsqbiDZgTcZ8zxQ00E+YIOP5tI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YcPC848wAF+4Mr0Qb0o3z9X9I2mjQh03DT78NLpjzzQSf1mxkWDtskV/OLrrwyxVd
         7DUaP4Hn2t0FiLzs5ICC8XgA8qo2hwtVcT7A0ym0nHL3Buxo4GqH+8gRk3WL99SpNz
         kCLXxWpUI1RNCTU65vmBMmFDrYb+MAexZGgNOcJs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 044/132] ALSA: usb-audio: Restore Rane SL-1 quirk
Date:   Mon, 23 May 2022 19:04:13 +0200
Message-Id: <20220523165830.606361258@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165823.492309987@linuxfoundation.org>
References: <20220523165823.492309987@linuxfoundation.org>
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


