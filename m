Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C05585050C6
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238848AbiDRM3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239283AbiDRM2P (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:28:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D80701EEDC;
        Mon, 18 Apr 2022 05:21:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3159260F0C;
        Mon, 18 Apr 2022 12:21:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C7DC385A1;
        Mon, 18 Apr 2022 12:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284493;
        bh=p7NdsMGXXKY2Y4BdmKFIYeZ2BS38rKxgfbm27drUnCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C13KDllqz9UFfVKIeYzjIgzs6DI/9qRO4Eagu+HMzBy3I6DW8vcfZvPz38+Xm3ja7
         0fEq+VB3vQ5DCFNMVASiIxS4lWycqOXn1qnPLtHaG17bLLe4DzJ266d0+6Z4/kVyS/
         Y6aXHrExXJ/XCctszav3xoAP8rC/kE39zrDaPMx8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 109/219] ALSA: mtpav: Dont call card private_free at probe error path
Date:   Mon, 18 Apr 2022 14:11:18 +0200
Message-Id: <20220418121209.950400644@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
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

[ Upstream commit 4fb27190879b82e48ce89a56e9d6c04437dbc065 ]

The card destructor of nm256 driver does merely stopping the running
timer, and it's superfluous for the probe error handling.  Moreover,
calling this via the previous devres change would lead to another
problem due to the reverse call order.

This patch moves the setup of the private_free callback after the card
registration, so that it can be used only after fully set up.

Fixes: aa92050f10f0 ("ALSA: mtpav: Allocate resources with device-managed APIs")
Link: https://lore.kernel.org/r/20220412102636.16000-39-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/drivers/mtpav.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/drivers/mtpav.c b/sound/drivers/mtpav.c
index 11235baaf6fa..f212f233ea61 100644
--- a/sound/drivers/mtpav.c
+++ b/sound/drivers/mtpav.c
@@ -693,8 +693,6 @@ static int snd_mtpav_probe(struct platform_device *dev)
 	mtp_card->outmidihwport = 0xffffffff;
 	timer_setup(&mtp_card->timer, snd_mtpav_output_timer, 0);
 
-	card->private_free = snd_mtpav_free;
-
 	err = snd_mtpav_get_RAWMIDI(mtp_card);
 	if (err < 0)
 		return err;
@@ -716,6 +714,8 @@ static int snd_mtpav_probe(struct platform_device *dev)
 	if (err < 0)
 		return err;
 
+	card->private_free = snd_mtpav_free;
+
 	platform_set_drvdata(dev, card);
 	printk(KERN_INFO "Motu MidiTimePiece on parallel port irq: %d ioport: 0x%lx\n", irq, port);
 	return 0;
-- 
2.35.1



