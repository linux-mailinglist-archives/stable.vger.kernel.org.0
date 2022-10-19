Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD983603D64
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232253AbiJSJB2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232444AbiJSI7w (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:59:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 168D76AEA9;
        Wed, 19 Oct 2022 01:55:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D03FD617F0;
        Wed, 19 Oct 2022 08:53:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1B72C433D6;
        Wed, 19 Oct 2022 08:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169627;
        bh=OowrNALwkvS4Tcm3QNdrx2jP/lE+fwctiM0D4EOC+ts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RKfn/eXHp9Maka1nkEiw+NQunJlYkT3q9Cw8E8Cg9T69oZLMKCTEIw1PPDlWryZvA
         aYohxiHZwpYpwnQSVkq4+uifVayzBPrAF2prDYRJUt7HVoUIHJBrC6T337jqxPvwUg
         RGfwDxcmmOJXpBo024DYK/BImJgBDrirdG6SwivU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 348/862] drm/bridge: Avoid uninitialized variable warning
Date:   Wed, 19 Oct 2022 10:27:15 +0200
Message-Id: <20221019083305.417150627@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 7d1202738efda60155d98b370b3c70d336be0eea ]

This code works, but technically it uses "num_in_bus_fmts" before it
has been initialized so it leads to static checker warnings and probably
KMEMsan warnings at run time.  Initialize the variable to zero to
silence the warning.

Fixes: f32df58acc68 ("drm/bridge: Add the necessary bits to support bus format negotiation")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/YrrIs3hoGcPVmXc5@kili
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_bridge.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_bridge.c b/drivers/gpu/drm/drm_bridge.c
index 6abf7a2407e9..1545c50fd1c8 100644
--- a/drivers/gpu/drm/drm_bridge.c
+++ b/drivers/gpu/drm/drm_bridge.c
@@ -847,8 +847,8 @@ static int select_bus_fmt_recursive(struct drm_bridge *first_bridge,
 				    struct drm_connector_state *conn_state,
 				    u32 out_bus_fmt)
 {
+	unsigned int i, num_in_bus_fmts = 0;
 	struct drm_bridge_state *cur_state;
-	unsigned int num_in_bus_fmts, i;
 	struct drm_bridge *prev_bridge;
 	u32 *in_bus_fmts;
 	int ret;
@@ -969,7 +969,7 @@ drm_atomic_bridge_chain_select_bus_fmts(struct drm_bridge *bridge,
 	struct drm_connector *conn = conn_state->connector;
 	struct drm_encoder *encoder = bridge->encoder;
 	struct drm_bridge_state *last_bridge_state;
-	unsigned int i, num_out_bus_fmts;
+	unsigned int i, num_out_bus_fmts = 0;
 	struct drm_bridge *last_bridge;
 	u32 *out_bus_fmts;
 	int ret = 0;
-- 
2.35.1



