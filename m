Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26C84521827
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233776AbiEJNdd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243878AbiEJNcT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:32:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C6413D157;
        Tue, 10 May 2022 06:23:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D1E3B81DA5;
        Tue, 10 May 2022 13:23:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA217C385C2;
        Tue, 10 May 2022 13:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188979;
        bh=Ym8GxnnVBZBQ9TUgzbGFvGfJY+zRyIlodEKpAVlkL4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tuKkf6KQ6HxakeuSVg8f82KQWfHJhxBci/unvxvIZjnfjuNKBHJJ7dne7DtrfGJkf
         o/82vaK7lNFw1TbaOXt3fl/lgXlwSVcs9Y2PFNUiJHDv0pAdA6R3nhfTEm80GrD7ZJ
         kzvXss3QT5jHhmh1pHm9Lcd/X8/5t1L0LdyXeIcI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sascha Hauer <sha@pengutronix.de>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 24/52] ASoC: dmaengine: Restore NULL prepare_slave_config() callback
Date:   Tue, 10 May 2022 15:07:53 +0200
Message-Id: <20220510130730.558634508@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130729.852544477@linuxfoundation.org>
References: <20220510130729.852544477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>

commit 660564fc9a92a893a14f255be434f7ea0b967901 upstream.

As pointed out by Sascha Hauer, this patch changes:
if (pmc->config && !pcm->config->prepare_slave_config)
        <do nothing>
to:
if (pmc->config && !pcm->config->prepare_slave_config)
        snd_dmaengine_pcm_prepare_slave_config()

This breaks the drivers that do not need a call to
dmaengine_slave_config(). Drivers that still need to call
snd_dmaengine_pcm_prepare_slave_config(), but have a NULL
pcm->config->prepare_slave_config should use
snd_dmaengine_pcm_prepare_slave_config() as their prepare_slave_config
callback.

Fixes: 9a1e13440a4f ("ASoC: dmaengine: do not use a NULL prepare_slave_config() callback")
Reported-by: Sascha Hauer <sha@pengutronix.de>
Signed-off-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Link: https://lore.kernel.org/r/20220421125403.2180824-1-codrin.ciubotariu@microchip.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/soc-generic-dmaengine-pcm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/sound/soc/soc-generic-dmaengine-pcm.c
+++ b/sound/soc/soc-generic-dmaengine-pcm.c
@@ -91,10 +91,10 @@ static int dmaengine_pcm_hw_params(struc
 
 	memset(&slave_config, 0, sizeof(slave_config));
 
-	if (pcm->config && pcm->config->prepare_slave_config)
-		prepare_slave_config = pcm->config->prepare_slave_config;
-	else
+	if (!pcm->config)
 		prepare_slave_config = snd_dmaengine_pcm_prepare_slave_config;
+	else
+		prepare_slave_config = pcm->config->prepare_slave_config;
 
 	if (prepare_slave_config) {
 		ret = prepare_slave_config(substream, params, &slave_config);


