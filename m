Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3DD4F25BA
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232536AbiDEHvV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233529AbiDEHr4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:47:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0443E91AEC;
        Tue,  5 Apr 2022 00:44:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95939616BF;
        Tue,  5 Apr 2022 07:44:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7A62C340EE;
        Tue,  5 Apr 2022 07:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144692;
        bh=MUiEXPO4LhosmoDe4SgoOHlSs9A0TC8U8L2HesdNXFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iVOedYzIqlCm5/39BXnEoO0NA7NoerMS0X+5i92roGYnrJjHVNezEdguyOJ6Pvqr3
         gcU5Yz8TFr4A9V+IR85NMJr/q7N7m4bc6QjgdnC8JwVRni4mHBhQ0Hqi/3Z9sYVnbJ
         4LzIEGIHSo5WmbR/oscgiV0u5/Z6O6f9QVJ88kzc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.17 0099/1126] ALSA: hda/realtek: Fix audio regression on Mi Notebook Pro 2020
Date:   Tue,  5 Apr 2022 09:14:06 +0200
Message-Id: <20220405070410.475002959@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
@@ -3617,8 +3617,8 @@ static void alc256_shutup(struct hda_cod
 	/* If disable 3k pulldown control for alc257, the Mic detection will not work correctly
 	 * when booting with headset plugged. So skip setting it for the codec alc257
 	 */
-	if (spec->codec_variant != ALC269_TYPE_ALC257 &&
-	    spec->codec_variant != ALC269_TYPE_ALC256)
+	if (codec->core.vendor_id != 0x10ec0236 &&
+	    codec->core.vendor_id != 0x10ec0257)
 		alc_update_coef_idx(codec, 0x46, 0, 3 << 12);
 
 	if (!spec->no_shutup_pins)


