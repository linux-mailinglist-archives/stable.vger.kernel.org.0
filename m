Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16DFE579D2E
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241744AbiGSMsC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237982AbiGSMqt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:46:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D6A48BABA;
        Tue, 19 Jul 2022 05:18:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F271617D6;
        Tue, 19 Jul 2022 12:18:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3417C341C6;
        Tue, 19 Jul 2022 12:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233111;
        bh=xOYMziX2QG4wm2a/EwKtOEu7/+/i9JFOR3PM4c+yByU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pIzCJNJqwdB1NGExuPoneqmhY+gLesAK4UNfMZ8aCYl/tswqidiHimoj/1PpLC5zm
         x9RN4i45g9MO2VtjPxLIbmP2ovtqEzY5lC8BYcl4SVwOpo2IX9RgyoqlKBBAJ4U2FJ
         fEx7HRmgcQui0QtiSY5JMuC1rtr23OA4bm4I2ylY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Meng Tang <tangmeng@uniontech.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.18 010/231] ALSA: hda/realtek - Fix headset mic problem for a HP machine with alc671
Date:   Tue, 19 Jul 2022 13:51:35 +0200
Message-Id: <20220719114714.983953157@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
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

commit dbe75d314748e08fc6e4576d153d8a69621ee5ca upstream.

On a HP 288 Pro G6, the front mic could not be detected.In order to
get it working, the pin configuration needs to be set correctly, and
the ALC671_FIXUP_HP_HEADSET_MIC2 fixup needs to be applied.

Signed-off-by: Meng Tang <tangmeng@uniontech.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220712092222.21738-1-tangmeng@uniontech.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11271,6 +11271,7 @@ static const struct snd_pci_quirk alc662
 	SND_PCI_QUIRK(0x103c, 0x1632, "HP RP5800", ALC662_FIXUP_HP_RP5800),
 	SND_PCI_QUIRK(0x103c, 0x8719, "HP", ALC897_FIXUP_HP_HSMIC_VERB),
 	SND_PCI_QUIRK(0x103c, 0x873e, "HP", ALC671_FIXUP_HP_HEADSET_MIC2),
+	SND_PCI_QUIRK(0x103c, 0x877e, "HP 288 Pro G6", ALC671_FIXUP_HP_HEADSET_MIC2),
 	SND_PCI_QUIRK(0x103c, 0x885f, "HP 288 Pro G8", ALC671_FIXUP_HP_HEADSET_MIC2),
 	SND_PCI_QUIRK(0x1043, 0x1080, "Asus UX501VW", ALC668_FIXUP_HEADSET_MODE),
 	SND_PCI_QUIRK(0x1043, 0x11cd, "Asus N550", ALC662_FIXUP_ASUS_Nx50),


