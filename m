Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8376B50500A
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238362AbiDRMUm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238160AbiDRMT5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:19:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE7B91AD9C;
        Mon, 18 Apr 2022 05:16:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F31C60EDF;
        Mon, 18 Apr 2022 12:16:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47C93C385A1;
        Mon, 18 Apr 2022 12:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284209;
        bh=74BnZDQ6arq8Tyt0CHAppsvliPfC01X6stj9t8QbstY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cKcCdpyz923EpBdw/QRg7Wvg+8ZsMnQKtQWw5TZ7nNlmgxgo3gmcWq6SznP1DERZ+
         v1XxGwZDIASRE/gwBOuOtGecoHEp2uKDfiQZjmahfihTou+WJ/TPhpzEF/TZK5j1P9
         +07IXLhTaQsvvV97gOP8+Xjt7mktbXe5Gj4SPE7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.17 037/219] ALSA: galaxy: Fix the missing snd_card_free() call at probe error
Date:   Mon, 18 Apr 2022 14:10:06 +0200
Message-Id: <20220418121205.537119920@linuxfoundation.org>
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

commit 10b1881a97be240126891cb384bd3bc1869f52d8 upstream.

The previous cleanup with devres may lead to the incorrect release
orders at the probe error handling due to the devres's nature.  Until
we register the card, snd_card_free() has to be called at first for
releasing the stuff properly when the driver tries to manage and
release the stuff via card->private_free().

This patch fixes it by calling snd_card_free() on the error from the
probe callback using a new helper function.

Fixes: 35a245ec0619 ("ALSA: galaxy: Allocate resources with device-managed APIs")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220412102636.16000-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/isa/galaxy/galaxy.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/sound/isa/galaxy/galaxy.c
+++ b/sound/isa/galaxy/galaxy.c
@@ -478,7 +478,7 @@ static void snd_galaxy_free(struct snd_c
 		galaxy_set_config(galaxy, galaxy->config);
 }
 
-static int snd_galaxy_probe(struct device *dev, unsigned int n)
+static int __snd_galaxy_probe(struct device *dev, unsigned int n)
 {
 	struct snd_galaxy *galaxy;
 	struct snd_wss *chip;
@@ -598,6 +598,11 @@ static int snd_galaxy_probe(struct devic
 	return 0;
 }
 
+static int snd_galaxy_probe(struct device *dev, unsigned int n)
+{
+	return snd_card_free_on_error(dev, __snd_galaxy_probe(dev, n));
+}
+
 static struct isa_driver snd_galaxy_driver = {
 	.match		= snd_galaxy_match,
 	.probe		= snd_galaxy_probe,


