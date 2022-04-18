Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E55D550506F
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbiDRMZP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238616AbiDRMYf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:24:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2F5C1BEAB;
        Mon, 18 Apr 2022 05:19:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9787FB80EC1;
        Mon, 18 Apr 2022 12:19:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0589BC385A7;
        Mon, 18 Apr 2022 12:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284354;
        bh=T3l+nBRWE/HRSu/F8b10tw5kEWQkayHiXDidjQZgrxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gmxA2PJ6kYLrdlfHTI5l27ycXd0o3FuIQYDYEatUsL8MhnjyQ5o0z1bCVp0UGnQ+V
         zhGo2Q89eDat6zIjAdHnnNpMuCqQ11G7JiU7IEFOWyDo1OFRqTl+0XiTbTj/aa6LEG
         M0U/G34ptJEaK5XH4yN2meZHmBqUi7CmtbQALUzc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.17 046/219] ALSA: maestro3: Fix the missing snd_card_free() call at probe error
Date:   Mon, 18 Apr 2022 14:10:15 +0200
Message-Id: <20220418121206.142253368@linuxfoundation.org>
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

commit ae86bf5c2a8d81418eadf1c31dd9253b609e3093 upstream.

The previous cleanup with devres may lead to the incorrect release
orders at the probe error handling due to the devres's nature.  Until
we register the card, snd_card_free() has to be called at first for
releasing the stuff properly when the driver tries to manage and
release the stuff via card->private_free().

This patch fixes it by calling snd_card_free() on the error from the
probe callback using a new helper function.

Fixes: 5c0939253c3c ("ALSA: maestro3: Allocate resources with device-managed APIs")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220412102636.16000-21-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/maestro3.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/sound/pci/maestro3.c
+++ b/sound/pci/maestro3.c
@@ -2637,7 +2637,7 @@ snd_m3_create(struct snd_card *card, str
 /*
  */
 static int
-snd_m3_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
+__snd_m3_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
 {
 	static int dev;
 	struct snd_card *card;
@@ -2702,6 +2702,12 @@ snd_m3_probe(struct pci_dev *pci, const
 	return 0;
 }
 
+static int
+snd_m3_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_m3_probe(pci, pci_id));
+}
+
 static struct pci_driver m3_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = snd_m3_ids,


