Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7518F246670
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 14:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbgHQMgI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 08:36:08 -0400
Received: from mga05.intel.com ([192.55.52.43]:30247 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726842AbgHQMgH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 08:36:07 -0400
IronPort-SDR: gWV7RRmb590N64RAr09TTN+499FxAKUFjItclMXYqSLxcMteP+3y7mKOpzaCiaA711gvnwoW7N
 kAi88b1PLiuA==
X-IronPort-AV: E=McAfee;i="6000,8403,9715"; a="239511562"
X-IronPort-AV: E=Sophos;i="5.76,322,1592895600"; 
   d="scan'208";a="239511562"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2020 05:36:06 -0700
IronPort-SDR: 6YSXvBe7aV6+qbV8fBqlgQsjDeMhuD08+TM00moNaENwk9qUZ3x+JWMsbbmci3G6LO+QxIxVBY
 Mtelo0j/Gp1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,322,1592895600"; 
   d="scan'208";a="292419166"
Received: from rosetta.fi.intel.com ([10.237.72.194])
  by orsmga003.jf.intel.com with ESMTP; 17 Aug 2020 05:36:04 -0700
Received: by rosetta.fi.intel.com (Postfix, from userid 1000)
        id 5A7DA8404BB; Mon, 17 Aug 2020 15:34:15 +0300 (EEST)
From:   Mika Kuoppala <mika.kuoppala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        stable@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Tyler Hicks <tyhicks@canonical.com>,
        Jon Bloomfield <jon.bloomfield@intel.com>,
        Chris Wilson <chris.p.wilson@intel.com>
Subject: [PATCH] drm/i915: Fix cmd parser desc matching with masks
Date:   Mon, 17 Aug 2020 15:34:12 +0300
Message-Id: <20200817123412.4655-1-mika.kuoppala@linux.intel.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Our variety of defined gpu commands have the actual
command id field and possibly length and flags applied.

We did start to apply the mask during initialization of
the cmd descriptors but forgot to also apply it on comparisons.

Fix comparisons in order to properly deny access with
associated commands.

References: 926abff21a8f ("drm/i915/cmdparser: Ignore Length operands during command matching")
Reported-by: Nicolai Stange <nstange@suse.de>
Cc: stable@vger.kernel.org # v5.4+
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Tyler Hicks <tyhicks@canonical.com>
Cc: Jon Bloomfield <jon.bloomfield@intel.com>
Cc: Chris Wilson <chris.p.wilson@intel.com>
Signed-off-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
---
 drivers/gpu/drm/i915/i915_cmd_parser.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_cmd_parser.c b/drivers/gpu/drm/i915/i915_cmd_parser.c
index 372354d33f55..f2b0eb458d2d 100644
--- a/drivers/gpu/drm/i915/i915_cmd_parser.c
+++ b/drivers/gpu/drm/i915/i915_cmd_parser.c
@@ -1204,6 +1204,12 @@ static u32 *copy_batch(struct drm_i915_gem_object *dst_obj,
 	return dst;
 }
 
+static inline bool cmd_desc_is(const struct drm_i915_cmd_descriptor * const desc,
+			       const u32 cmd)
+{
+	return desc->cmd.value == (cmd & desc->cmd.mask);
+}
+
 static bool check_cmd(const struct intel_engine_cs *engine,
 		      const struct drm_i915_cmd_descriptor *desc,
 		      const u32 *cmd, u32 length)
@@ -1242,24 +1248,24 @@ static bool check_cmd(const struct intel_engine_cs *engine,
 			 * allowed mask/value pair given in the whitelist entry.
 			 */
 			if (reg->mask) {
-				if (desc->cmd.value == MI_LOAD_REGISTER_MEM) {
+				if (cmd_desc_is(desc, MI_LOAD_REGISTER_MEM)) {
 					DRM_DEBUG("CMD: Rejected LRM to masked register 0x%08X\n",
 						  reg_addr);
 					return false;
-				}
-
-				if (desc->cmd.value == MI_LOAD_REGISTER_REG) {
+				} else if (cmd_desc_is(desc, MI_LOAD_REGISTER_REG)) {
 					DRM_DEBUG("CMD: Rejected LRR to masked register 0x%08X\n",
 						  reg_addr);
 					return false;
-				}
-
-				if (desc->cmd.value == MI_LOAD_REGISTER_IMM(1) &&
+				} else if (cmd_desc_is(desc, MI_LOAD_REGISTER_IMM(1)) &&
 				    (offset + 2 > length ||
 				     (cmd[offset + 1] & reg->mask) != reg->value)) {
 					DRM_DEBUG("CMD: Rejected LRI to masked register 0x%08X\n",
 						  reg_addr);
 					return false;
+				} else {
+					DRM_DEBUG("CMD: Rejecting cmd 0x%08X to masked register 0x%08X\n",
+						  desc->cmd.value, reg_addr);
+					return false;
 				}
 			}
 		}
@@ -1478,7 +1484,7 @@ int intel_engine_cmd_parser(struct intel_engine_cs *engine,
 			break;
 		}
 
-		if (desc->cmd.value == MI_BATCH_BUFFER_START) {
+		if (cmd_desc_is(desc, MI_BATCH_BUFFER_START)) {
 			ret = check_bbstart(cmd, offset, length, batch_length,
 					    batch_addr, shadow_addr,
 					    jump_whitelist);
-- 
2.17.1

