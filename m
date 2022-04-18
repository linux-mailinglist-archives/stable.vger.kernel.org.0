Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF1B5051A4
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239389AbiDRMge (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239174AbiDRMfV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:35:21 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B05E21821;
        Mon, 18 Apr 2022 05:27:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 674B2CE1089;
        Mon, 18 Apr 2022 12:27:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6343C385A1;
        Mon, 18 Apr 2022 12:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284848;
        bh=9g0ffNttQ/CCU1aCA1csKeDT0dlixVyyniDgSiSms8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fGxUlx+3xBhBSeVBo3zC3YqPc6ge0GJKdUlXuJzGaqG+fJ8cdJSYxx7tZvufdo4Zp
         ChciN1xYiwPH42D2Xu02p1Yfd7WKIo96u+uTdbDVpPDSs0iMwL4vnN+MIbhBdqacJ6
         ee7Vme/tOf6Z5EHDq9NPxx1K7ZPzw9bdEQKWY/mM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 027/189] ALSA: cmipci: Fix the missing snd_card_free() call at probe error
Date:   Mon, 18 Apr 2022 14:10:47 +0200
Message-Id: <20220418121201.286313927@linuxfoundation.org>
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

commit a59396b1c11823c69c31621198c04def17f3a869 upstream.

The previous cleanup with devres may lead to the incorrect release
orders at the probe error handling due to the devres's nature.  Until
we register the card, snd_card_free() has to be called at first for
releasing the stuff properly when the driver tries to manage and
release the stuff via card->private_free().

This patch fixes it by calling snd_card_free() manually on the error
from the probe callback.

Fixes: 87e082ad84a7 ("ALSA: cmipci: Allocate resources with device-managed APIs")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220412102636.16000-33-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/cmipci.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/sound/pci/cmipci.c
+++ b/sound/pci/cmipci.c
@@ -3249,15 +3249,19 @@ static int snd_cmipci_probe(struct pci_d
 
 	err = snd_cmipci_create(card, pci, dev);
 	if (err < 0)
-		return err;
+		goto error;
 
 	err = snd_card_register(card);
 	if (err < 0)
-		return err;
+		goto error;
 
 	pci_set_drvdata(pci, card);
 	dev++;
 	return 0;
+
+ error:
+	snd_card_free(card);
+	return err;
 }
 
 #ifdef CONFIG_PM_SLEEP


