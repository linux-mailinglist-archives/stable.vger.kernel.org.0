Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AEAB50F696
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234448AbiDZI5M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345798AbiDZIoN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:44:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9111F15C2B9;
        Tue, 26 Apr 2022 01:33:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0FCD9B81A2F;
        Tue, 26 Apr 2022 08:33:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62696C385A4;
        Tue, 26 Apr 2022 08:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962017;
        bh=mI5uF3rn4LcSnNyEYRFVfpxL+mGAsmineE+zYsy/SWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yn7m7dKKwKT/x3/HX2Pd4KFCFnnJ8ZuaW98dtVDFrEJ7fxnp01afDufSVxgvNnjVo
         ZLjlT14CZXlMrIUPG6CvRV4e2sZPhfJ0U9n+Gs7VITmIBVYg3Mzz0Q42Fv/I5Fq0oi
         nprcPX5eOSGK7hU4dgDWp4bpf3k9KnlePD+T7OKo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 37/86] ALSA: usb-audio: Fix undefined behavior due to shift overflowing the constant
Date:   Tue, 26 Apr 2022 10:21:05 +0200
Message-Id: <20220426081742.276968136@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081741.202366502@linuxfoundation.org>
References: <20220426081741.202366502@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

[ Upstream commit 1ef8715975de8bd481abbd0839ed4f49d9e5b0ff ]

Fix:

  sound/usb/midi.c: In function ‘snd_usbmidi_out_endpoint_create’:
  sound/usb/midi.c:1389:2: error: case label does not reduce to an integer constant
    case USB_ID(0xfc08, 0x0101): /* Unknown vendor Cable */
    ^~~~

See https://lore.kernel.org/r/YkwQ6%2BtIH8GQpuct@zn.tnic for the gory
details as to why it triggers with older gccs only.

[ A slight correction with parentheses around the argument by tiwai ]

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20220405151517.29753-3-bp@alien8.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/usbaudio.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/usbaudio.h b/sound/usb/usbaudio.h
index e54a98f46549..d8e31ee03b9d 100644
--- a/sound/usb/usbaudio.h
+++ b/sound/usb/usbaudio.h
@@ -8,7 +8,7 @@
  */
 
 /* handling of USB vendor/product ID pairs as 32-bit numbers */
-#define USB_ID(vendor, product) (((vendor) << 16) | (product))
+#define USB_ID(vendor, product) (((unsigned int)(vendor) << 16) | (product))
 #define USB_ID_VENDOR(id) ((id) >> 16)
 #define USB_ID_PRODUCT(id) ((u16)(id))
 
-- 
2.35.1



