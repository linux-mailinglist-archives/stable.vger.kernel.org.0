Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1F0E615A09
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:23:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbiKBDXW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:23:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiKBDXU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:23:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA883252B3
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:23:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58E60617CF
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:23:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE036C433D6;
        Wed,  2 Nov 2022 03:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667359398;
        bh=7LkCTAninmfFpIxAIk7/jT3XL+LB4L53/4jtsZkCglo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=angAN/7nZFTqSe/KhbCtsmjFCLSIB2eOqiJ3+v3U5mWJDax4QEVPRHGjYjskTUUyS
         /wCQ9fdqeyZ2o+MsKYS9w2kKlK5L8eYQepdaSzDPGJ9/I5nMcXrADVYoWcvpD+DU4g
         TNuDCPUsy/b52iU9wY5PRrbV05/vkmfMZ0dFzOgU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <error27@gmail.com>,
        llvm@lists.linux.dev, Nathan Huckleberry <nhuck@google.com>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 32/64] drm/msm: Fix return type of mdp4_lvds_connector_mode_valid
Date:   Wed,  2 Nov 2022 03:33:58 +0100
Message-Id: <20221102022052.855744412@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022051.821538553@linuxfoundation.org>
References: <20221102022051.821538553@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Huckleberry <nhuck@google.com>

[ Upstream commit 0b33a33bd15d5bab73b87152b220a8d0153a4587 ]

The mode_valid field in drm_connector_helper_funcs is expected to be of
type:
enum drm_mode_status (* mode_valid) (struct drm_connector *connector,
                                     struct drm_display_mode *mode);

The mismatched return type breaks forward edge kCFI since the underlying
function definition does not match the function hook definition.

The return type of mdp4_lvds_connector_mode_valid should be changed from
int to enum drm_mode_status.

Reported-by: Dan Carpenter <error27@gmail.com>
Link: https://github.com/ClangBuiltLinux/linux/issues/1703
Cc: llvm@lists.linux.dev
Signed-off-by: Nathan Huckleberry <nhuck@google.com>
Fixes: 3e87599b68e7 ("drm/msm/mdp4: add LVDS panel support")
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Patchwork: https://patchwork.freedesktop.org/patch/502878/
Link: https://lore.kernel.org/r/20220913205551.155128-1-nhuck@google.com
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/mdp4/mdp4_lvds_connector.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/mdp4/mdp4_lvds_connector.c b/drivers/gpu/drm/msm/disp/mdp4/mdp4_lvds_connector.c
index 9262ed2dc8c3..bdcc3e91bf88 100644
--- a/drivers/gpu/drm/msm/disp/mdp4/mdp4_lvds_connector.c
+++ b/drivers/gpu/drm/msm/disp/mdp4/mdp4_lvds_connector.c
@@ -61,8 +61,9 @@ static int mdp4_lvds_connector_get_modes(struct drm_connector *connector)
 	return ret;
 }
 
-static int mdp4_lvds_connector_mode_valid(struct drm_connector *connector,
-				 struct drm_display_mode *mode)
+static enum drm_mode_status
+mdp4_lvds_connector_mode_valid(struct drm_connector *connector,
+			       struct drm_display_mode *mode)
 {
 	struct mdp4_lvds_connector *mdp4_lvds_connector =
 			to_mdp4_lvds_connector(connector);
-- 
2.35.1



