Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC9FE594053
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbiHOVEC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245501AbiHOVDN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:03:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7596D51439;
        Mon, 15 Aug 2022 12:14:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C70F2B81115;
        Mon, 15 Aug 2022 19:14:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D18C433D6;
        Mon, 15 Aug 2022 19:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590861;
        bh=ezz1QrZMZah4z8XFs+tXhhTISclPhpkXp32xMw1dyyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JygA0IXLX3e8KrO6mAcd4PQ5Uufe9DnlnfNHenBDGkJyQ3iFp0YqRg1LirhlYN+vI
         WJOKf6RceeEySfhz16in0qH6+XqFdbaRUZ7ww2X0nnB7DYlchzUIdTCwh+2wHCwD20
         3meTnIwMlGyxsXiOkz+BnvpI/gxthUVF6xPD8HM8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dom Cobley <popcornmix@gmail.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0393/1095] drm/vc4: hdmi: Clear unused infoframe packet RAM registers
Date:   Mon, 15 Aug 2022 19:56:32 +0200
Message-Id: <20220815180445.956193355@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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
index 2ff53482d5d1..0fe04b1f9782 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -439,9 +439,11 @@ static void vc4_hdmi_write_infoframe(struct drm_encoder *encoder,
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
@@ -477,6 +479,13 @@ static void vc4_hdmi_write_infoframe(struct drm_encoder *encoder,
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



