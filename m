Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3B0206498
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389942AbgFWVYM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:24:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:37404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389377AbgFWUUL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:20:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63C0D2064B;
        Tue, 23 Jun 2020 20:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943610;
        bh=8TvrV79sT5HOZ52kyWhpR5dn/H/pge/c5cNWQhpxhfI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R5Kqk0JDtT5U3azT8H51tu0KOyLyOMZd2I4b1cITIqfeceB/Q42gx0Um3N7iwZuiy
         yUhrSYWN2SUgY09JYkipkpUmZL1ozAoLlukbnsnDh/nwID1bZ0q2TUrkiiFkehc/EF
         RvcRbvb34wpddt01JhD86oEcypiXWewGuZF/OkH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Swathi Dhanavanthri <swathi.dhanavanthri@intel.com>,
        Rafael Antognolli <rafael.antognolli@intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.7 459/477] drm/i915/tgl: Make Wa_14010229206 permanent
Date:   Tue, 23 Jun 2020 21:57:36 +0200
Message-Id: <20200623195429.244980729@linuxfoundation.org>
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

From: Swathi Dhanavanthri <swathi.dhanavanthri@intel.com>

commit 63d0f3ea8ebb67160eca281320d255c72b0cb51a upstream.

This workaround now applies to all steppings, not just A0.
Wa_1409085225 is a temporary A0-only W/A however it is
identical to Wa_14010229206 and hence the combined workaround
is made permanent.
Bspec: 52890

Signed-off-by: Swathi Dhanavanthri <swathi.dhanavanthri@intel.com>
Tested-by: Rafael Antognolli <rafael.antognolli@intel.com>
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
[mattrope: added missing blank line]
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200326234955.16155-1-swathi.dhanavanthri@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gt/intel_workarounds.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -1620,12 +1620,6 @@ rcs_engine_wa_init(struct intel_engine_c
 			    GEN7_FF_THREAD_MODE,
 			    GEN12_FF_TESSELATION_DOP_GATE_DISABLE);
 
-		/*
-		 * Wa_1409085225:tgl
-		 * Wa_14010229206:tgl
-		 */
-		wa_masked_en(wal, GEN9_ROW_CHICKEN4, GEN12_DISABLE_TDL_PUSH);
-
 		/* Wa_1408615072:tgl */
 		wa_write_or(wal, UNSLICE_UNIT_LEVEL_CLKGATE2,
 			    VSUNIT_CLKGATE_DIS_TGL);
@@ -1643,6 +1637,12 @@ rcs_engine_wa_init(struct intel_engine_c
 		wa_masked_en(wal,
 			     GEN9_CS_DEBUG_MODE1,
 			     FF_DOP_CLOCK_GATE_DISABLE);
+
+		/*
+		 * Wa_1409085225:tgl
+		 * Wa_14010229206:tgl
+		 */
+		wa_masked_en(wal, GEN9_ROW_CHICKEN4, GEN12_DISABLE_TDL_PUSH);
 	}
 
 	if (IS_GEN(i915, 11)) {


