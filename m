Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 951AD5050AB
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237743AbiDRM1J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238801AbiDRM03 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:26:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1A1312627;
        Mon, 18 Apr 2022 05:20:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C6A360F0A;
        Mon, 18 Apr 2022 12:20:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D8A1C385A7;
        Mon, 18 Apr 2022 12:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284435;
        bh=cHzjVjOSdviZQieqIhrut6Nw64jgSnt25FS3U1Yufgs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gyFddJffgjNaZ7lLlpLOd8dAh7bgSpHjPexTVjaowBf5aB+/sAMF8jPYUORa8PtFI
         Rb/5JgaYYUdYBkR0O7E6U45PHHldjkqWNdg/yNw0AisMk8164rK5TDkVUcxpSZzxTi
         Iu1oz8GdDY3Ktx4qkAJqoQEtXQ9r1nL6H0oxRcAE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 114/219] ALSA: usb-audio: Increase max buffer size
Date:   Mon, 18 Apr 2022 14:11:23 +0200
Message-Id: <20220418121210.091031464@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit fee2ec8cceb33b8886bc5894fb07e0b2e34148af ]

The current limit of max buffer size 1MB seems too small for modern
devices with lots of channels and high sample rates.
Let's make bigger, 4MB.

Reviewed-by: Jaroslav Kysela <perex@perex.cz>
Link: https://lore.kernel.org/r/20220407212740.17920-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/pcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index 6a460225f2e3..37ee6df8b15a 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -659,7 +659,7 @@ static int snd_usb_pcm_prepare(struct snd_pcm_substream *substream)
 #define hwc_debug(fmt, args...) do { } while(0)
 #endif
 
-#define MAX_BUFFER_BYTES	(1024 * 1024)
+#define MAX_BUFFER_BYTES	(4 * 1024 * 1024)
 #define MAX_PERIOD_BYTES	(512 * 1024)
 
 static const struct snd_pcm_hardware snd_usb_hardware =
-- 
2.35.1



