Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC12955C23F
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237247AbiF0Lsv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238182AbiF0LsB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:48:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ED5AEE18;
        Mon, 27 Jun 2022 04:39:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE1D3B8111B;
        Mon, 27 Jun 2022 11:39:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C46C3411D;
        Mon, 27 Jun 2022 11:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329992;
        bh=bOp5VjAQsCLXPTeiK/KcZHCpBd/Gx0FO7UrnTTt65Gc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FkR6Q/gWhv+lm59rnXbyOt1AasyBmYjxk0WuG50qWIeeLFlifmhCRJW0kVkKk3I0E
         ezmFrpsBLi2zz/rJzMS8pNpRtze1khQgerqa9ef463VepJYlQDOhBPqAPbvfW23w8x
         7MvgKzzouAdLkGpsDHZxzjHs8iDn3/ICzuIXPEKM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Soham Sen <contact@sohamsen.me>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.18 007/181] ALSA: hda/realtek: Add mute LED quirk for HP Omen laptop
Date:   Mon, 27 Jun 2022 13:19:40 +0200
Message-Id: <20220627111944.773064094@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Soham Sen <contact@sohamsen.me>

commit b2e6b3d9bbb0a59ba7c710cc06e44cc548301f5f upstream.

The HP Omen 15 laptop needs a quirk to toggle the mute LED. It already is implemented for a different variant of the HP Omen laptop so a fixup entry is needed for this variant.

Signed-off-by: Soham Sen <contact@sohamsen.me>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220609181919.45535-1-contact@sohamsen.me
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9074,6 +9074,7 @@ static const struct snd_pci_quirk alc269
 		      ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x8783, "HP ZBook Fury 15 G7 Mobile Workstation",
 		      ALC285_FIXUP_HP_GPIO_AMP_INIT),
+	SND_PCI_QUIRK(0x103c, 0x8787, "HP OMEN 15", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8788, "HP OMEN 15", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x87c8, "HP", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87e5, "HP ProBook 440 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),


