Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9360505380
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240497AbiDRNAS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242324AbiDRM7s (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:59:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 230C530F49;
        Mon, 18 Apr 2022 05:40:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7CF5611CF;
        Mon, 18 Apr 2022 12:40:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A779CC385A7;
        Mon, 18 Apr 2022 12:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285645;
        bh=UYHUcoEgKn3na7teYp31D7rfV2SER4dpkGY85jOixaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1MNicW9XcqvSMDFF2MzOevww4422s4OB2KmqVb9uPezbTg7tgY8YWh5IpWDMoSVuC
         DylJz3w5ZQKSiAcSCJEHy1qfOnSGj94pM9xm4r5/BxiSK5FJk6Hd5j+bWF9cxMnk1m
         w2RKZbgNAOc8WG43WtxTye1ngli0fM4y5xRcARlI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Fabio M. De Francesco" <fmdefrancesco@gmail.com>,
        Takashi Iwai <tiwai@suse.de>,
        syzbot+205eb15961852c2c5974@syzkaller.appspotmail.com
Subject: [PATCH 5.10 083/105] ALSA: pcm: Test for "silence" field in struct "pcm_format_data"
Date:   Mon, 18 Apr 2022 14:13:25 +0200
Message-Id: <20220418121148.990879701@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121145.140991388@linuxfoundation.org>
References: <20220418121145.140991388@linuxfoundation.org>
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

From: Fabio M. De Francesco <fmdefrancesco@gmail.com>

commit 2f7a26abb8241a0208c68d22815aa247c5ddacab upstream.

Syzbot reports "KASAN: null-ptr-deref Write in
snd_pcm_format_set_silence".[1]

It is due to missing validation of the "silence" field of struct
"pcm_format_data" in "pcm_formats" array.

Add a test for valid "pat" and, if it is not so, return -EINVAL.

[1] https://lore.kernel.org/lkml/000000000000d188ef05dc2c7279@google.com/

Reported-and-tested-by: syzbot+205eb15961852c2c5974@syzkaller.appspotmail.com
Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220409012655.9399-1-fmdefrancesco@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/pcm_misc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/core/pcm_misc.c
+++ b/sound/core/pcm_misc.c
@@ -429,7 +429,7 @@ int snd_pcm_format_set_silence(snd_pcm_f
 		return 0;
 	width = pcm_formats[(INT)format].phys; /* physical width */
 	pat = pcm_formats[(INT)format].silence;
-	if (! width)
+	if (!width || !pat)
 		return -EINVAL;
 	/* signed or 1 byte data */
 	if (pcm_formats[(INT)format].signd == 1 || width <= 8) {


