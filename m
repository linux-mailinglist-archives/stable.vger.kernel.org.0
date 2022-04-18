Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14E455051EF
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234791AbiDRMhY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239367AbiDRMgU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:36:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F31E6220E3;
        Mon, 18 Apr 2022 05:27:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 869E660F0A;
        Mon, 18 Apr 2022 12:27:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56435C385A1;
        Mon, 18 Apr 2022 12:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284859;
        bh=vDqZNWFXVawWrhvaWm2y/fTkPkryjkncxnEkT4TAxYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bSK3GtlFYqC6rwmp/ao7+Z3/wQgAaWL/P/+ywZL1PnUfOW+A1BJhzbtS3dIwnHTBs
         5ETCHdDm/YHEz/AScp6ygDyyJ7QZNA6YZhZJP8/UlsYVNdix3a4GUaYOs8Z6LeHlO9
         4atVlzQ7rbuDtBtazQ52yDV1Set4AzKoNOOlG37s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Zheyu Ma <zheyuma97@gmail.com>
Subject: [PATCH 5.15 030/189] ALSA: echoaudio: Fix the missing snd_card_free() call at probe error
Date:   Mon, 18 Apr 2022 14:10:50 +0200
Message-Id: <20220418121201.370397374@linuxfoundation.org>
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

commit 313c7e57035125cb7533b53ddd0bc7aa562b433c upstream.

The previous cleanup with devres may lead to the incorrect release
orders at the probe error handling due to the devres's nature.  Until
we register the card, snd_card_free() has to be called at first for
releasing the stuff properly when the driver tries to manage and
release the stuff via card->private_free().

This patch fixes it by calling snd_card_free() on the error from the
probe callback using a new helper function.

Fixes: 9c211bf392bb ("ALSA: echoaudio: Allocate resources with device-managed APIs")
Reported-and-tested-by: Zheyu Ma <zheyuma97@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/CAMhUBjm2AdyEZ_-EgexdNDN7SvY4f89=4=FwAL+c0Mg0O+X50A@mail.gmail.com
Link: https://lore.kernel.org/r/20220412093141.8008-3-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/echoaudio/echoaudio.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/sound/pci/echoaudio/echoaudio.c b/sound/pci/echoaudio/echoaudio.c
index 25b012ef5c3e..c70c3ac4e99a 100644
--- a/sound/pci/echoaudio/echoaudio.c
+++ b/sound/pci/echoaudio/echoaudio.c
@@ -1970,8 +1970,8 @@ static int snd_echo_create(struct snd_card *card,
 }
 
 /* constructor */
-static int snd_echo_probe(struct pci_dev *pci,
-			  const struct pci_device_id *pci_id)
+static int __snd_echo_probe(struct pci_dev *pci,
+			    const struct pci_device_id *pci_id)
 {
 	static int dev;
 	struct snd_card *card;
@@ -2139,6 +2139,11 @@ static int snd_echo_probe(struct pci_dev *pci,
 	return 0;
 }
 
+static int snd_echo_probe(struct pci_dev *pci,
+			  const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_echo_probe(pci, pci_id));
+}
 
 
 #if defined(CONFIG_PM_SLEEP)
-- 
2.35.2



