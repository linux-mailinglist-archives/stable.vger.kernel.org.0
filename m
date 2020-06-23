Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4A4A206490
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388743AbgFWVXk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:23:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:38252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389970AbgFWUUr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:20:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF3EB206C3;
        Tue, 23 Jun 2020 20:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943647;
        bh=zK/irHUDZK0+XA8nS3vqOsMfHGzH7FbVhWaR9AONVhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g5Th2XgSqHtLNPil1TOiFKIYoURjhfyaiBamqS8dGlmbm4X4OWtpyaUA3E6dQyYvn
         4fcpwVMDt+iwPwt2c2ZqAuD+jzgzVeOj5nX8lFbU3u/jmZipD314CPSf8JSH8bp52+
         NuNyGbUdpDN22o/5yZm0F9GLc/wp+HFlG1LjK9As=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Imre Deak <imre.deak@intel.com>,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 5.7 442/477] drm/i915: Fix AUX power domain toggling across TypeC mode resets
Date:   Tue, 23 Jun 2020 21:57:19 +0200
Message-Id: <20200623195428.429474311@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Imre Deak <imre.deak@intel.com>

commit d96536f0fe699729a0974eb5b65eb0d87cc747e1 upstream.

Make sure to select the port's AUX power domain while holding the TC
port lock. The domain depends on the port's current TC mode, which may
get changed under us if we're not holding the lock.

This was left out from
commit 8c10e2262663 ("drm/i915: Keep the TypeC port mode fixed for detect/AUX transfers")

Cc: <stable@vger.kernel.org> # v5.4+
Signed-off-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: José Roberto de Souza <jose.souza@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200514204553.27193-1-imre.deak@intel.com
(cherry picked from commit ae9b6cfe1352da25931bce3ea4acfd4dc1ac8a85)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/display/intel_dp.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -1343,8 +1343,7 @@ intel_dp_aux_xfer(struct intel_dp *intel
 	bool is_tc_port = intel_phy_is_tc(i915, phy);
 	i915_reg_t ch_ctl, ch_data[5];
 	u32 aux_clock_divider;
-	enum intel_display_power_domain aux_domain =
-		intel_aux_power_domain(intel_dig_port);
+	enum intel_display_power_domain aux_domain;
 	intel_wakeref_t aux_wakeref;
 	intel_wakeref_t pps_wakeref;
 	int i, ret, recv_bytes;
@@ -1359,6 +1358,8 @@ intel_dp_aux_xfer(struct intel_dp *intel
 	if (is_tc_port)
 		intel_tc_port_lock(intel_dig_port);
 
+	aux_domain = intel_aux_power_domain(intel_dig_port);
+
 	aux_wakeref = intel_display_power_get(i915, aux_domain);
 	pps_wakeref = pps_lock(intel_dp);
 


