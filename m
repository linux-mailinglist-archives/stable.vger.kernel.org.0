Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08B4A20607D
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392520AbgFWUnY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:43:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:40250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392515AbgFWUnX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:43:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2648121883;
        Tue, 23 Jun 2020 20:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592945003;
        bh=k6p8OcEuzK4UAhSHv16GJqWypDgF3hbJsp8dDXxMVwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a8DYVt8KiWh3fPgteIlq8XIu5uFyXk37uBnV6CC4dNVkwJVh3wVt+cHOXLQ7IxuAo
         TJY6CtFlqVvZLTY0qix1BuyXUocgrMqhvnTK3Xb9KTiqDUpukvIbpNyGrwLq4OAQaJ
         WV61mxxD3w6EgFyMfT6I5QmqfGGmVFSZGmcE7T7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 4.19 196/206] drm/i915: Whitelist context-local timestamp in the gen9 cmdparser
Date:   Tue, 23 Jun 2020 21:58:44 +0200
Message-Id: <20200623195326.671414996@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195316.864547658@linuxfoundation.org>
References: <20200623195316.864547658@linuxfoundation.org>
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
@@ -570,6 +570,9 @@ struct drm_i915_reg_descriptor {
 #define REG32(_reg, ...) \
 	{ .addr = (_reg), __VA_ARGS__ }
 
+#define REG32_IDX(_reg, idx) \
+	{ .addr = _reg(idx) }
+
 /*
  * Convenience macro for adding 64-bit registers.
  *
@@ -667,6 +670,7 @@ static const struct drm_i915_reg_descrip
 	REG64_IDX(RING_TIMESTAMP, BSD_RING_BASE),
 	REG32(BCS_SWCTRL),
 	REG64_IDX(RING_TIMESTAMP, BLT_RING_BASE),
+	REG32_IDX(RING_CTX_TIMESTAMP, BLT_RING_BASE),
 	REG64_IDX(BCS_GPR, 0),
 	REG64_IDX(BCS_GPR, 1),
 	REG64_IDX(BCS_GPR, 2),


