Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70FD85361CE
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 14:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240528AbiE0MH4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 08:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353649AbiE0MGI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 08:06:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D3581666BE;
        Fri, 27 May 2022 04:55:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C21861CD6;
        Fri, 27 May 2022 11:55:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4988BC385A9;
        Fri, 27 May 2022 11:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653652506;
        bh=RUEsyhJFnaOVYv98/ybfm3mKHtkusHDBD7ScaWxPpOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QptRGjrppCetVetN43rf6sotoIFqxWkmxqAl29ojQEEJu7JB3fR0M2B8Wwa1QT7Xe
         K4hZ9YWCVdbefGRufXcM1lOPHEz0emQvoAzb0qQgZt6GJtRyAsPnb2EFM6ehe8qO7L
         NdGv/hg0/vVV3SvoBIp6HSEuzLsStSlpWD4SbU44=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edward Matijevic <motolav@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 163/163] ALSA: ctxfi: Add SB046x PCI ID
Date:   Fri, 27 May 2022 10:50:43 +0200
Message-Id: <20220527084850.931243828@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084828.156494029@linuxfoundation.org>
References: <20220527084828.156494029@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Edward Matijevic <motolav@gmail.com>

commit 1b073ebb174d0c7109b438e0a5eb4495137803ec upstream.

Adds the PCI ID for X-Fi cards sold under the Platnum and XtremeMusic names

Before: snd_ctxfi 0000:05:05.0: chip 20K1 model Unknown (1102:0021) is found
After: snd_ctxfi 0000:05:05.0: chip 20K1 model SB046x (1102:0021) is found

[ This is only about defining the model name string, and the rest is
  handled just like before, as a default unknown device.
  Edward confirmed that the stuff has been working fine -- tiwai ]

Signed-off-by: Edward Matijevic <motolav@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/cae7d1a4-8bd9-7dfe-7427-db7e766f7272@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/ctxfi/ctatc.c      |    2 ++
 sound/pci/ctxfi/cthardware.h |    3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/sound/pci/ctxfi/ctatc.c
+++ b/sound/pci/ctxfi/ctatc.c
@@ -36,6 +36,7 @@
 			    | ((IEC958_AES3_CON_FS_48000) << 24))
 
 static const struct snd_pci_quirk subsys_20k1_list[] = {
+	SND_PCI_QUIRK(PCI_VENDOR_ID_CREATIVE, 0x0021, "SB046x", CTSB046X),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_CREATIVE, 0x0022, "SB055x", CTSB055X),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_CREATIVE, 0x002f, "SB055x", CTSB055X),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_CREATIVE, 0x0029, "SB073x", CTSB073X),
@@ -64,6 +65,7 @@ static const struct snd_pci_quirk subsys
 
 static const char *ct_subsys_name[NUM_CTCARDS] = {
 	/* 20k1 models */
+	[CTSB046X]	= "SB046x",
 	[CTSB055X]	= "SB055x",
 	[CTSB073X]	= "SB073x",
 	[CTUAA]		= "UAA",
--- a/sound/pci/ctxfi/cthardware.h
+++ b/sound/pci/ctxfi/cthardware.h
@@ -26,8 +26,9 @@ enum CHIPTYP {
 
 enum CTCARDS {
 	/* 20k1 models */
+	CTSB046X,
+	CT20K1_MODEL_FIRST = CTSB046X,
 	CTSB055X,
-	CT20K1_MODEL_FIRST = CTSB055X,
 	CTSB073X,
 	CTUAA,
 	CT20K1_UNKNOWN,


