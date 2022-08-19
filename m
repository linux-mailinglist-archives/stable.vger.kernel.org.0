Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86D6E59A13F
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349920AbiHSPuO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 11:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350140AbiHSPtg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 11:49:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A1BB104761;
        Fri, 19 Aug 2022 08:47:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ACFF3B82814;
        Fri, 19 Aug 2022 15:47:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B327C433D6;
        Fri, 19 Aug 2022 15:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924065;
        bh=ec+WUlwlBNEQUkcBaoJZbAaGDOf3aSCfnbsL47325vQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R1IXq8nHJ+4LmnSYIMJnKKHdXka6K0vpj2m3ktn5uRlIICTz2xq/Ra9Hyjb6p+FXn
         p3edIzvbXGiC6Y1k+ZNW+hxoZmGZBLmJGtsLLxoZxmCFmC4KhFC0em0f+84lULw34A
         vChE1wUSFkx3IH1d3F/Q2G5HfB/u5QhWJWtb29P4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phil Elwell <phil@raspberrypi.org>,
        Maxime Ripard <maxime@cerno.tech>
Subject: [PATCH 5.10 043/545] drm/vc4: hdmi: Disable audio if dmas property is present but empty
Date:   Fri, 19 Aug 2022 17:36:53 +0200
Message-Id: <20220819153831.142217593@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phil Elwell <phil@raspberrypi.org>

commit db2b927f8668adf3ac765e0921cd2720f5c04172 upstream.

The dmas property is used to hold the dmaengine channel used for audio
output.

Older device trees were missing that property, so if it's not there we
disable the audio output entirely.

However, some overlays have set an empty value to that property, mostly
to workaround the fact that overlays cannot remove a property. Let's add
a test for that case and if it's empty, let's disable it as well.

Cc: <stable@vger.kernel.org>
Signed-off-by: Phil Elwell <phil@raspberrypi.org>
Link: https://lore.kernel.org/r/20220613144800.326124-18-maxime@cerno.tech
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -1231,12 +1231,12 @@ static int vc4_hdmi_audio_init(struct vc
 	struct snd_soc_card *card = &vc4_hdmi->audio.card;
 	struct device *dev = &vc4_hdmi->pdev->dev;
 	const __be32 *addr;
-	int index;
+	int index, len;
 	int ret;
 
-	if (!of_find_property(dev->of_node, "dmas", NULL)) {
+	if (!of_find_property(dev->of_node, "dmas", &len) || !len) {
 		dev_warn(dev,
-			 "'dmas' DT property is missing, no HDMI audio\n");
+			 "'dmas' DT property is missing or empty, no HDMI audio\n");
 		return 0;
 	}
 


