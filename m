Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 034462062DF
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392408AbgFWVIs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:08:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:56580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403776AbgFWUed (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:34:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 974F4206C3;
        Tue, 23 Jun 2020 20:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944473;
        bh=YySmSrVLeNy4genNaIZGwum5q8gYdmuRjgWpMDygdmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GS6mokeI00d5XWVdBrl0j6qPxt/FrQWfJZRXNRRpwzVmNXxa/jcUBzVzeS1ZioSYI
         ah0wOflPsuaCIs3rGAWcBEVthqQeRsJ7crEEHnkAv7Wu2xhfgNwp+1Aw9iXHHfiUmv
         5J6fAnm9iUZXO58gWXh3ScAuCVcJy6k6qsHUsqUM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 5.4 300/314] drm/i915: Whitelist context-local timestamp in the gen9 cmdparser
Date:   Tue, 23 Jun 2020 21:58:15 +0200
Message-Id: <20200623195353.305420025@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 273500ae71711c040d258a7b3f4b6f44c368fff2 upstream.

Allow batch buffers to read their own _local_ cumulative HW runtime of
their logical context.

Fixes: 0f2f39758341 ("drm/i915: Add gen9 BCS cmdparsing")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: <stable@vger.kernel.org> # v5.4+
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200601161942.30854-1-chris@chris-wilson.co.uk
(cherry picked from commit f9496520df11de00fbafc3cbd693b9570d600ab3)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_cmd_parser.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/i915/i915_cmd_parser.c
+++ b/drivers/gpu/drm/i915/i915_cmd_parser.c
@@ -572,6 +572,9 @@ struct drm_i915_reg_descriptor {
 #define REG32(_reg, ...) \
 	{ .addr = (_reg), __VA_ARGS__ }
 
+#define REG32_IDX(_reg, idx) \
+	{ .addr = _reg(idx) }
+
 /*
  * Convenience macro for adding 64-bit registers.
  *
@@ -669,6 +672,7 @@ static const struct drm_i915_reg_descrip
 	REG64_IDX(RING_TIMESTAMP, BSD_RING_BASE),
 	REG32(BCS_SWCTRL),
 	REG64_IDX(RING_TIMESTAMP, BLT_RING_BASE),
+	REG32_IDX(RING_CTX_TIMESTAMP, BLT_RING_BASE),
 	REG64_IDX(BCS_GPR, 0),
 	REG64_IDX(BCS_GPR, 1),
 	REG64_IDX(BCS_GPR, 2),


