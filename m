Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 811BB507806
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 20:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356960AbiDSSYx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 14:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357430AbiDSSXV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 14:23:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDBD03EAB6;
        Tue, 19 Apr 2022 11:16:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6079B819AE;
        Tue, 19 Apr 2022 18:16:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 483C9C385A5;
        Tue, 19 Apr 2022 18:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650392166;
        bh=j0gl3vwHeaKb2MMhrqnV3OYaEofGRoT5zWN/DeGK2dI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H8jUkFe7RE6W65hj8kx+mBagfkm6UkiFvKdd4UDEOwbKYW8KJ1eN1sacf1baaBXd8
         eWkQJ/qVSk/p3PFBBS89vBUy+GczPVe90d0ByczGjtT+b/8XhYsrJB+Blcb4iN/1jU
         aHLt6UXibo6Cd1eapN8PUYfJOZ0tECV6YtSL1nZQm5a35XLxZjNbfgqhZ4w4URaCKD
         xPWcV61eQaBjYBYGGmTGyiCI+Muflm92hPFXGbkLup+eOPZVLxlrKzRfObtUGzJ9vG
         VriRwdJTDwMHGQflg6kckMx22aOpOgl8KI7j0nvk6hU6ZaVm2WF8hd7MQYEyV5RYVB
         0FU28J3gbuXcg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Borislav Petkov <bp@suse.de>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, perex@perex.cz,
        tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.14 3/9] ALSA: usb-audio: Fix undefined behavior due to shift overflowing the constant
Date:   Tue, 19 Apr 2022 14:15:51 -0400
Message-Id: <20220419181557.486336-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220419181557.486336-1-sashal@kernel.org>
References: <20220419181557.486336-1-sashal@kernel.org>
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
index 62456a806bb4..4b8f1c46420d 100644
--- a/sound/usb/usbaudio.h
+++ b/sound/usb/usbaudio.h
@@ -22,7 +22,7 @@
  */
 
 /* handling of USB vendor/product ID pairs as 32-bit numbers */
-#define USB_ID(vendor, product) (((vendor) << 16) | (product))
+#define USB_ID(vendor, product) (((unsigned int)(vendor) << 16) | (product))
 #define USB_ID_VENDOR(id) ((id) >> 16)
 #define USB_ID_PRODUCT(id) ((u16)(id))
 
-- 
2.35.1

