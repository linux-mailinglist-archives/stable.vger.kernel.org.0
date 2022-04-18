Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0389C505076
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238388AbiDRMZf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238659AbiDRMYq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:24:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DCE9201BA;
        Mon, 18 Apr 2022 05:19:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6A4660F01;
        Mon, 18 Apr 2022 12:19:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0DD4C385A7;
        Mon, 18 Apr 2022 12:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284363;
        bh=Ax4pNkg7lo0baEl4IIg+lzBbn4lt6rQz3Gz0GRLZcU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JAJymVk9C+nJCZ1BUwAfHP0B/hjT/FEn087iBr3oM4Z6xwjpa8Pc7oQFLFazY5Whb
         fwIDDlLPx+WE7/Sy+Oob05f4vqsiGyxDkRCbWFlP7n+NRLodkR7ve8y4VuwzQYPSTg
         lHhSJlYtnypQeI1H/hQrJJjyTyBRn0qXUuj7OjZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.17 049/219] ALSA: rme32: Fix the missing snd_card_free() call at probe error
Date:   Mon, 18 Apr 2022 14:10:18 +0200
Message-Id: <20220418121206.352410845@linuxfoundation.org>
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

commit 55d2d046b23b9bcb907f6b3e38e52113d55085eb upstream.

The previous cleanup with devres may lead to the incorrect release
orders at the probe error handling due to the devres's nature.  Until
we register the card, snd_card_free() has to be called at first for
releasing the stuff properly when the driver tries to manage and
release the stuff via card->private_free().

This patch fixes it by calling snd_card_free() on the error from the
probe callback using a new helper function.

Fixes: 102e6156ded2 ("ALSA: rme32: Allocate resources with device-managed APIs")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220412102636.16000-23-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/rme32.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/sound/pci/rme32.c
+++ b/sound/pci/rme32.c
@@ -1875,7 +1875,7 @@ static void snd_rme32_card_free(struct s
 }
 
 static int
-snd_rme32_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
+__snd_rme32_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
 {
 	static int dev;
 	struct rme32 *rme32;
@@ -1927,6 +1927,12 @@ snd_rme32_probe(struct pci_dev *pci, con
 	return 0;
 }
 
+static int
+snd_rme32_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_rme32_probe(pci, pci_id));
+}
+
 static struct pci_driver rme32_driver = {
 	.name =		KBUILD_MODNAME,
 	.id_table =	snd_rme32_ids,


