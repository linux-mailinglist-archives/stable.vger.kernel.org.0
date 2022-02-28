Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 964BB4C768C
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 19:04:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238059AbiB1SFG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 13:05:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239773AbiB1SCg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 13:02:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D9FA9D06C;
        Mon, 28 Feb 2022 09:46:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7281B81187;
        Mon, 28 Feb 2022 17:45:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 302FDC340F3;
        Mon, 28 Feb 2022 17:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070344;
        bh=/msaSY+WqBTLpnAYFKfOlGUPi776Si31St0tFMJTiVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TB7Ara9qYqwy1M05bPZ0fzeCIDrS9gFJ+8/3hs42/ypRwQ0Djj5HYfB569MjOd1b5
         nNnkfPbBIZL0rC4kMrnVx6p1KPDKr26A/JhWsI3aF7VtGqLt5Lef4CBfAOclxpa5Cn
         FQ1h5BGfANuElnHQ79NMNWaRykcsg88GwrpDpd9Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matt Roper <matthew.d.roper@intel.com>,
        Swathi Dhanavanthri <swathi.dhanavanthri@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Subject: [PATCH 5.16 075/164] drm/i915/dg2: Print PHY name properly on calibration error
Date:   Mon, 28 Feb 2022 18:23:57 +0100
Message-Id: <20220228172406.853274007@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matt Roper <matthew.d.roper@intel.com>

commit 28adef861233c6fce47372ebd2070b55eaa8e899 upstream.

We need to use phy_name() to convert the PHY value into a human-readable
character in the error message.

Fixes: a6a128116e55 ("drm/i915/dg2: Wait for SNPS PHY calibration during display init")
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Reviewed-by: Swathi Dhanavanthri <swathi.dhanavanthri@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220215163545.2175730-1-matthew.d.roper@intel.com
(cherry picked from commit 84073e568eec7b586b2f6fd5fb2fb08f59edec54)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_snps_phy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_snps_phy.c
+++ b/drivers/gpu/drm/i915/display/intel_snps_phy.c
@@ -34,7 +34,7 @@ void intel_snps_phy_wait_for_calibration
 		if (intel_de_wait_for_clear(dev_priv, ICL_PHY_MISC(phy),
 					    DG2_PHY_DP_TX_ACK_MASK, 25))
 			DRM_ERROR("SNPS PHY %c failed to calibrate after 25ms.\n",
-				  phy);
+				  phy_name(phy));
 	}
 }
 


