Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F63C608757
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232231AbiJVIAu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232424AbiJVH66 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:58:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D282157881;
        Sat, 22 Oct 2022 00:49:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF76BB82E22;
        Sat, 22 Oct 2022 07:48:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 359DDC433D6;
        Sat, 22 Oct 2022 07:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424922;
        bh=0AaFD66QoCu+aNMC5pc5YET2gdKwWwa6+Akg5ngrniw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AmehfEeTcFg0WS4OwxR2zojA6veqk4affVAwEufd6/vk6FFwrb3eZS0QksGw3F//g
         SgFJ5HdF7Vf0UKyEg1BN8S4d3BQJqJzf6eXkh4CsXo3K1/9VcEdjZN8BBZWdhB5a/C
         mCb91YBUL7bKd1YVcxUAx3RjLkZN3fHQpolPbizs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 297/717] drm/bridge: Avoid uninitialized variable warning
Date:   Sat, 22 Oct 2022 09:22:56 +0200
Message-Id: <20221022072505.578097055@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index c96847fc0ebc..36ca4092c1ab 100644
--- a/drivers/gpu/drm/drm_bridge.c
+++ b/drivers/gpu/drm/drm_bridge.c
@@ -823,8 +823,8 @@ static int select_bus_fmt_recursive(struct drm_bridge *first_bridge,
 				    struct drm_connector_state *conn_state,
 				    u32 out_bus_fmt)
 {
+	unsigned int i, num_in_bus_fmts = 0;
 	struct drm_bridge_state *cur_state;
-	unsigned int num_in_bus_fmts, i;
 	struct drm_bridge *prev_bridge;
 	u32 *in_bus_fmts;
 	int ret;
@@ -945,7 +945,7 @@ drm_atomic_bridge_chain_select_bus_fmts(struct drm_bridge *bridge,
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



