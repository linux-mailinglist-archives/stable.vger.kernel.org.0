Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53F69579BBF
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240772AbiGSM34 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240284AbiGSM3M (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:29:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A70EF67581;
        Tue, 19 Jul 2022 05:11:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BE9D61772;
        Tue, 19 Jul 2022 12:11:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E828C341C6;
        Tue, 19 Jul 2022 12:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232659;
        bh=K2zyLpMT+XKd5jGxKUQWOsfD37JAJYKfQXFsLTKzpSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ap4rQhE8WfmbW+3ddBlZWEWhUavByxrx8Z9qPpSQJjvMMkDOqz6Mst2kiD1RzNIjU
         TsOTNRggIX3m6r9uPCQO6rBuUVM/YRhbhAiX0SNZ2Z/pJBBES1c/kpvLFp+tSGR54q
         mxBUshnnz98bhdoqNfSc0lvwvJNrIU7WtXxcoKts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Meng Tang <tangmeng@uniontech.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 003/167] ALSA: hda/realtek: Fix headset mic for Acer SF313-51
Date:   Tue, 19 Jul 2022 13:52:15 +0200
Message-Id: <20220719114657.049527772@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Meng Tang <tangmeng@uniontech.com>

commit 5f3fe25e70559fa3b096ab17e13316c93ddb7020 upstream.

The issue on Acer SWIFT SF313-51 is that headset microphone
doesn't work. The following quirk fixed headset microphone issue.
Note that the fixup of SF314-54/55 (ALC256_FIXUP_ACER_HEADSET_MIC)
was not successful on my SF313-51.

Signed-off-by: Meng Tang <tangmeng@uniontech.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220711081527.6254-1-tangmeng@uniontech.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8695,6 +8695,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1025, 0x1290, "Acer Veriton Z4860G", ALC286_FIXUP_ACER_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x1291, "Acer Veriton Z4660G", ALC286_FIXUP_ACER_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x129c, "Acer SWIFT SF314-55", ALC256_FIXUP_ACER_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1025, 0x129d, "Acer SWIFT SF313-51", ALC256_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1300, "Acer SWIFT SF314-56", ALC256_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1308, "Acer Aspire Z24-890", ALC286_FIXUP_ACER_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x132a, "Acer TravelMate B114-21", ALC233_FIXUP_ACER_HEADSET_MIC),


