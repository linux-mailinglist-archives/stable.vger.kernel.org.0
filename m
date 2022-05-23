Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 809FB531692
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241680AbiEWRd6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240994AbiEWRck (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:32:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C3575232;
        Mon, 23 May 2022 10:27:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84EAAB81201;
        Mon, 23 May 2022 17:27:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7850C385A9;
        Mon, 23 May 2022 17:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326838;
        bh=f/gxUlTFfj5frVlRI3KJBmQ/F3Zpezwb6EMBb3DBUTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2B2Ms9YcNExZ6Z7GaQMmMq1xQxsGpVHBaBEsuUqsx0ghCGBQFLTO4E9GKqngje8KJ
         0muF7APF6ia2lu9Zk0lRL/F0tWacjG4LSaI68CLjmEPPWNgWU23pv5DMG12+yXELIS
         Mp9T6T/3eWMuLbzm2r6EV98Q/pDzOniocwPmJxgk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 075/158] ALSA: hda - fix unused Realtek function when PM is not enabled
Date:   Mon, 23 May 2022 19:03:52 +0200
Message-Id: <20220523165843.404303095@linuxfoundation.org>
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

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit c3d9ca93f1e3bd3d1adfc4479a12c82fed424c87 ]

When CONFIG_PM is not enabled, alc_shutup() is not needed,
so move it inside the #ifdef CONFIG_PM guard.
Also drop some contiguous #endif / #ifdef CONFIG_PM for simplicity.

Fixes this build warning:
sound/pci/hda/patch_realtek.c:886:20: warning: unused function 'alc_shutup'

Fixes: 08c189f2c552 ("ALSA: hda - Use generic parser codes for Realtek driver")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/r/20220430193318.29024-1-rdunlap@infradead.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 779205bf5862..e38acdbe1a3b 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -937,6 +937,9 @@ static int alc_init(struct hda_codec *codec)
 	return 0;
 }
 
+#define alc_free	snd_hda_gen_free
+
+#ifdef CONFIG_PM
 static inline void alc_shutup(struct hda_codec *codec)
 {
 	struct alc_spec *spec = codec->spec;
@@ -950,9 +953,6 @@ static inline void alc_shutup(struct hda_codec *codec)
 		alc_shutup_pins(codec);
 }
 
-#define alc_free	snd_hda_gen_free
-
-#ifdef CONFIG_PM
 static void alc_power_eapd(struct hda_codec *codec)
 {
 	alc_auto_setup_eapd(codec, false);
@@ -966,9 +966,7 @@ static int alc_suspend(struct hda_codec *codec)
 		spec->power_hook(codec);
 	return 0;
 }
-#endif
 
-#ifdef CONFIG_PM
 static int alc_resume(struct hda_codec *codec)
 {
 	struct alc_spec *spec = codec->spec;
-- 
2.35.1



