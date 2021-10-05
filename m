Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5D7421DB3
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 06:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbhJEExj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 00:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbhJEExi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 00:53:38 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE62EC061745;
        Mon,  4 Oct 2021 21:51:48 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 133so18669627pgb.1;
        Mon, 04 Oct 2021 21:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HlT+qPxq8BW16CD3WxCEivqANKNeA3Ze9bwiVjEu7RU=;
        b=h0L6CAhkmDAYAkkyvgyNwSEe3hzwtC5qTeefKSuAe79FOblmBqpmRBnnlseij1M0Cu
         ySHcpwZ37+H3g7gyVBnrPfhJVXm+5tNKEIRWyCFXHhJHu1kiAVrVbxEVUPZN8pB+blQo
         mMsuZEIpPT33eb77QvJgFSOmEsUlcd7Z4G05roeZsAMY1YW0Bvx0F7l4gaY6m/lOG8Sp
         gyncUPjmyrqT6hAIXpQIyspAPa8PqUIC3RuZPFbyXr5bB4QYu4Yo+xZQ0QquJ8Hv05Gp
         XTxQQHlbuTYDwZCZfKc8DApBR7hrqA1DC0/5Z0agXLNguXUbRNU4QsD9L+SDcM/IuaJ4
         a1/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HlT+qPxq8BW16CD3WxCEivqANKNeA3Ze9bwiVjEu7RU=;
        b=fN2eH8raouZ5t/3lFNVPEO0LFlV+cfOg7sAW57VT7wP3ktW9m7vpAh+sZl37kqbg0+
         NznRqchSBmN0La1b+yO3BPTsPlRNNGJUAlvOhenfWLeS1drXWtTCt8GH3heNwscOd7Z+
         UNjfDdanTrfunxKJTHSygfM0/w2PKOhMQQx3SMlVpQ8DEuKZcK3/AvX+xdRu6uxetZEO
         hM8ThnDJ0/klm2H6wHPK4FBdJKW0mrDzVobS+ajvZ9tGDDaJysDS7DijmGZ+Lu+CZ8L0
         rvhFA7p6VrwrAY5mhOU9Iuvxhbdj0SPHmBlv563NRxUqr+zHm11+ZsH3CJXE0o9pTSHb
         6RNQ==
X-Gm-Message-State: AOAM533W8fI1vs6tV4T2ECPOmaXe6eI/FQGKeeSG7KtbkHhaynEbLpSo
        qrClF5p3NBWK3kw+oqW+Zj3N5SHIFTx8ZQ==
X-Google-Smtp-Source: ABdhPJwOSoFMWIVbP/Nim01A7wy1OzrwqNnRurL5C9jchujynRvUj3Qo3IP6Y97RvyNDFfmUNLPRhw==
X-Received: by 2002:a63:d80c:: with SMTP id b12mr13967193pgh.331.1633409508508;
        Mon, 04 Oct 2021 21:51:48 -0700 (PDT)
Received: from unconquered.home.aehallh.com (24-113-252-168.wavecable.com. [24.113.252.168])
        by smtp.gmail.com with ESMTPSA id x11sm10087483pfh.75.2021.10.04.21.51.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 21:51:48 -0700 (PDT)
From:   "Zephaniah E. Loss-Cutler-Hull" <zephaniah@gmail.com>
To:     alsa-devel@alsa-project.org
Cc:     linux-kernel@vger.kernel.org,
        "Zephaniah E. Loss-Cutler-Hull" <zephaniah@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH] ALSA: hda/realtek - Fix silent output on Gigabyte B550 Aorus Elite AX v2
Date:   Mon,  4 Oct 2021 21:51:34 -0700
Message-Id: <20211005045134.1429877-1-zephaniah@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The Gigabyte B550 Aorus Elite AX v2 motherboard with ALC1220 codec
requires a similar workaround for Clevo laptops to enforce the DAC/mixer
connection path.  Set up a quirk entry for that.

This is the same workaround as the Gigabyta X570 boards also on the
quirk list.

Signed-off-by: Zephaniah E. Loss-Cutler-Hull <zephaniah@gmail.com>
Cc: <stable@vger.kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 4407f7da57c4..ec5b6eed62e2 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2517,6 +2517,7 @@ static const struct snd_pci_quirk alc882_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1458, 0xa0b8, "Gigabyte AZ370-Gaming", ALC1220_FIXUP_GB_DUAL_CODECS),
 	SND_PCI_QUIRK(0x1458, 0xa0cd, "Gigabyte X570 Aorus Master", ALC1220_FIXUP_CLEVO_P950),
 	SND_PCI_QUIRK(0x1458, 0xa0ce, "Gigabyte X570 Aorus Xtreme", ALC1220_FIXUP_CLEVO_P950),
+	SND_PCI_QUIRK(0x1458, 0xa0cf, "Gigabyte B550 Aorus Elite AX v2", ALC1220_FIXUP_CLEVO_P950),
 	SND_PCI_QUIRK(0x1462, 0x11f7, "MSI-GE63", ALC1220_FIXUP_CLEVO_P950),
 	SND_PCI_QUIRK(0x1462, 0x1228, "MSI-GP63", ALC1220_FIXUP_CLEVO_P950),
 	SND_PCI_QUIRK(0x1462, 0x1229, "MSI-GP73", ALC1220_FIXUP_CLEVO_P950),
-- 
2.33.0

