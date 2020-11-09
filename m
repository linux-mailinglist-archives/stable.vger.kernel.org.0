Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB5F52ABA1F
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732726AbgKINP6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:15:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:42832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731980AbgKINP4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:15:56 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C1CE20663;
        Mon,  9 Nov 2020 13:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927755;
        bh=eQcWH8BzJx5PF0ctMWuildsrnqAXuNgWbmFzXhNLzTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Isss/HVoVx8N0KhT+coHAkzYaHKduBu7DESvmOHYwUR3cGNkzrfop2XnP32CxLTiu
         1pThgAHQdBntoq8yMAin49t1GinSc/Rqiw4qTT9RfBVGCpvdkVqRsV+xakZ88dxpe2
         WO1hniYJma0B5PkEWtQi+jm8UrwIqxftezf1Sx5o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Tomasz Lis <tomasz.lis@intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Francisco Jerez <currojerez@riseup.net>,
        Mathew Alwin <alwin.mathew@intel.com>,
        Mcguire Russell W <russell.w.mcguire@intel.com>,
        Spruit Neil R <neil.r.spruit@intel.com>,
        Zhou Cheng <cheng.zhou@intel.com>,
        Benemelis Mike G <mike.g.benemelis@intel.com>,
        Ayaz A Siddiqui <ayaz.siddiqui@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.9 011/133] drm/i915/gt: Initialize reserved and unspecified MOCS indices
Date:   Mon,  9 Nov 2020 13:54:33 +0100
Message-Id: <20201109125031.264707108@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ayaz A Siddiqui <ayaz.siddiqui@intel.com>

commit 849c0fe9e831dcebea1b46e2237e13f274a8756a upstream.

In order to avoid functional breakage of mis-programmed applications that
have grown to depend on unused MOCS entries, we are programming
those entries to be equal to fully cached ("L3 + LLC") entry.

These reserved and unspecified entries should not be used as they may be
changed to less performant variants with better coherency in the future
if more entries are needed.

v2: As suggested by Lucas De Marchi to utilise __init_mocs_table for
programming default value, setting I915_MOCS_PTE index of tgl_mocs_table
with desired value.

Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Tomasz Lis <tomasz.lis@intel.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Francisco Jerez <currojerez@riseup.net>
Cc: Mathew Alwin <alwin.mathew@intel.com>
Cc: Mcguire Russell W <russell.w.mcguire@intel.com>
Cc: Spruit Neil R <neil.r.spruit@intel.com>
Cc: Zhou Cheng <cheng.zhou@intel.com>
Cc: Benemelis Mike G <mike.g.benemelis@intel.com>

Signed-off-by: Ayaz A Siddiqui <ayaz.siddiqui@intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Acked-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Link: https://patchwork.freedesktop.org/patch/msgid/20200729102539.134731-2-ayaz.siddiqui@intel.com
Cc: stable@vger.kernel.org
(cherry picked from commit 4d8a5cfe3b131f60903949f998c5961cc922e0b0)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gt/intel_mocs.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/i915/gt/intel_mocs.c
+++ b/drivers/gpu/drm/i915/gt/intel_mocs.c
@@ -234,11 +234,17 @@ static const struct drm_i915_mocs_entry
 		   L3_1_UC)
 
 static const struct drm_i915_mocs_entry tgl_mocs_table[] = {
-	/* Base - Error (Reserved for Non-Use) */
-	MOCS_ENTRY(0, 0x0, 0x0),
-	/* Base - Reserved */
-	MOCS_ENTRY(1, 0x0, 0x0),
-
+	/*
+	 * NOTE:
+	 * Reserved and unspecified MOCS indices have been set to (L3 + LCC).
+	 * These reserved entries should never be used, they may be changed
+	 * to low performant variants with better coherency in the future if
+	 * more entries are needed. We are programming index I915_MOCS_PTE(1)
+	 * only, __init_mocs_table() take care to program unused index with
+	 * this entry.
+	 */
+	MOCS_ENTRY(1, LE_3_WB | LE_TC_1_LLC | LE_LRUM(3),
+		   L3_3_WB),
 	GEN11_MOCS_ENTRIES,
 
 	/* Implicitly enable L1 - HDC:L1 + L3 + LLC */


