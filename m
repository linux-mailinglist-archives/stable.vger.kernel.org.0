Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E21634F3275
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235284AbiDEKeK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239718AbiDEJeA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:34:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE4776678;
        Tue,  5 Apr 2022 02:22:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7EAAA6144D;
        Tue,  5 Apr 2022 09:22:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90584C385A2;
        Tue,  5 Apr 2022 09:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150571;
        bh=xaB/s4IKglcNzbwJvxzFEKSh4r3IK+iI7Ymfiv2vS58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a4D5UcB7URkfr6NqJwYVPQfuwc0SBOt9+13z4m5gQfij09ZnDb1GTBX9Fw1rbQai/
         p6RwYcuazvIahKJOrMnXuEwhBifNMVuhPr8JUGLD4h1FqSaEXRYBbwGq81q3H1n90h
         bxWVKh1mF4VgJmSBpO8oJr5KM4HFPJjINgSTPs0M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 102/913] ALSA: hda/realtek: Fix audio regression on Mi Notebook Pro 2020
Date:   Tue,  5 Apr 2022 09:19:24 +0200
Message-Id: <20220405070342.884920005@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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
@@ -3612,8 +3612,8 @@ static void alc256_shutup(struct hda_cod
 	/* If disable 3k pulldown control for alc257, the Mic detection will not work correctly
 	 * when booting with headset plugged. So skip setting it for the codec alc257
 	 */
-	if (spec->codec_variant != ALC269_TYPE_ALC257 &&
-	    spec->codec_variant != ALC269_TYPE_ALC256)
+	if (codec->core.vendor_id != 0x10ec0236 &&
+	    codec->core.vendor_id != 0x10ec0257)
 		alc_update_coef_idx(codec, 0x46, 0, 3 << 12);
 
 	if (!spec->no_shutup_pins)


