Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D47FB59474E
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344170AbiHOXn2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354321AbiHOXlx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:41:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93EEC2C65C;
        Mon, 15 Aug 2022 13:12:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E3586077B;
        Mon, 15 Aug 2022 20:12:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 172F1C433C1;
        Mon, 15 Aug 2022 20:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594344;
        bh=AUx0DyP1wpvcM7jw+zKjJqfB5eCKGEC5MqiBsClfykY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bB32JaJZn1KOdcNmZvHvW/+uYW9MiZy9jXMDOVM+zRamHpZY8vWRV3BqH50PAiep+
         HS4S2Z81J1cJ1+Lu+blyxjP/gIyixFukdjlSLp1DoCg75UV1/nohiRhP9sadZPDLcf
         d9URKVT7FaWzGGEXmQ8oyGi3yzlcNJQj1ChJ4A+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dom Cobley <popcornmix@gmail.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0417/1157] drm/vc4: hdmi: Avoid full hdmi audio fifo writes
Date:   Mon, 15 Aug 2022 19:56:13 +0200
Message-Id: <20220815180456.329569159@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Dom Cobley <popcornmix@gmail.com>

[ Upstream commit 1c594eeccf92368177c2e22f1d3ee4933dfb8567 ]

We are getting occasional VC4_HD_MAI_CTL_ERRORF in
HDMI_MAI_CTL which seem to correspond with audio dropouts.

Reduce the threshold where we deassert DREQ to avoid the fifo
overfilling

Fixes: bb7d78568814 ("drm/vc4: Add HDMI audio support")
Signed-off-by: Dom Cobley <popcornmix@gmail.com>
Link: https://lore.kernel.org/r/20220613144800.326124-21-maxime@cerno.tech
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index ecd49214bd92..d0921f832f19 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -1956,10 +1956,10 @@ static int vc4_hdmi_audio_prepare(struct device *dev, void *data,
 
 	/* Set the MAI threshold */
 	HDMI_WRITE(HDMI_MAI_THR,
-		   VC4_SET_FIELD(0x10, VC4_HD_MAI_THR_PANICHIGH) |
-		   VC4_SET_FIELD(0x10, VC4_HD_MAI_THR_PANICLOW) |
-		   VC4_SET_FIELD(0x10, VC4_HD_MAI_THR_DREQHIGH) |
-		   VC4_SET_FIELD(0x10, VC4_HD_MAI_THR_DREQLOW));
+		   VC4_SET_FIELD(0x08, VC4_HD_MAI_THR_PANICHIGH) |
+		   VC4_SET_FIELD(0x08, VC4_HD_MAI_THR_PANICLOW) |
+		   VC4_SET_FIELD(0x06, VC4_HD_MAI_THR_DREQHIGH) |
+		   VC4_SET_FIELD(0x08, VC4_HD_MAI_THR_DREQLOW));
 
 	HDMI_WRITE(HDMI_MAI_CONFIG,
 		   VC4_HDMI_MAI_CONFIG_BIT_REVERSE |
-- 
2.35.1



