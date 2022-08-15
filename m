Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C657594949
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243537AbiHOXnb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:43:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354316AbiHOXlw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:41:52 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EBB82C64F;
        Mon, 15 Aug 2022 13:12:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 001B7CE12EB;
        Mon, 15 Aug 2022 20:12:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FBA4C433C1;
        Mon, 15 Aug 2022 20:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594338;
        bh=Wfw8rRoaZ6N/NdQxj2mH6K/qXFAUdGxq9Vm0O0/U+n4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OVQ1igbglSrvhoudwneHyLJWbr2aVKop/xNnAUE7helzN0hCSUyBFWpYuEWo1rddY
         Fu/f42y35EybUfMB4Qx2Ei6lwszlym43zZJTWJiBjCJ17nN7HFewF3Bj+NUAWY7D8c
         iaLotyDVpuaAdLwjgi/xcb1TCGYAgH0ncFCPH8tE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dom Cobley <popcornmix@gmail.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0416/1157] drm/vc4: hdmi: Clear unused infoframe packet RAM registers
Date:   Mon, 15 Aug 2022 19:56:12 +0200
Message-Id: <20220815180456.289106333@linuxfoundation.org>
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

[ Upstream commit b6079d1578dc4b4b8050d613a5449a63def7d1dd ]

Using a hdmi analyser the bytes in packet ram
registers beyond the length were visible in the
infoframes and it flagged the checksum as invalid.

Zeroing unused words of packet RAM avoids this

Fixes: 21317b3fba54 ("drm/vc4: Set up the AVI and SPD infoframes.")
Signed-off-by: Dom Cobley <popcornmix@gmail.com>
Link: https://lore.kernel.org/r/20220613144800.326124-20-maxime@cerno.tech
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index e314e0a4c4c3..ecd49214bd92 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -461,9 +461,11 @@ static void vc4_hdmi_write_infoframe(struct drm_encoder *encoder,
 	const struct vc4_hdmi_register *ram_packet_start =
 		&vc4_hdmi->variant->registers[HDMI_RAM_PACKET_START];
 	u32 packet_reg = ram_packet_start->offset + VC4_HDMI_PACKET_STRIDE * packet_id;
+	u32 packet_reg_next = ram_packet_start->offset +
+		VC4_HDMI_PACKET_STRIDE * (packet_id + 1);
 	void __iomem *base = __vc4_hdmi_get_field_base(vc4_hdmi,
 						       ram_packet_start->reg);
-	uint8_t buffer[VC4_HDMI_PACKET_STRIDE];
+	uint8_t buffer[VC4_HDMI_PACKET_STRIDE] = {};
 	unsigned long flags;
 	ssize_t len, i;
 	int ret;
@@ -499,6 +501,13 @@ static void vc4_hdmi_write_infoframe(struct drm_encoder *encoder,
 		packet_reg += 4;
 	}
 
+	/*
+	 * clear remainder of packet ram as it's included in the
+	 * infoframe and triggers a checksum error on hdmi analyser
+	 */
+	for (; packet_reg < packet_reg_next; packet_reg += 4)
+		writel(0, base + packet_reg);
+
 	HDMI_WRITE(HDMI_RAM_PACKET_CONFIG,
 		   HDMI_READ(HDMI_RAM_PACKET_CONFIG) | BIT(packet_id));
 
-- 
2.35.1



