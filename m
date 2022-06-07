Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76507541943
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378964AbiFGVT7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381428AbiFGVRn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:17:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4BB0222A51;
        Tue,  7 Jun 2022 11:58:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C711C6159D;
        Tue,  7 Jun 2022 18:58:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF814C385A5;
        Tue,  7 Jun 2022 18:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628336;
        bh=h6OqCUeDOUqyQBLL56rhlWhklL1em65k+Cw8UX3FKp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AF/vRRsZgW0Koo0XmYlWo51j9tWtlJzGIpwbg9OREI2gKEUF6egltAfTHR9Wa5PJ8
         cSFzkjGI2GpzxHrFf5z6/tg4K/YQj5+QXGeSAXPMta7wL8Ktha4fvgZao9pPKiCixE
         5A67SuczA8ndd9XPgSF4zXGY5cyCZ8V3jP5f4KOA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 293/879] drm/vc4: txp: Dont set TXP_VSTART_AT_EOF
Date:   Tue,  7 Jun 2022 18:56:51 +0200
Message-Id: <20220607165011.352932984@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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
index 9809ca3e2945..ace2d03649ba 100644
--- a/drivers/gpu/drm/vc4/vc4_txp.c
+++ b/drivers/gpu/drm/vc4/vc4_txp.c
@@ -298,7 +298,7 @@ static void vc4_txp_connector_atomic_commit(struct drm_connector *conn,
 	if (WARN_ON(i == ARRAY_SIZE(drm_fmts)))
 		return;
 
-	ctrl = TXP_GO | TXP_VSTART_AT_EOF | TXP_EI |
+	ctrl = TXP_GO | TXP_EI |
 	       VC4_SET_FIELD(0xf, TXP_BYTE_ENABLE) |
 	       VC4_SET_FIELD(txp_fmts[i], TXP_FORMAT);
 
-- 
2.35.1



