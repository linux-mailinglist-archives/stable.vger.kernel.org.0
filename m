Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18C70593CA2
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbiHOUN5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:13:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345876AbiHOUJs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:09:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 964C860D1;
        Mon, 15 Aug 2022 11:56:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33AFB6123D;
        Mon, 15 Aug 2022 18:56:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22DA0C433D7;
        Mon, 15 Aug 2022 18:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589775;
        bh=2s6DLnBMZjpDPk2dGSvozIT9Ci6o/Qk7OdSE3YjsmmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BJdO86NdPkkEcOcVxkUo9AOtbTu/00uhfPWBByrsyhB+10JOOn2hcA9To4YWpeJjh
         z+ZUGIY8Bk+XoH8Lhev/5qDXgF7oQkksEEfOI3V+XRDp/0Aoxy88j7Rr8DSKLlFiKA
         Rk3w1LDrKX3VV7oQxcFt+qHWsnwksklW4SJdjcOE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bedant Patnaik <bedant.patnaik@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.18 0045/1095] ALSA: hda/realtek: Add a quirk for HP OMEN 15 (8786) mute LED
Date:   Mon, 15 Aug 2022 19:50:44 +0200
Message-Id: <20220815180431.311522894@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Bedant Patnaik <bedant.patnaik@gmail.com>

commit 30267718fe2d4dbea49015b022f6f1fe16ca31ab upstream.

Board ID 8786 seems to be another variant of the Omen 15 that needs
ALC285_FIXUP_HP_MUTE_LED for working mute LED.

Signed-off-by: Bedant Patnaik <bedant.patnaik@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220809142455.6473-1-bedant.patnaik@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9230,6 +9230,7 @@ static const struct snd_pci_quirk alc269
 		      ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x8783, "HP ZBook Fury 15 G7 Mobile Workstation",
 		      ALC285_FIXUP_HP_GPIO_AMP_INIT),
+	SND_PCI_QUIRK(0x103c, 0x8786, "HP OMEN 15", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8787, "HP OMEN 15", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8788, "HP OMEN 15", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x87c8, "HP", ALC287_FIXUP_HP_GPIO_LED),


