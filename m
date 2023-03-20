Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FECA6C1827
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232716AbjCTPVH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232815AbjCTPUL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:20:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C60F328E60
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:14:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1AA93B80E55
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:14:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C696C433D2;
        Mon, 20 Mar 2023 15:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325289;
        bh=VKA86dxSzIfz3MBzpKSbFC0jz6kRo8lrjVkHsBRpjpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QptYMLOrWNjEbdWUaRoMMYc45n/i8fu4kvLqewNquW0IOdOI5ADh1pB5KQSDRpivj
         mVJ2RCayi7kBJCEyrwXAfrzni+0nncdo7gzCf+kaNPSsMjFGVaVn+WcuhWKMO/dhKc
         5N/8MQKqG8qrhVdr0B7w9dBszQqZUkogsp7cehno=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Hamidreza H. Fard" <nitocris@posteo.net>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 087/115] ALSA: hda/realtek: Fix the speaker output on Samsung Galaxy Book2 Pro
Date:   Mon, 20 Mar 2023 15:54:59 +0100
Message-Id: <20230320145453.061859781@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
References: <20230320145449.336983711@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hamidreza H. Fard <nitocris@posteo.net>

commit a86e79e3015f5dd8e1b01ccfa49bd5c6e41047a1 upstream.

Samsung Galaxy Book2 Pro (13" 2022 NP930XED-KA1DE) with codec SSID
144d:c868 requires the same workaround for enabling the speaker amp
like other Samsung models with ALC298 code.

Signed-off-by: Hamidreza H. Fard <nitocris@posteo.net>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230307163741.3878-1-nitocris@posteo.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9166,6 +9166,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x144d, 0xc830, "Samsung Galaxy Book Ion (NT950XCJ-X716A)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc832, "Samsung Galaxy Book Flex Alpha (NP730QCJ)", ALC256_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
 	SND_PCI_QUIRK(0x144d, 0xca03, "Samsung Galaxy Book2 Pro 360 (NP930QED)", ALC298_FIXUP_SAMSUNG_AMP),
+	SND_PCI_QUIRK(0x144d, 0xc868, "Samsung Galaxy Book2 Pro (NP930XED)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x1458, 0xfa53, "Gigabyte BXBT-2807", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1462, 0xb120, "MSI Cubi MS-B120", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1462, 0xb171, "Cubi N 8GL (MS-B171)", ALC283_FIXUP_HEADSET_MIC),


