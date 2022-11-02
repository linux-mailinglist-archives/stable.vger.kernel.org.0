Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 967DB6157B5
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:37:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbiKBChM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbiKBChL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:37:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A61FF029
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:37:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07622616DB
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:37:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A57A7C433D6;
        Wed,  2 Nov 2022 02:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667356630;
        bh=PmT+Nhu3GZ1BMSohdHz1nFkzoOuzc5Rd/5AJeNpG6F4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=08M89U2o2HaFoUytMJC/+wJ5h7Ry1iO/c3BLQL2cVeopZiQRcXtpAb0AfYvZaiRlj
         0Tm0+03yF0x3wmgdVWvBoBMkN4RzpB+Jnnykei37qDGcUPaRWsjYSf4gc0oTBu0w1J
         FdzhctUiOQgmp8omDBpheqOMJAS34/Z1alv0q/A4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Stefan Binding <sbinding@opensource.cirrus.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.0 007/240] ALSA: hda/realtek: Add quirk for ASUS Zenbook using CS35L41
Date:   Wed,  2 Nov 2022 03:29:42 +0100
Message-Id: <20221102022111.574547594@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
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

From: Stefan Binding <sbinding@opensource.cirrus.com>

commit 491a4ccd8a0258392900c80c6b2b622c7115fc23 upstream.

This Asus Zenbook laptop use Realtek HDA codec combined with
2xCS35L41 Amplifiers using SPI with External Boost.

Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20221018121506.2561397-1-sbinding@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9405,6 +9405,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1043, 0x1ccd, "ASUS X555UB", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1d42, "ASUS Zephyrus G14 2022", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x1d4e, "ASUS TM420", ALC256_FIXUP_ASUS_HPE),
+	SND_PCI_QUIRK(0x1043, 0x1e02, "ASUS UX3402", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1e11, "ASUS Zephyrus G15", ALC289_FIXUP_ASUS_GA502),
 	SND_PCI_QUIRK(0x1043, 0x1e51, "ASUS Zephyrus M15", ALC294_FIXUP_ASUS_GU502_PINS),
 	SND_PCI_QUIRK(0x1043, 0x1e5e, "ASUS ROG Strix G513", ALC294_FIXUP_ASUS_G513_PINS),


