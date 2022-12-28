Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42984658483
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235366AbiL1Q5o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:57:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235396AbiL1Q44 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:56:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E356FEF
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:53:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9ECDB81707
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:53:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3556EC433D2;
        Wed, 28 Dec 2022 16:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246400;
        bh=4TVCKaRbeWhAEp0UoBc2bJjHD+aZbl8euEkU9XFh75U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JU2O9Fmrf+kX3FzFf23NMtfXyZtO1ewkBbDRfNrtFyFwTMrkGvLBnX1VRvzaVsEnL
         /PMld5TGifoikB3/vCwZz1rGi4wtsMC3itjUM5KDHPtyN9ZxbjCU/jibQKKMBqNOVy
         r7FZXfAr90LyXu9uTAoBsP8EWG0DN6+ZsY1qiJ70=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jiao Zhou <jiaozhou@google.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.0 1030/1073] ALSA: hda/hdmi: Add HP Device 0x8711 to force connect list
Date:   Wed, 28 Dec 2022 15:43:38 +0100
Message-Id: <20221228144356.169891248@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Jiao Zhou <jiaozhou@google.com>

commit 31b573946ea55e1ea0e08ae8e83bcf879b30f83a upstream.

HDMI audio is not working on the HP EliteDesk 800 G6 because the pin is
unconnected. This issue can be resolved by using the 'hdajackretask'
tool to override the unconnected pin to force it to connect.

Signed-off-by: Jiao Zhou <jiaozhou@google.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20221206185311.3669950-1-jiaozhou@google.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_hdmi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1976,6 +1976,7 @@ static int hdmi_add_cvt(struct hda_codec
 static const struct snd_pci_quirk force_connect_list[] = {
 	SND_PCI_QUIRK(0x103c, 0x870f, "HP", 1),
 	SND_PCI_QUIRK(0x103c, 0x871a, "HP", 1),
+	SND_PCI_QUIRK(0x103c, 0x8711, "HP", 1),
 	SND_PCI_QUIRK(0x1462, 0xec94, "MS-7C94", 1),
 	SND_PCI_QUIRK(0x8086, 0x2081, "Intel NUC 10", 1),
 	{}


