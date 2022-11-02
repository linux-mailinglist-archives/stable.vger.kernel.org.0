Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1DF96158D3
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbiKBC7M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbiKBC7J (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:59:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A96221E07
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:59:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDA91617C8
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:59:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91DFCC433C1;
        Wed,  2 Nov 2022 02:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357947;
        bh=hirwckMCgJj+uW0rDUlQ18kc0agJ0aW2bIOVc7+5l04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZJzdiwt38hwDpT0s46fTXt2jkc1gUEmZ7nnt6m6wDQYNHEHPkzaTTIfWTukOfLN1y
         BDv6GUKeaczoMj0OS9HXebBWwIMU7jtXv6MBqAVkt/6yMgJOerLXc+JFvuUgw6Ffuk
         m47xf97KacChuIX5DbaBsO2kVeurLV7mdeFwwSK8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 006/132] ALSA: usb-audio: Add quirks for M-Audio Fast Track C400/600
Date:   Wed,  2 Nov 2022 03:31:52 +0100
Message-Id: <20221102022059.777003818@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 794814529384721ce8f4d34228dc599cc010353d upstream.

M-Audio Fast Track C400 and C600 devices (0763:2030 and 0763:2031,
respectively) seem requiring the explicit setup for the implicit
feedback mode.  This patch adds the quirk entries for those.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=214817
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20221021122722.24784-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/implicit.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/usb/implicit.c
+++ b/sound/usb/implicit.c
@@ -47,6 +47,8 @@ struct snd_usb_implicit_fb_match {
 static const struct snd_usb_implicit_fb_match playback_implicit_fb_quirks[] = {
 	/* Fixed EP */
 	/* FIXME: check the availability of generic matching */
+	IMPLICIT_FB_FIXED_DEV(0x0763, 0x2030, 0x81, 3), /* M-Audio Fast Track C400 */
+	IMPLICIT_FB_FIXED_DEV(0x0763, 0x2031, 0x81, 3), /* M-Audio Fast Track C600 */
 	IMPLICIT_FB_FIXED_DEV(0x0763, 0x2080, 0x81, 2), /* M-Audio FastTrack Ultra */
 	IMPLICIT_FB_FIXED_DEV(0x0763, 0x2081, 0x81, 2), /* M-Audio FastTrack Ultra */
 	IMPLICIT_FB_FIXED_DEV(0x2466, 0x8010, 0x81, 2), /* Fractal Audio Axe-Fx III */


