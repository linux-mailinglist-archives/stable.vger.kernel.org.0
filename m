Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38C064ABDA0
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 13:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388830AbiBGLpl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:45:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385613AbiBGLcB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:32:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4985CC03CA4B;
        Mon,  7 Feb 2022 03:31:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4EAE60B20;
        Mon,  7 Feb 2022 11:31:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE4D6C340EB;
        Mon,  7 Feb 2022 11:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233470;
        bh=5IsXqdmiyDuHjCKLVr33FdSRI3q+QbGeX0U1P/98KaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TpdlaYUuFKDBNLzMrjnDoomZmrM2ls4juHZlczdsnRlA7BOCkZ7KrgxUsJwgsuvgx
         LyeA4mLciJDhPaTVlHVeZzdLsnnjIDTm/cVkMCBUc8iVqTMp+0uO9EdiZiM3t0jVtk
         AB+yJjdgLkM/nPoM+oMoyBd0QAabWhAVrFaOW+Dc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.16 006/126] ASoC: hdmi-codec: Fix OOB memory accesses
Date:   Mon,  7 Feb 2022 12:05:37 +0100
Message-Id: <20220207103804.281396179@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103804.053675072@linuxfoundation.org>
References: <20220207103804.053675072@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Dmitry Osipenko <digetx@gmail.com>

commit 06feec6005c9d9500cd286ec440aabf8b2ddd94d upstream.

Correct size of iec_status array by changing it to the size of status
array of the struct snd_aes_iec958. This fixes out-of-bounds slab
read accesses made by memcpy() of the hdmi-codec driver. This problem
is reported by KASAN.

Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Link: https://lore.kernel.org/r/20220112195039.1329-1-digetx@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/sound/asound.h   |    4 +++-
 sound/soc/codecs/hdmi-codec.c |    2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/include/uapi/sound/asound.h
+++ b/include/uapi/sound/asound.h
@@ -56,8 +56,10 @@
  *                                                                          *
  ****************************************************************************/
 
+#define AES_IEC958_STATUS_SIZE		24
+
 struct snd_aes_iec958 {
-	unsigned char status[24];	/* AES/IEC958 channel status bits */
+	unsigned char status[AES_IEC958_STATUS_SIZE]; /* AES/IEC958 channel status bits */
 	unsigned char subcode[147];	/* AES/IEC958 subcode bits */
 	unsigned char pad;		/* nothing */
 	unsigned char dig_subframe[4];	/* AES/IEC958 subframe bits */
--- a/sound/soc/codecs/hdmi-codec.c
+++ b/sound/soc/codecs/hdmi-codec.c
@@ -277,7 +277,7 @@ struct hdmi_codec_priv {
 	bool busy;
 	struct snd_soc_jack *jack;
 	unsigned int jack_status;
-	u8 iec_status[5];
+	u8 iec_status[AES_IEC958_STATUS_SIZE];
 };
 
 static const struct snd_soc_dapm_widget hdmi_widgets[] = {


