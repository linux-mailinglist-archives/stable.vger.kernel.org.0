Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5285454059E
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346606AbiFGR1Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347114AbiFGRZn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:25:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F2B21091A2;
        Tue,  7 Jun 2022 10:24:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01A5260DDA;
        Tue,  7 Jun 2022 17:24:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13139C385A5;
        Tue,  7 Jun 2022 17:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622644;
        bh=6uPA5McGTpqd5J8zNC48J/r6flQs3dTkxrg0JPGFxGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rm1pHFdFAQbPrjxQe0FcD0+krRCcf6kZ9kwqU7c8guN1hNa1Xh4WbkeFtCp3yqDqP
         bshUblUx9gF5OMCxN1zOE9GQCuD75f/iKWFTGWPo9GwuihXYYovDhU/cOaOO1gR9yq
         yvFLitE4MQS9obslCP7EXF8opJasrkrbNSxRdSKU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 133/452] drm/vc4: txp: Dont set TXP_VSTART_AT_EOF
Date:   Tue,  7 Jun 2022 18:59:50 +0200
Message-Id: <20220607164912.525025973@linuxfoundation.org>
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

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit 234998df929f14d00cbf2f1e81a7facb69fd9266 ]

The TXP_VSTART_AT_EOF will generate a second VSTART signal to the HVS.
However, the HVS waits for VSTART to enable the FIFO and will thus start
filling the FIFO before the start of the frame.

This leads to corruption at the beginning of the first frame, and
content from the previous frame at the beginning of the next frames.

Since one VSTART is enough, let's get rid of it.

Fixes: 008095e065a8 ("drm/vc4: Add support for the transposer block")
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://lore.kernel.org/r/20220328153659.2382206-3-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_txp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vc4/vc4_txp.c b/drivers/gpu/drm/vc4/vc4_txp.c
index d13502ae973d..d4e750cf3c02 100644
--- a/drivers/gpu/drm/vc4/vc4_txp.c
+++ b/drivers/gpu/drm/vc4/vc4_txp.c
@@ -295,7 +295,7 @@ static void vc4_txp_connector_atomic_commit(struct drm_connector *conn,
 	if (WARN_ON(i == ARRAY_SIZE(drm_fmts)))
 		return;
 
-	ctrl = TXP_GO | TXP_VSTART_AT_EOF | TXP_EI |
+	ctrl = TXP_GO | TXP_EI |
 	       VC4_SET_FIELD(0xf, TXP_BYTE_ENABLE) |
 	       VC4_SET_FIELD(txp_fmts[i], TXP_FORMAT);
 
-- 
2.35.1



