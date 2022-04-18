Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA215051D4
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239548AbiDRMki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240038AbiDRMif (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:38:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE0B27149;
        Mon, 18 Apr 2022 05:29:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4867CB80ED7;
        Mon, 18 Apr 2022 12:29:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DDAAC385A1;
        Mon, 18 Apr 2022 12:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284947;
        bh=VeEhEUrliP6/o3JwmIDWYWdQAVOhcne8xo41rXksrYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kOojLEsszTdW42LnKfRZwWVolcuKdWcsW7I49o0Gc1HwpjIa5wf1MlnWSMZHzm3sJ
         R61cdKtW+9FR/tcw1/tsLCjDGZTY1uk2moaHsP5kns0xj6t5J+5RYNtBEgVCQnKlG1
         zJboIygTMUt8mkaiUzHCRRmedmTsfWgXJM58uFZg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 051/189] ALSA: sc6000: Fix the missing snd_card_free() call at probe error
Date:   Mon, 18 Apr 2022 14:11:11 +0200
Message-Id: <20220418121201.961188407@linuxfoundation.org>
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

commit d72458071150b802940204950d0d462ea3c913b1 upstream.

The previous cleanup with devres may lead to the incorrect release
orders at the probe error handling due to the devres's nature.  Until
we register the card, snd_card_free() has to be called at first for
releasing the stuff properly when the driver tries to manage and
release the stuff via card->private_free().

This patch fixes it by calling snd_card_free() on the error from the
probe callback using a new helper function.

Fixes: 111601ff76e9 ("ALSA: sc6000: Allocate resources with device-managed APIs")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220412102636.16000-3-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/isa/sc6000.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/sound/isa/sc6000.c b/sound/isa/sc6000.c
index 26ab7ff80768..60398fced046 100644
--- a/sound/isa/sc6000.c
+++ b/sound/isa/sc6000.c
@@ -537,7 +537,7 @@ static void snd_sc6000_free(struct snd_card *card)
 		sc6000_setup_board(vport, 0);
 }
 
-static int snd_sc6000_probe(struct device *devptr, unsigned int dev)
+static int __snd_sc6000_probe(struct device *devptr, unsigned int dev)
 {
 	static const int possible_irqs[] = { 5, 7, 9, 10, 11, -1 };
 	static const int possible_dmas[] = { 1, 3, 0, -1 };
@@ -662,6 +662,11 @@ static int snd_sc6000_probe(struct device *devptr, unsigned int dev)
 	return 0;
 }
 
+static int snd_sc6000_probe(struct device *devptr, unsigned int dev)
+{
+	return snd_card_free_on_error(devptr, __snd_sc6000_probe(devptr, dev));
+}
+
 static struct isa_driver snd_sc6000_driver = {
 	.match		= snd_sc6000_match,
 	.probe		= snd_sc6000_probe,
-- 
2.35.2



