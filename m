Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38F59635608
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237570AbiKWJ0U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:26:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237631AbiKWJ0B (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:26:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 113C08E2AF
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:24:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0B5961B29
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:24:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92634C433C1;
        Wed, 23 Nov 2022 09:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195493;
        bh=+D3/pq+rbn2ovkDvw9nNjYgjbEwbEQJYh26Y3w/nW7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f7wmqNTO5KMDZnIgzD2FNhXUKOKdWZnPGARt57Vjzp9pE/iod0kHQw5fOV29/Avmc
         XMSK8gticIn7GB8Sxo6kK79NGS12Hcm/0G8V9z/I6hvDvt4MIDklI1hG0eksyU3F6E
         PPKtPktqebNa//tpsyn3vPMqkO5+1oC5s/DElEuw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Emil Flink <emil.flink@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 092/149] ALSA: hda/realtek: fix speakers for Samsung Galaxy Book Pro
Date:   Wed, 23 Nov 2022 09:51:15 +0100
Message-Id: <20221123084601.295323048@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
References: <20221123084557.945845710@linuxfoundation.org>
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
@@ -9007,6 +9007,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x144d, 0xc176, "Samsung Notebook 9 Pro (NP930MBE-K04US)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc189, "Samsung Galaxy Flex Book (NT950QCG-X716)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc18a, "Samsung Galaxy Book Ion (NP930XCJ-K01US)", ALC298_FIXUP_SAMSUNG_AMP),
+	SND_PCI_QUIRK(0x144d, 0xc1a3, "Samsung Galaxy Book Pro (NP935XDB-KC1SE)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc740, "Samsung Ativ book 8 (NP870Z5G)", ALC269_FIXUP_ATIV_BOOK_8),
 	SND_PCI_QUIRK(0x144d, 0xc812, "Samsung Notebook Pen S (NT950SBE-X58)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc830, "Samsung Galaxy Book Ion (NT950XCJ-X716A)", ALC298_FIXUP_SAMSUNG_AMP),


