Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7854E5218A1
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243380AbiEJNjc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:39:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244333AbiEJNh3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:37:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C26462CC6;
        Tue, 10 May 2022 06:25:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8528161767;
        Tue, 10 May 2022 13:25:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C7A3C385C2;
        Tue, 10 May 2022 13:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189134;
        bh=fzdfAEKxwWwnKcFkBTlhyxorVAZZr97R3k+ylvtGsGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GKfwDitnJC4RGyGEFaWdZRl1zUuE1rc1lViTW/OSC6i03yP3Um2UqpqSSeY68vMN8
         HCxZxCAM1tWc203k3VtW7pkTxQEiicBMwN1cEVg4vJF+0TIs/jMQz9mKBfyceGIjii
         Ksbx0aosQX0t2hPTlE0AUTMiRAKGDVXv056muEPg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zihao Wang <wzhd@ustc.edu>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 03/70] ALSA: hda/realtek: Add quirk for Yoga Duet 7 13ITL6 speakers
Date:   Tue, 10 May 2022 15:07:22 +0200
Message-Id: <20220510130732.964782467@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130732.861729621@linuxfoundation.org>
References: <20220510130732.861729621@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zihao Wang <wzhd@ustc.edu>

commit 3b79954fd00d540677c97a560622b73f3a1f4e28 upstream.

Lenovo Yoga Duet 7 13ITL6 has Realtek ALC287 and built-in
speakers do not work out of the box. The fix developed for
Yoga 7i 14ITL5 also enables speaker output for this model.

Signed-off-by: Zihao Wang <wzhd@ustc.edu>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220424084120.74125-1-wzhd@ustc.edu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8969,6 +8969,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x17aa, 0x3813, "Legion 7i 15IMHG05", ALC287_FIXUP_LEGION_15IMHG05_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3818, "Lenovo C940", ALC298_FIXUP_LENOVO_SPK_VOLUME),
 	SND_PCI_QUIRK(0x17aa, 0x3819, "Lenovo 13s Gen2 ITL", ALC287_FIXUP_13S_GEN2_SPEAKERS),
+	SND_PCI_QUIRK(0x17aa, 0x3820, "Yoga Duet 7 13ITL6", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3824, "Legion Y9000X 2020", ALC285_FIXUP_LEGION_Y9000X_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3827, "Ideapad S740", ALC285_FIXUP_IDEAPAD_S740_COEF),
 	SND_PCI_QUIRK(0x17aa, 0x3834, "Lenovo IdeaPad Slim 9i 14ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),


