Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CEEA191055
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729788AbgCXN1O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:27:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:52738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729786AbgCXN1O (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:27:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B1D620870;
        Tue, 24 Mar 2020 13:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585056433;
        bh=3984FJ/Y0G+HBnmQiHPCk795zG/qltzzD458eTtcCSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=huJvEfzDiSerDXbGThQhYLTRWf1DI91tLw7YfUyvLHifXkGkOY0Ho/QZn4+EAjpQB
         4PpmC/a8mW+hLHLxc8AlCcQikoRt0kPPZyzG8lILk10Ym3dDeExYspdYpIZQxB1zr2
         Y3aW8ok7pVYsb5jadl0j17oAiSS6bG6J/7kR20WE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.5 115/119] drm/i915: Handle all MCR ranges
Date:   Tue, 24 Mar 2020 14:11:40 +0100
Message-Id: <20200324130819.097547034@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130808.041360967@linuxfoundation.org>
References: <20200324130808.041360967@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matt Roper <matthew.d.roper@intel.com>

commit fe8b7085cac3b0db03cdbb26d9309bc27325df0a upstream.

The bspec documents multiple MCR ranges; make sure they're all captured
by the driver.

Bspec: 13991, 52079
Fixes: 592a7c5e082e ("drm/i915: Extend non readable mcr range")
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200311162300.1838847-2-matthew.d.roper@intel.com
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
(cherry picked from commit 415d1269975d3fc21c13a6ae8de7b5fe0e6febb1)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gt/intel_workarounds.c |   25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -1504,15 +1504,34 @@ err_obj:
 	return ERR_PTR(err);
 }
 
+static const struct {
+	u32 start;
+	u32 end;
+} mcr_ranges_gen8[] = {
+	{ .start = 0x5500, .end = 0x55ff },
+	{ .start = 0x7000, .end = 0x7fff },
+	{ .start = 0x9400, .end = 0x97ff },
+	{ .start = 0xb000, .end = 0xb3ff },
+	{ .start = 0xe000, .end = 0xe7ff },
+	{},
+};
+
 static bool mcr_range(struct drm_i915_private *i915, u32 offset)
 {
+	int i;
+
+	if (INTEL_GEN(i915) < 8)
+		return false;
+
 	/*
-	 * Registers in this range are affected by the MCR selector
+	 * Registers in these ranges are affected by the MCR selector
 	 * which only controls CPU initiated MMIO. Routing does not
 	 * work for CS access so we cannot verify them on this path.
 	 */
-	if (INTEL_GEN(i915) >= 8 && (offset >= 0xb000 && offset <= 0xb4ff))
-		return true;
+	for (i = 0; mcr_ranges_gen8[i].start; i++)
+		if (offset >= mcr_ranges_gen8[i].start &&
+		    offset <= mcr_ranges_gen8[i].end)
+			return true;
 
 	return false;
 }


