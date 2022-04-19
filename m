Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF56B5077FE
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 20:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357005AbiDSSY5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 14:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357001AbiDSSWe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 14:22:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE47917064;
        Tue, 19 Apr 2022 11:14:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BFF661337;
        Tue, 19 Apr 2022 18:14:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE3EC385A5;
        Tue, 19 Apr 2022 18:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650392095;
        bh=cX1TogmjffYuRvjQ4kdQaH9bhy7dD4rK6n7EXly9OUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CijdQU8Gae4qlyOdhfYIZ7f4kSAeVrKREp+8d/pthRmSeanUsUNe/F0u3RGbHrhC1
         vaZlvqONeIOyu/I86xj0x2yeLS5u0HcJEQClU3iNzwRJvnbwosJ8s2PfRwvKs4W4y7
         b05bVQ+EP/pp67GXHRi4Q4YtZk3A+RuFm66DmjcYMJ/dXCNunMLdn6q3cFUOjW8wJY
         g2XpQ1CfgdmLE2puIq8c4Vf0JsE3AMsRtL0CfxyU3r0KFLyjudYpKYD6hylvlRQaiV
         JauFVMZEGg+vQ6EdNDoUtU5PdFhI8ihye2k4e6KdAl1JPCcz/hUjvZ9juxpOC2CSqr
         XATk4l59Qs67A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Borislav Petkov <bp@suse.de>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, perex@perex.cz,
        tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 04/14] ALSA: usb-audio: Fix undefined behavior due to shift overflowing the constant
Date:   Tue, 19 Apr 2022 14:14:33 -0400
Message-Id: <20220419181444.485959-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220419181444.485959-1-sashal@kernel.org>
References: <20220419181444.485959-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
index ff97fdcf63bd..b1959e04cbb1 100644
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

