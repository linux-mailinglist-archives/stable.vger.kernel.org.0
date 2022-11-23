Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46C26635506
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:14:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237212AbiKWJMR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:12:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237261AbiKWJME (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:12:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D22DF35
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:12:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63FA4B81EF1
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:12:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D00C433C1;
        Wed, 23 Nov 2022 09:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194721;
        bh=6DBce3Np4iCU3dai7/tRp+8qyWX52YBi5mB9EWiI2+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YcI2vf9ruQQx6v//08azbkDY4g89nBJ52oUJlivWUuNziD0nF9epj8WpzJjeg+5ro
         B+nyttHrnfHtND6Lhc0hs5iHBNkqtX2E0RN14Cp66mIFu1SoFsTZBAaDvo+/eg4IHf
         61yXJr7oKmSsFS+V7U26tP6GBmU7Xc2Q4Va+GrDo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xian Wang <dev@xianwang.io>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 043/156] ALSA: hda/ca0132: add quirk for EVGA Z390 DARK
Date:   Wed, 23 Nov 2022 09:50:00 +0100
Message-Id: <20221123084559.468517675@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
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

From: Xian Wang <dev@xianwang.io>

commit 0c423e2ffa7edd3f8f9bcf17ce73fa9c7509b99e upstream.

The Z390 DARK mainboard uses a CA0132 audio controller. The quirk is
needed to enable surround sound and 3.5mm headphone jack handling in
the front audio connector as well as in the rear of the board when in
stereo mode.

Page 97 of the linked manual contains instructions to setup the
controller.

Signed-off-by: Xian Wang <dev@xianwang.io>
Cc: stable@vger.kernel.org
Link: https://www.evga.com/support/manuals/files/131-CS-E399.pdf
Link: https://lore.kernel.org/r/20221104202913.13904-1-dev@xianwang.io
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_ca0132.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -1182,6 +1182,7 @@ static const struct snd_pci_quirk ca0132
 	SND_PCI_QUIRK(0x1458, 0xA026, "Gigabyte G1.Sniper Z97", QUIRK_R3DI),
 	SND_PCI_QUIRK(0x1458, 0xA036, "Gigabyte GA-Z170X-Gaming 7", QUIRK_R3DI),
 	SND_PCI_QUIRK(0x3842, 0x1038, "EVGA X99 Classified", QUIRK_R3DI),
+	SND_PCI_QUIRK(0x3842, 0x1055, "EVGA Z390 DARK", QUIRK_R3DI),
 	SND_PCI_QUIRK(0x1102, 0x0013, "Recon3D", QUIRK_R3D),
 	SND_PCI_QUIRK(0x1102, 0x0018, "Recon3D", QUIRK_R3D),
 	SND_PCI_QUIRK(0x1102, 0x0051, "Sound Blaster AE-5", QUIRK_AE5),


