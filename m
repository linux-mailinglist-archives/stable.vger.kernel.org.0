Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E67156D48D7
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233525AbjDCOcY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233516AbjDCOcW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:32:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F40C7D4F9F
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:32:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E1BC61DF6
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:32:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CD0DC433EF;
        Mon,  3 Apr 2023 14:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532333;
        bh=ouiCdHbcvJCwNwcMmFIaJn5qkXOMMU7ujX97pFCh7rc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yrblSFEWTL9M0UsG1DhveLeTzmn476wimXnSh6LR3uPeTrHfIFgJoHELNGJjqcZAi
         Ewj93U5Ym0pySH6yoP9o7W7BhSedZ5lQqrAx9D9Cte5ZdUmhnzDqKtwkC9K10X99Ck
         d91bUyd+ZFue05nWWtv4pDKoGyr+Sx1yXpJdF9kk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Imre Deak <imre.deak@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 42/99] drm/i915/tc: Fix the ICL PHY ownership check in TC-cold state
Date:   Mon,  3 Apr 2023 16:09:05 +0200
Message-Id: <20230403140404.830099737@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140356.079638751@linuxfoundation.org>
References: <20230403140356.079638751@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Imre Deak <imre.deak@intel.com>

[ Upstream commit 38c583019484f190d5b33f59b8ae810e6b1763c6 ]

The commit renaming icl_tc_phy_is_in_safe_mode() to
icl_tc_phy_take_ownership() didn't flip the function's return value
accordingly, fix this up.

This didn't cause an actual problem besides state check errors, since
the function is only used during HW readout.

Cc: José Roberto de Souza <jose.souza@intel.com>
Fixes: f53979d68a77 ("drm/i915/display/tc: Rename safe_mode functions ownership")
Reviewed-by: José Roberto de Souza <jose.souza@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230316131724.359612-4-imre.deak@intel.com
(cherry picked from commit f2c7959dda614d9b7c6a41510492de39d31705ec)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_tc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_tc.c b/drivers/gpu/drm/i915/display/intel_tc.c
index 0e885440be242..1b5b4d252d5b8 100644
--- a/drivers/gpu/drm/i915/display/intel_tc.c
+++ b/drivers/gpu/drm/i915/display/intel_tc.c
@@ -386,9 +386,9 @@ static bool icl_tc_phy_is_owned(struct intel_digital_port *dig_port)
 				PORT_TX_DFLEXDPCSSS(dig_port->tc_phy_fia));
 	if (val == 0xffffffff) {
 		drm_dbg_kms(&i915->drm,
-			    "Port %s: PHY in TCCOLD, assume safe mode\n",
+			    "Port %s: PHY in TCCOLD, assume not owned\n",
 			    dig_port->tc_port_name);
-		return true;
+		return false;
 	}
 
 	return val & DP_PHY_MODE_STATUS_NOT_SAFE(dig_port->tc_phy_fia_idx);
-- 
2.39.2



