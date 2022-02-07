Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47C2C4ABCC8
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:50:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387115AbiBGLjS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:39:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385888AbiBGLc6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:32:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77FBDC043181;
        Mon,  7 Feb 2022 03:32:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15FD560A69;
        Mon,  7 Feb 2022 11:32:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC07C004E1;
        Mon,  7 Feb 2022 11:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233576;
        bh=u8o5PCQAyIhvn8HqQIszupSztvY2NwO4h4QsnvWbks0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ze/sdS+0Ua3L8CxKh6A3Dw2ziDX1/Iujdvz32+6NJX0Wqhh2CpBhuvRvM2jgNwpGW
         RvAtqkW7yJApCyfgocg/45SUUtk8DsmSRTyjqyqyzCD/F7gIY0wNIFeWeSCG+//i9D
         q8M7vVhCrK9ez4iF+ELSP0ZEmezi8d42mn8JIVIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Imre Deak <imre.deak@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Chia-Lin Kao <acelan.kao@canonical.com>
Subject: [PATCH 5.16 023/126] drm/i915/adlp: Fix TypeC PHY-ready status readout
Date:   Mon,  7 Feb 2022 12:05:54 +0100
Message-Id: <20220207103804.958489222@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103804.053675072@linuxfoundation.org>
References: <20220207103804.053675072@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Imre Deak <imre.deak@intel.com>

commit 3c6f13ad723e7206f03bb2752b01d18202b7fc9d upstream.

The TCSS_DDI_STATUS register is indexed by tc_port not by the FIA port
index, fix this up. This only caused an issue on TC#3/4 ports in legacy
mode, as in all other cases the two indices either match (on TC#1/2) or
the TCSS_DDI_STATUS_READY flag is set regardless of something being
connected or not (on TC#1/2/3/4 in dp-alt and tbt-alt modes).

Reported-and-tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
Fixes: 55ce306c2aa1 ("drm/i915/adl_p: Implement TC sequences")
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/4698
Cc: José Roberto de Souza <jose.souza@intel.com>
Cc: <stable@vger.kernel.org> # v5.14+
Signed-off-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: José Roberto de Souza <jose.souza@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220126104356.2022975-1-imre.deak@intel.com
(cherry picked from commit 516b33460c5bee78b2055637b0547bdb0e6af754)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_tc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_tc.c
+++ b/drivers/gpu/drm/i915/display/intel_tc.c
@@ -345,10 +345,11 @@ static bool icl_tc_phy_status_complete(s
 static bool adl_tc_phy_status_complete(struct intel_digital_port *dig_port)
 {
 	struct drm_i915_private *i915 = to_i915(dig_port->base.base.dev);
+	enum tc_port tc_port = intel_port_to_tc(i915, dig_port->base.port);
 	struct intel_uncore *uncore = &i915->uncore;
 	u32 val;
 
-	val = intel_uncore_read(uncore, TCSS_DDI_STATUS(dig_port->tc_phy_fia_idx));
+	val = intel_uncore_read(uncore, TCSS_DDI_STATUS(tc_port));
 	if (val == 0xffffffff) {
 		drm_dbg_kms(&i915->drm,
 			    "Port %s: PHY in TCCOLD, assuming not complete\n",


