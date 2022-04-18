Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCB7E505026
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238203AbiDRMVz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238337AbiDRMV2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:21:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E36A81C107;
        Mon, 18 Apr 2022 05:17:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7909CB80ED1;
        Mon, 18 Apr 2022 12:17:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1FAFC385A8;
        Mon, 18 Apr 2022 12:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284244;
        bh=mbkGRJei19FeSvQ7nvbV2M3t8MbJ7JywBOUTGXyzuPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B65ZyMGx5WfZ3GNnS69jDy4VEyCTj9WOLTfWwzNfdhMokSfOLXLInLZ5f3KOZd/X5
         nBCzqt151rm4MkiS2CmaE9EF96XwgP0dq6YdxAlqp35fWqPuLFXJpp+jRa/67UY9oT
         gMomvZ/BPZRkWK8ZAqgo9i9eWKbMW4RxuTPUGekg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.17 051/219] ALSA: rme96: Fix the missing snd_card_free() call at probe error
Date:   Mon, 18 Apr 2022 14:10:20 +0200
Message-Id: <20220418121206.489897084@linuxfoundation.org>
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

commit 93b884f8d82f08c7af542703a724cc23cd2d5bfc upstream.

The previous cleanup with devres may lead to the incorrect release
orders at the probe error handling due to the devres's nature.  Until
we register the card, snd_card_free() has to be called at first for
releasing the stuff properly when the driver tries to manage and
release the stuff via card->private_free().

This patch fixes it by calling snd_card_free() on the error from the
probe callback using a new helper function.

Fixes: df06df7cc997 ("ALSA: rme96: Allocate resources with device-managed APIs")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220412102636.16000-24-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/rme96.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/sound/pci/rme96.c
+++ b/sound/pci/rme96.c
@@ -2430,8 +2430,8 @@ static void snd_rme96_card_free(struct s
 }
 
 static int
-snd_rme96_probe(struct pci_dev *pci,
-		const struct pci_device_id *pci_id)
+__snd_rme96_probe(struct pci_dev *pci,
+		  const struct pci_device_id *pci_id)
 {
 	static int dev;
 	struct rme96 *rme96;
@@ -2498,6 +2498,12 @@ snd_rme96_probe(struct pci_dev *pci,
 	return 0;
 }
 
+static int snd_rme96_probe(struct pci_dev *pci,
+			   const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_rme96_probe(pci, pci_id));
+}
+
 static struct pci_driver rme96_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = snd_rme96_ids,


