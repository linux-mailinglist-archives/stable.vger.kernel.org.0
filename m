Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED0894F3A8D
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381549AbiDELqT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354907AbiDEKQe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:16:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09E44101E;
        Tue,  5 Apr 2022 03:03:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A1A461673;
        Tue,  5 Apr 2022 10:03:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9B21C385A1;
        Tue,  5 Apr 2022 10:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153024;
        bh=6+YGF0hCD/pWlHdjsLpdbUkPVcBYuxgy1fm5r8lcUk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rr+kRtr31DbQlaSc+qWdhyDzF3nl5AB7updI3yzHAwTNv0vZsTQqr/R1aSvc3fotg
         pHQZno/oWqkF1C8N92HrTOZ1eqSng7/IHnc2sXdga7acNjoVYT6zZ7JeD3KFrY94KD
         ZpsZDW8zc3zZhpSY8LVXlDtXDD/3c1wANNtCDJsg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 073/599] ALSA: hda/realtek: Fix audio regression on Mi Notebook Pro 2020
Date:   Tue,  5 Apr 2022 09:26:07 +0200
Message-Id: <20220405070300.998662975@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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
@@ -3615,8 +3615,8 @@ static void alc256_shutup(struct hda_cod
 	/* If disable 3k pulldown control for alc257, the Mic detection will not work correctly
 	 * when booting with headset plugged. So skip setting it for the codec alc257
 	 */
-	if (spec->codec_variant != ALC269_TYPE_ALC257 &&
-	    spec->codec_variant != ALC269_TYPE_ALC256)
+	if (codec->core.vendor_id != 0x10ec0236 &&
+	    codec->core.vendor_id != 0x10ec0257)
 		alc_update_coef_idx(codec, 0x46, 0, 3 << 12);
 
 	if (!spec->no_shutup_pins)


