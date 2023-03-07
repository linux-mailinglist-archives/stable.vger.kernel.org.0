Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69BEF6AED08
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbjCGSAq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:00:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232292AbjCGSAF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:00:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 061692E0FC
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:54:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8B68B819BE
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:54:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2605C4339C;
        Tue,  7 Mar 2023 17:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211653;
        bh=Ms3gbSBbMqCSWQcS8gEEyyvP3WZ+LWK6odpq2UfHPTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EVqOZbP1L029gswiGdH9OKriJJQIqWW2+B+RfzxBXSbRFVF8xgTk11mlYgeN+t/k1
         FUb0p38LvXewjwvxowtjGqRQRiXP7xc6aPUC41qB05OdfI0XYGHouv1GZAtKM1FmJm
         pcIOtQnIIQtrMLd/te8NCtOh98dUnExJGtnRX+fw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.2 0890/1001] ALSA: hda/realtek: Add quirk for HP EliteDesk 800 G6 Tower PC
Date:   Tue,  7 Mar 2023 18:01:02 +0100
Message-Id: <20230307170100.572071350@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Łukasz Stelmach <l.stelmach@samsung.com>

commit ea24b9953bcd3889f77a66e7f1d7e86e995dd9c3 upstream.

HP EliteDesk 800 G6 Tower PC (103c:870c) requires a quirk for enabling
headset-mic.

Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
Cc: <stable@vger.kernel.org>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217008
Link: https://lore.kernel.org/r/20230223074749.1026060-1-l.stelmach@samsung.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11617,6 +11617,7 @@ static const struct snd_pci_quirk alc662
 	SND_PCI_QUIRK(0x1028, 0x0698, "Dell", ALC668_FIXUP_DELL_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x069f, "Dell", ALC668_FIXUP_DELL_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x1632, "HP RP5800", ALC662_FIXUP_HP_RP5800),
+	SND_PCI_QUIRK(0x103c, 0x870c, "HP", ALC897_FIXUP_HP_HSMIC_VERB),
 	SND_PCI_QUIRK(0x103c, 0x8719, "HP", ALC897_FIXUP_HP_HSMIC_VERB),
 	SND_PCI_QUIRK(0x103c, 0x873e, "HP", ALC671_FIXUP_HP_HEADSET_MIC2),
 	SND_PCI_QUIRK(0x103c, 0x877e, "HP 288 Pro G6", ALC671_FIXUP_HP_HEADSET_MIC2),


