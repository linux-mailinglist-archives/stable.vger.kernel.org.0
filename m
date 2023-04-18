Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E17446E645F
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbjDRMs3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232052AbjDRMs2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:48:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD9B15A18
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:48:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97759632C7
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:48:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD5DC433D2;
        Tue, 18 Apr 2023 12:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822101;
        bh=MTUNfAsmHbMJAoAT99tu01VGbukSgZfK5ybTOvlMCYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mP5x43tun7CgGFGI3wX4RVc6jTGTyGXwSW8AE1t1wD/bwaWqTKxPjMIOqJl498eK6
         KtCW0nM2Fc1zpNF9R9HlW8xCERK5U6zywacPMRV2mOPz+F77euJukJtHcwWg+1AIba
         ttm0r/snToeCo4vGGlH56yiWlE2fmCgHneKm/MSA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Oswald Buddenhagen <oswald.buddenhagen@gmx.de>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.2 005/139] ALSA: hda/sigmatel: add pin overrides for Intel DP45SG motherboard
Date:   Tue, 18 Apr 2023 14:21:10 +0200
Message-Id: <20230418120313.923182857@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oswald Buddenhagen <oswald.buddenhagen@gmx.de>

commit c17f8fd31700392b1bb9e7b66924333568cb3700 upstream.

Like the other boards from the D*45* series, this one sets up the
outputs not quite correctly.

Signed-off-by: Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230405201220.2197826-1-oswald.buddenhagen@gmx.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/sound/hd-audio/models.rst |    2 +-
 sound/pci/hda/patch_sigmatel.c          |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/Documentation/sound/hd-audio/models.rst
+++ b/Documentation/sound/hd-audio/models.rst
@@ -704,7 +704,7 @@ ref
 no-jd
     BIOS setup but without jack-detection
 intel
-    Intel DG45* mobos
+    Intel D*45* mobos
 dell-m6-amic
     Dell desktops/laptops with analog mics
 dell-m6-dmic
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -1955,6 +1955,8 @@ static const struct snd_pci_quirk stac92
 				"DFI LanParty", STAC_92HD73XX_REF),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_DFI, 0x3101,
 				"DFI LanParty", STAC_92HD73XX_REF),
+	SND_PCI_QUIRK(PCI_VENDOR_ID_INTEL, 0x5001,
+				"Intel DP45SG", STAC_92HD73XX_INTEL),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_INTEL, 0x5002,
 				"Intel DG45ID", STAC_92HD73XX_INTEL),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_INTEL, 0x5003,


