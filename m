Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 946BB505271
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236452AbiDRMou (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240022AbiDRMnf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:43:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B3526561;
        Mon, 18 Apr 2022 05:32:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C872861033;
        Mon, 18 Apr 2022 12:32:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B03CAC385A7;
        Mon, 18 Apr 2022 12:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285140;
        bh=szVwhci6wEG2scB742G2j4/7NAzzTzIVcKJbFqCQBr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f4oavORV4zCVGE/FT/yStBs6cLBuFiBYxeOJYLpdESaPgaJGo023+zI+DUx7KzPuA
         Slq/3U8V9dgwRWCJ41CBK2CzrzIBEYa58bVGU7CNV9U3Y01xjVAGxRzAEKBeo3eMn6
         bc1CWh27jUJkeMeo8uYtJEbx1Nqx5YQt2/eGd7c0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 088/189] ALSA: ad1889: Fix the missing snd_card_free() call at probe error
Date:   Mon, 18 Apr 2022 14:11:48 +0200
Message-Id: <20220418121203.005286638@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit a8e84a5da18e6d786540aa4ceb6f969d5f1a441d ]

The previous cleanup with devres may lead to the incorrect release
orders at the probe error handling due to the devres's nature.  Until
we register the card, snd_card_free() has to be called at first for
releasing the stuff properly when the driver tries to manage and
release the stuff via card->private_free().

This patch fixes it by calling snd_card_free() on the error from the
probe callback using a new helper function.

Fixes: 567f58754109 ("ALSA: ad1889: Allocate resources with device-managed APIs")
Link: https://lore.kernel.org/r/20220412102636.16000-4-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/ad1889.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/sound/pci/ad1889.c b/sound/pci/ad1889.c
index bba4dae8dcc7..50e30704bf6f 100644
--- a/sound/pci/ad1889.c
+++ b/sound/pci/ad1889.c
@@ -844,8 +844,8 @@ snd_ad1889_create(struct snd_card *card, struct pci_dev *pci)
 }
 
 static int
-snd_ad1889_probe(struct pci_dev *pci,
-		 const struct pci_device_id *pci_id)
+__snd_ad1889_probe(struct pci_dev *pci,
+		   const struct pci_device_id *pci_id)
 {
 	int err;
 	static int devno;
@@ -904,6 +904,12 @@ snd_ad1889_probe(struct pci_dev *pci,
 	return 0;
 }
 
+static int snd_ad1889_probe(struct pci_dev *pci,
+			    const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_ad1889_probe(pci, pci_id));
+}
+
 static const struct pci_device_id snd_ad1889_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_ANALOG_DEVICES, PCI_DEVICE_ID_AD1889JS) },
 	{ 0, },
-- 
2.35.1



