Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1823D505222
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236301AbiDRMlN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240804AbiDRMji (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:39:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94AD42FD;
        Mon, 18 Apr 2022 05:30:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 306D260F04;
        Mon, 18 Apr 2022 12:30:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 161F7C385A1;
        Mon, 18 Apr 2022 12:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285040;
        bh=8OKQIQQZsaln7GT2sWzd5OsKT2yNQHkboQCMYcljvFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MIaPRZItuzOEIGBC76F0w/XnT9GkUCYG3skFS91IcZWt0e/EYqrf8G9r3rVtHr54h
         S1SQ3x9d2yw1Hg75fTjvHl4jkfPpGbegXDNkGqVVsAqJGshJaLMUOAa56wE0cBUY9Z
         xMOs60l6esD8715uvpS3H4HLt714psBC7Ghup3Ik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 055/189] ALSA: nm256: Dont call card private_free at probe error path
Date:   Mon, 18 Apr 2022 14:11:15 +0200
Message-Id: <20220418121202.073042721@linuxfoundation.org>
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

commit f20ae5074dfb38f23b0c07c62bdf8e7254a0acf8 upstream.

The card destructor of nm256 driver does merely stopping the running
streams, and it's superfluous for the probe error handling.  Moreover,
calling this via the previous devres change would lead to another
problem due to the reverse call order.

This patch moves the setup of the private_free callback after the card
registration, so that it can be used only after fully set up.

Fixes: c19935f04784 ("ALSA: nm256: Allocate resources with device-managed APIs")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220412102636.16000-40-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/nm256/nm256.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/nm256/nm256.c b/sound/pci/nm256/nm256.c
index c9c178504959..f99a1e96e923 100644
--- a/sound/pci/nm256/nm256.c
+++ b/sound/pci/nm256/nm256.c
@@ -1573,7 +1573,6 @@ snd_nm256_create(struct snd_card *card, struct pci_dev *pci)
 	chip->coeffs_current = 0;
 
 	snd_nm256_init_chip(chip);
-	card->private_free = snd_nm256_free;
 
 	// pci_set_master(pci); /* needed? */
 	return 0;
@@ -1680,6 +1679,7 @@ static int snd_nm256_probe(struct pci_dev *pci,
 	err = snd_card_register(card);
 	if (err < 0)
 		return err;
+	card->private_free = snd_nm256_free;
 
 	pci_set_drvdata(pci, card);
 	return 0;
-- 
2.35.2



