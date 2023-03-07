Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 088D86AE987
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbjCGRZN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:25:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231409AbjCGRYo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:24:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A9808E3E1
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:20:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9CA0614DF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:20:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDA09C433A0;
        Tue,  7 Mar 2023 17:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209604;
        bh=8hJ55BCbh1IOEga8OqCilZcE3HN/oCJbQsgibwR1Chg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tyxHbS57DjHX2121RmN/FXCJsj8e3Bla3vqUcl+u89duI1HGDNAf3C/Z5JT3puWrS
         rmW4v/GSDz3nTm7iK7bUXXPfMVwAh045idr0knnwPSYmpIQillBUoOjT1YJWUt2fqp
         u/S7pwa6uV4HbY03eQFZL1c8sEQ0bpacVhhX5UyU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alex Elder <elder@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0273/1001] net: ipa: generic command param fix
Date:   Tue,  7 Mar 2023 17:50:45 +0100
Message-Id: <20230307170033.528228784@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Elder <elder@linaro.org>

[ Upstream commit 2df181f09c961377a55510a864216d48d787fe49 ]

Starting at IPA v4.11, the GSI_GENERIC_COMMAND GSI register got a
new PARAMS field.  The code that encodes a value into that field
sets it unconditionally, which is wrong.

We currently only provide 0 as the field's value, so this error has
no real effect.  Still, it's a bug, so let's fix it.

Fix an (unrelated) incorrect comment as well.  Fields in the
ERROR_LOG GSI register actually *are* defined for IPA versions
prior to v3.5.1.

Fixes: fe68c43ce388 ("net: ipa: support enhanced channel flow control")
Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/gsi.c     | 3 ++-
 drivers/net/ipa/gsi_reg.h | 1 -
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index bea2da1c4c51d..f1a3938294866 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1666,7 +1666,8 @@ static int gsi_generic_command(struct gsi *gsi, u32 channel_id,
 	val = u32_encode_bits(opcode, GENERIC_OPCODE_FMASK);
 	val |= u32_encode_bits(channel_id, GENERIC_CHID_FMASK);
 	val |= u32_encode_bits(GSI_EE_MODEM, GENERIC_EE_FMASK);
-	val |= u32_encode_bits(params, GENERIC_PARAMS_FMASK);
+	if (gsi->version >= IPA_VERSION_4_11)
+		val |= u32_encode_bits(params, GENERIC_PARAMS_FMASK);
 
 	timeout = !gsi_command(gsi, GSI_GENERIC_CMD_OFFSET, val);
 
diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index 3763359f208f7..e65f2f055cfff 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -372,7 +372,6 @@ enum gsi_general_id {
 #define GSI_ERROR_LOG_OFFSET \
 			(0x0001f200 + 0x4000 * GSI_EE_AP)
 
-/* Fields below are present for IPA v3.5.1 and above */
 #define ERR_ARG3_FMASK			GENMASK(3, 0)
 #define ERR_ARG2_FMASK			GENMASK(7, 4)
 #define ERR_ARG1_FMASK			GENMASK(11, 8)
-- 
2.39.2



