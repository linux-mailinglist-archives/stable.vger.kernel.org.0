Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33FA76AEEC4
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232528AbjCGSQG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:16:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232499AbjCGSPC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:15:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 730FFA72B7
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:10:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1232961535
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:10:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 134BCC433EF;
        Tue,  7 Mar 2023 18:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212632;
        bh=8hJ55BCbh1IOEga8OqCilZcE3HN/oCJbQsgibwR1Chg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zerMG8gWGe6VvVIGlTcEG77s11pHR46M/+3XUqmA1RaZqwW17xweEFz8Oiu117gg4
         MZoIcse2VgQ9LPLEdpYsLW97VGnacZkUoaeB/GeiehoPnhQckX2hckqEIosUJmhT/A
         dNMyXbSQ5uNxPaoSAL+TR6LZH5VLB+XDxGHT0kXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alex Elder <elder@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 216/885] net: ipa: generic command param fix
Date:   Tue,  7 Mar 2023 17:52:30 +0100
Message-Id: <20230307170011.467164359@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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



