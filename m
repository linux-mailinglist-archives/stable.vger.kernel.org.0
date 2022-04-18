Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC5425053D9
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238778AbiDRNBW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242313AbiDRM7r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:59:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B86F30574;
        Mon, 18 Apr 2022 05:40:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC4AE60FB6;
        Mon, 18 Apr 2022 12:40:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F7DBC385A1;
        Mon, 18 Apr 2022 12:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285642;
        bh=Mjxt2i/b04vTLzk5hAVoMByvoXozygDZrgJVQY2xCLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2a3Qd84p+xntYsoiQfWPN2PToiL0lBnRY4d3Srz83tBEkSAgos8oiVAquJj3s+VMx
         RaEDHA5T8p6T2idPpNZxmzc8bUR53SN1XV+w5f1uvmQJyZnPI9+pbhcsnV5JPhu156
         qYwbUxrVHO0OxEO/XgseJO9smeBYlRhKzzhfjd0c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tao Jin <tao-j@outlook.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 082/105] ALSA: hda/realtek: add quirk for Lenovo Thinkpad X12 speakers
Date:   Mon, 18 Apr 2022 14:13:24 +0200
Message-Id: <20220418121148.961889761@linuxfoundation.org>
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

From: Tao Jin <tao-j@outlook.com>

commit 264fb03497ec1c7841bba872571bcd11beed57a7 upstream.

For this specific device on Lenovo Thinkpad X12 tablet, the verbs were
dumped by qemu running a guest OS that init this codec properly.
After studying the dump, it turns out that
the same quirk used by the other Lenovo devices can be reused.

The patch was tested working against the mainline kernel.

Cc: <stable@vger.kernel.org>
Signed-off-by: Tao Jin <tao-j@outlook.com>
Link: https://lore.kernel.org/r/CO6PR03MB6241CD73310B37858FE64C85E1E89@CO6PR03MB6241.namprd03.prod.outlook.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8995,6 +8995,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x17aa, 0x505d, "Thinkpad", ALC298_FIXUP_TPT470_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x505f, "Thinkpad", ALC298_FIXUP_TPT470_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x5062, "Thinkpad", ALC298_FIXUP_TPT470_DOCK),
+	SND_PCI_QUIRK(0x17aa, 0x508b, "Thinkpad X12 Gen 1", ALC287_FIXUP_LEGION_15IMHG05_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x5109, "Thinkpad", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x17aa, 0x511e, "Thinkpad", ALC298_FIXUP_TPT470_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x511f, "Thinkpad", ALC298_FIXUP_TPT470_DOCK),


