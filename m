Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73270500EB7
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 15:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243908AbiDNNUa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243890AbiDNNTG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:19:06 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71C829287D;
        Thu, 14 Apr 2022 06:16:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DEEADCE296C;
        Thu, 14 Apr 2022 13:16:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB1C1C385A1;
        Thu, 14 Apr 2022 13:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942183;
        bh=YBMuKryNkgLOxzHatH/JEMX77pRs17QuCw8/1sGS2q4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QOnIILDdF6PKIroW30X9ZpNMdiEC4a6QwPAU8f5cfCFXAXYmP96zGZC93zPGHoYr7
         JRzISV4M6uv2+g33cN03vdT1VA3too+HaQ2STnU0Bd2UYhKZIbSvxi7JcS2nbe3aZM
         PhouyluRIyOerczD/LfWXkfeuhzTF0Ik3GBXVWxA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 044/338] ALSA: hda/realtek: Fix audio regression on Mi Notebook Pro 2020
Date:   Thu, 14 Apr 2022 15:09:07 +0200
Message-Id: <20220414110840.150964335@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
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

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit f30741cded62f87bb4b1cc58bc627f076abcaba8 upstream.

Commit 5aec98913095 ("ALSA: hda/realtek - ALC236 headset MIC recording
issue") is to solve recording issue met on AL236, by matching codec
variant ALC269_TYPE_ALC257 and ALC269_TYPE_ALC256.

This match can be too broad and Mi Notebook Pro 2020 is broken by the
patch.

Instead, use codec ID to be narrow down the scope, in order to make
ALC256 unaffected.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=215484
Fixes: 5aec98913095 ("ALSA: hda/realtek - ALC236 headset MIC recording issue")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Link: https://lore.kernel.org/r/20220330061335.1015533-1-kai.heng.feng@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3400,8 +3400,8 @@ static void alc256_shutup(struct hda_cod
 	/* If disable 3k pulldown control for alc257, the Mic detection will not work correctly
 	 * when booting with headset plugged. So skip setting it for the codec alc257
 	 */
-	if (spec->codec_variant != ALC269_TYPE_ALC257 &&
-	    spec->codec_variant != ALC269_TYPE_ALC256)
+	if (codec->core.vendor_id != 0x10ec0236 &&
+	    codec->core.vendor_id != 0x10ec0257)
 		alc_update_coef_idx(codec, 0x46, 0, 3 << 12);
 
 	if (!spec->no_shutup_pins)


