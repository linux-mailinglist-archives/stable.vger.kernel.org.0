Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E66A85406BE
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346415AbiFGRiL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:38:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347833AbiFGRfu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:35:50 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0D9E110985;
        Tue,  7 Jun 2022 10:31:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5562BCE23D2;
        Tue,  7 Jun 2022 17:31:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EFE5C385A5;
        Tue,  7 Jun 2022 17:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623108;
        bh=2k//yvMXHuXRxoye9Uc9bkuApkOo3mD6RdJCNGJe7NE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0CHpR38abb5BAlstR0/45csYjuXIGTJaw1Cd4D3hJSFdrxzTLCPXGETaMAgaru7J+
         qFmwjieSWnRzxltIAGSZ8h5WPnRJ+EyIidYs9lFNjM9x8oACsruhTi3MhVtM+Gj8oJ
         K01rjPb+bdXwruieTZT7kIHTk3i+glhcMMc+s0IE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 299/452] ASoC: atmel-classd: Remove endianness flag on class d component
Date:   Tue,  7 Jun 2022 19:02:36 +0200
Message-Id: <20220607164917.467415042@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 0104d52a6a69b06b0e8167f7c1247e8c76aca070 ]

The endianness flag should have been removed when the driver was
ported across from having both a CODEC and CPU side component, to
just having a CPU component and using the dummy for the CODEC. The
endianness flag is used to indicate that the device is completely
ambivalent to the endianness of the data, typically due to the
endianness being lost over the hardware link (ie. the link defines
bit ordering). It's usage didn't have any effect when the driver
had both a CPU and CODEC component, since the union of those equals
the CPU side settings, but now causes the driver to falsely report
it supports big endian. Correct this by removing the flag.

Fixes: 1dfdbe73ccf9 ("ASoC: atmel-classd: remove codec component")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20220504170905.332415-4-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/atmel/atmel-classd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/soc/atmel/atmel-classd.c b/sound/soc/atmel/atmel-classd.c
index b1a28a9382fb..f91a0e728ed5 100644
--- a/sound/soc/atmel/atmel-classd.c
+++ b/sound/soc/atmel/atmel-classd.c
@@ -458,7 +458,6 @@ static const struct snd_soc_component_driver atmel_classd_cpu_dai_component = {
 	.num_controls		= ARRAY_SIZE(atmel_classd_snd_controls),
 	.idle_bias_on		= 1,
 	.use_pmdown_time	= 1,
-	.endianness		= 1,
 };
 
 /* ASoC sound card */
-- 
2.35.1



