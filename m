Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D41404ABD42
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387188AbiBGLkP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:40:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386636AbiBGLfN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:35:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28B4AC043181;
        Mon,  7 Feb 2022 03:35:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB421B80EBD;
        Mon,  7 Feb 2022 11:35:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D09B7C004E1;
        Mon,  7 Feb 2022 11:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233710;
        bh=+IY6A+HUlenz/HqGjjxj3obMOLESQN8pG2bZR8pv5QI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VHuxb3Hxz6I0A4XEIYBuYkZJi7q92A+cBMD/eFCkjFrHSAnj690EO0Ayi90kQDR+G
         dx9asc8xyX6WXzLfk0/fFpubIJmerjHAqTAIq0eeUzobecQ6nncp4S9Z1t4JBGFhbV
         1K8ZuQg3h7WSFd/jDVVLCafNELVdl2mjPIqdSjKc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.16 054/126] ALSA: usb-audio: initialize variables that could ignore errors
Date:   Mon,  7 Feb 2022 12:06:25 +0100
Message-Id: <20220207103805.976127340@linuxfoundation.org>
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

From: Tom Rix <trix@redhat.com>

commit 3da4b7403db87d39bc2613cfd790de1de99a70ab upstream.

clang static analysis reports this representative issue
mixer.c:1548:35: warning: Assigned value is garbage or undefined
        ucontrol->value.integer.value[0] = val;
                                         ^ ~~~

The filter_error() macro allows errors to be ignored.
If errors can be ignored, initialize variables
so garbage will not be used.

Fixes: 48cc42973509 ("ALSA: usb-audio: Filter error from connector kctl ops, too")
Signed-off-by: Tom Rix <trix@redhat.com>
Link: https://lore.kernel.org/r/20220126182142.1184819-1-trix@redhat.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1526,6 +1526,10 @@ error:
 		usb_audio_err(chip,
 			"cannot get connectors status: req = %#x, wValue = %#x, wIndex = %#x, type = %d\n",
 			UAC_GET_CUR, validx, idx, cval->val_type);
+
+		if (val)
+			*val = 0;
+
 		return filter_error(cval, ret);
 	}
 


