Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0E9C4ABBA1
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:39:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384632AbiBGL3a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:29:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383001AbiBGLVX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:21:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E8E4C0401F6;
        Mon,  7 Feb 2022 03:21:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0405EB811A6;
        Mon,  7 Feb 2022 11:20:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A781C004E1;
        Mon,  7 Feb 2022 11:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232849;
        bh=vVdceyXEfR+rT7SfufXa4EHqMBTrDKZdT9JBResE4go=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x/a9/swCttZNdleNhadRqDOwum9+7RBVDMxHaKJefHTvV361CuGY4muSCn+Gc9xuQ
         eHPJhXrVno8MH7pS6L00nJP7VecdOTOeKQl/OCPLA95aM0tVWgul6YQp3tUcIar6ym
         /R1qaEuWg4Wtkoq8M54Q7SHvsGmvoYp58jTJSgAU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christian Lachner <gladiac@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 11/74] ALSA: hda/realtek: Fix silent output on Gigabyte X570S Aorus Master (newer chipset)
Date:   Mon,  7 Feb 2022 12:06:09 +0100
Message-Id: <20220207103757.601747900@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103757.232676988@linuxfoundation.org>
References: <20220207103757.232676988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Lachner <gladiac@gmail.com>

commit 41a8601302ecbe704ac970552c33dc942300fc37 upstream.

Newer versions of the X570 Master come with a newer revision of the
mainboard chipset - the X570S. These boards have the same ALC1220 codec
but seem to initialize the codec with a different parameter in Coef 0x7
which causes the output audio to be very low. We therefore write a
known-good value to Coef 0x7 to fix that. As the value is the exact same
as on the other X570(non-S) boards the same quirk-function can be shared
between both generations.

This commit adds the Gigabyte X570S Aorus Master to the list of boards
using the ALC1220_FIXUP_GB_X570 quirk. This fixes both, the silent output
and the no-audio after reboot from windows problems.

This work has been tested by the folks over at the level1techs forum here:
https://forum.level1techs.com/t/has-anybody-gotten-audio-working-in-linux-on-aorus-x570-master/154072

Signed-off-by: Christian Lachner <gladiac@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220129113243.93068-3-gladiac@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2171,6 +2171,7 @@ static void alc1220_fixup_gb_x570(struct
 {
 	static const hda_nid_t conn1[] = { 0x0c };
 	static const struct coef_fw gb_x570_coefs[] = {
+		WRITE_COEF(0x07, 0x03c0),
 		WRITE_COEF(0x1a, 0x01c1),
 		WRITE_COEF(0x1b, 0x0202),
 		WRITE_COEF(0x43, 0x3005),
@@ -2598,6 +2599,7 @@ static const struct snd_pci_quirk alc882
 	SND_PCI_QUIRK(0x1458, 0xa0b8, "Gigabyte AZ370-Gaming", ALC1220_FIXUP_GB_DUAL_CODECS),
 	SND_PCI_QUIRK(0x1458, 0xa0cd, "Gigabyte X570 Aorus Master", ALC1220_FIXUP_GB_X570),
 	SND_PCI_QUIRK(0x1458, 0xa0ce, "Gigabyte X570 Aorus Xtreme", ALC1220_FIXUP_CLEVO_P950),
+	SND_PCI_QUIRK(0x1458, 0xa0d5, "Gigabyte X570S Aorus Master", ALC1220_FIXUP_GB_X570),
 	SND_PCI_QUIRK(0x1462, 0x11f7, "MSI-GE63", ALC1220_FIXUP_CLEVO_P950),
 	SND_PCI_QUIRK(0x1462, 0x1228, "MSI-GP63", ALC1220_FIXUP_CLEVO_P950),
 	SND_PCI_QUIRK(0x1462, 0x1229, "MSI-GP73", ALC1220_FIXUP_CLEVO_P950),


