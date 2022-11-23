Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 844E463589F
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 11:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236669AbiKWKCU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 05:02:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237175AbiKWKAz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 05:00:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ADC711A703
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:53:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6CDE6B81EE5
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:53:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0385C433D6;
        Wed, 23 Nov 2022 09:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197186;
        bh=M1tiEDPlysW26DS+/MGU5V9FjDiIZ+/hZ8qA/D+R5Vg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1l7gwZHjXAQ3qHUD9a4RXMk5/J3IbFPjJRqOQi1hegrTgeLXiaDWOj8snrTX46WiE
         gcDD1aUfUVT6b55oJfzWU0Ur7zAbIX6CNm3RB2t4ly8nxd8AQyxe5ZMaeo4I4TYKve
         T1xJrHqZr9Np9r56L+wfpQR0TEWr2zizxw6hQA0s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Emil Flink <emil.flink@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.0 222/314] ALSA: hda/realtek: fix speakers for Samsung Galaxy Book Pro
Date:   Wed, 23 Nov 2022 09:51:07 +0100
Message-Id: <20221123084635.589427754@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Emil Flink <emil.flink@gmail.com>

commit b18a456330e1c1ca207b57b45872f10336741388 upstream.

The Samsung Galaxy Book Pro seems to have the same issue as a few
other Samsung laptops, detailed in kernel bug report 207423. Sound from
headphone jack works, but not the built-in speakers.

alsa-info: http://alsa-project.org/db/?f=b40ba609dc6ae28dc84ad404a0d8a4bbcd8bea6d

Signed-off-by: Emil Flink <emil.flink@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20221115144500.7782-1-emil.flink@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9446,6 +9446,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x144d, 0xc176, "Samsung Notebook 9 Pro (NP930MBE-K04US)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc189, "Samsung Galaxy Flex Book (NT950QCG-X716)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc18a, "Samsung Galaxy Book Ion (NP930XCJ-K01US)", ALC298_FIXUP_SAMSUNG_AMP),
+	SND_PCI_QUIRK(0x144d, 0xc1a3, "Samsung Galaxy Book Pro (NP935XDB-KC1SE)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc740, "Samsung Ativ book 8 (NP870Z5G)", ALC269_FIXUP_ATIV_BOOK_8),
 	SND_PCI_QUIRK(0x144d, 0xc812, "Samsung Notebook Pen S (NT950SBE-X58)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc830, "Samsung Galaxy Book Ion (NT950XCJ-X716A)", ALC298_FIXUP_SAMSUNG_AMP),


