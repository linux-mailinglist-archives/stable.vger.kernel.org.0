Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59E884E7601
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 16:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359678AbiCYPJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 11:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359866AbiCYPIM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 11:08:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5592DD95F3;
        Fri, 25 Mar 2022 08:06:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E484061BF7;
        Fri, 25 Mar 2022 15:06:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8246C340EE;
        Fri, 25 Mar 2022 15:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648220795;
        bh=0t6rOqqnZ4dHupbcVnNiXxZOIEusOi5qLvPWJONBqH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G/FjwV59Y0O28E+MzXfUvnPXESbcBTwfS3TCwTrQLH3kfqTqE2dELjk+AEs7Kgmn7
         vz5hjAaDjBkyLqdyfGiSpxTnImLeXESbnb8NCcaHYNG1UCVQtsqPyq04lLfouE/XLc
         VJn/fvU225lfZcqZuSWILNMvAWnA6a+NuOcOfuz4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Giacomo Guiduzzi <guiduzzi.giacomo@gmail.com>,
        Paolo Valente <paolo.valente@linaro.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 12/20] ALSA: pci: fix reading of swapped values from pcmreg in AC97 codec
Date:   Fri, 25 Mar 2022 16:04:50 +0100
Message-Id: <20220325150417.365246197@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220325150417.010265747@linuxfoundation.org>
References: <20220325150417.010265747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Giacomo Guiduzzi <guiduzzi.giacomo@gmail.com>

commit 17aaf0193392cb3451bf0ac75ba396ec4cbded6e upstream.

Tests 72 and 78 for ALSA in kselftest fail due to reading
inconsistent values from some devices on a VirtualBox
Virtual Machine using the snd_intel8x0 driver for the AC'97
Audio Controller device.
Taking for example test number 72, this is what the test reports:
"Surround Playback Volume.0 expected 1 but read 0, is_volatile 0"
"Surround Playback Volume.1 expected 0 but read 1, is_volatile 0"
These errors repeat for each value from 0 to 31.

Taking a look at these error messages it is possible to notice
that the written values are read back swapped.
When the write is performed, these values are initially stored in
an array used to sanity-check them and write them in the pcmreg
array. To write them, the two one-byte values are packed together
in a two-byte variable through bitwise operations: the first
value is shifted left by one byte and the second value is stored in the
right byte through a bitwise OR. When reading the values back,
right shifts are performed to retrieve the previously stored
bytes. These shifts are executed in the wrong order, thus
reporting the values swapped as shown above.

This patch fixes this mistake by reversing the read
operations' order.

Signed-off-by: Giacomo Guiduzzi <guiduzzi.giacomo@gmail.com>
Signed-off-by: Paolo Valente <paolo.valente@linaro.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220322200653.15862-1-guiduzzi.giacomo@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/ac97/ac97_codec.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/pci/ac97/ac97_codec.c
+++ b/sound/pci/ac97/ac97_codec.c
@@ -958,8 +958,8 @@ static int snd_ac97_ad18xx_pcm_get_volum
 	int codec = kcontrol->private_value & 3;
 	
 	mutex_lock(&ac97->page_mutex);
-	ucontrol->value.integer.value[0] = 31 - ((ac97->spec.ad18xx.pcmreg[codec] >> 0) & 31);
-	ucontrol->value.integer.value[1] = 31 - ((ac97->spec.ad18xx.pcmreg[codec] >> 8) & 31);
+	ucontrol->value.integer.value[0] = 31 - ((ac97->spec.ad18xx.pcmreg[codec] >> 8) & 31);
+	ucontrol->value.integer.value[1] = 31 - ((ac97->spec.ad18xx.pcmreg[codec] >> 0) & 31);
 	mutex_unlock(&ac97->page_mutex);
 	return 0;
 }


