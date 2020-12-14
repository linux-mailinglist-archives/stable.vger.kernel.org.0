Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 071972D9E8B
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 19:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439998AbgLNSHu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 13:07:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:49726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408613AbgLNRjT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:39:19 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.9 092/105] drm/i915/gt: Declare gen9 has 64 mocs entries!
Date:   Mon, 14 Dec 2020 18:29:06 +0100
Message-Id: <20201214172559.709389903@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
References: <20201214172555.280929671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 7c5c15dffe1e3c42f44735ce9552afb7207f1584 upstream.

We checked the table size against a hardcoded number of entries, and
that number was excluding the special mocs registers at the end.

Fixes: 777a7717d60c ("drm/i915/gt: Program mocs:63 for cache eviction on gen9")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: <stable@vger.kernel.org> # v4.3+
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201127102540.13117-1-chris@chris-wilson.co.uk
(cherry picked from commit 444fbf5d7058099447c5366ba8bb60d610aeb44b)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
[backported and updated the Fixes sha]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gt/intel_mocs.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/i915/gt/intel_mocs.c
+++ b/drivers/gpu/drm/i915/gt/intel_mocs.c
@@ -59,8 +59,7 @@ struct drm_i915_mocs_table {
 #define _L3_CACHEABILITY(value)	((value) << 4)
 
 /* Helper defines */
-#define GEN9_NUM_MOCS_ENTRIES	62  /* 62 out of 64 - 63 & 64 are reserved. */
-#define GEN11_NUM_MOCS_ENTRIES	64  /* 63-64 are reserved, but configured. */
+#define GEN9_NUM_MOCS_ENTRIES	64  /* 63-64 are reserved, but configured. */
 
 /* (e)LLC caching options */
 /*
@@ -328,11 +327,11 @@ static unsigned int get_mocs_settings(co
 	if (INTEL_GEN(i915) >= 12) {
 		table->size  = ARRAY_SIZE(tgl_mocs_table);
 		table->table = tgl_mocs_table;
-		table->n_entries = GEN11_NUM_MOCS_ENTRIES;
+		table->n_entries = GEN9_NUM_MOCS_ENTRIES;
 	} else if (IS_GEN(i915, 11)) {
 		table->size  = ARRAY_SIZE(icl_mocs_table);
 		table->table = icl_mocs_table;
-		table->n_entries = GEN11_NUM_MOCS_ENTRIES;
+		table->n_entries = GEN9_NUM_MOCS_ENTRIES;
 	} else if (IS_GEN9_BC(i915) || IS_CANNONLAKE(i915)) {
 		table->size  = ARRAY_SIZE(skl_mocs_table);
 		table->n_entries = GEN9_NUM_MOCS_ENTRIES;


