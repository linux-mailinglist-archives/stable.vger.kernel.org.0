Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEB9D2477D1
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 22:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729424AbgHQUBd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 16:01:33 -0400
Received: from mga07.intel.com ([134.134.136.100]:41619 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729268AbgHQUB3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 16:01:29 -0400
IronPort-SDR: nxL2HiA9PYlSclKtPqnSJKkAFjG1/XIuSyz3q6pafB2moHj8202Yb79izFsaa0V2LYLgYvy851
 iW72kHigbLeg==
X-IronPort-AV: E=McAfee;i="6000,8403,9716"; a="219103493"
X-IronPort-AV: E=Sophos;i="5.76,324,1592895600"; 
   d="scan'208";a="219103493"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2020 13:01:27 -0700
IronPort-SDR: cKsF1hgHdM/oACttzBrcLFFu81Wj+5eyZLTtcM8RGuCB4ml/e5ur46czOPVnHNXSqilMMm12o7
 HFI9TJ2Ia8MQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,324,1592895600"; 
   d="scan'208";a="440980630"
Received: from rosetta.fi.intel.com ([10.237.72.194])
  by orsmga004.jf.intel.com with ESMTP; 17 Aug 2020 13:01:25 -0700
Received: by rosetta.fi.intel.com (Postfix, from userid 1000)
        id 0A0758404BB; Mon, 17 Aug 2020 22:59:36 +0300 (EEST)
From:   Mika Kuoppala <mika.kuoppala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        stable@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Tyler Hicks <tyhicks@canonical.com>,
        Jon Bloomfield <jon.bloomfield@intel.com>,
        Chris Wilson <chris.p.wilson@intel.com>
Subject: [PATCH] drm/i915: Fix cmd parser desc matching with masks
Date:   Mon, 17 Aug 2020 22:59:26 +0300
Message-Id: <20200817195926.12671-1-mika.kuoppala@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <159766836466.667.7312583547693920058@build.alporthouse.com>
References: <159766836466.667.7312583547693920058@build.alporthouse.com>
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

v2: fix lri with correct mask (Chris)

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
 drivers/gpu/drm/i915/i915_cmd_parser.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_cmd_parser.c b/drivers/gpu/drm/i915/i915_cmd_parser.c
index 372354d33f55..5ac4a999f05a 100644
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
@@ -1242,19 +1248,19 @@ static bool check_cmd(const struct intel_engine_cs *engine,
 			 * allowed mask/value pair given in the whitelist entry.
 			 */
 			if (reg->mask) {
-				if (desc->cmd.value == MI_LOAD_REGISTER_MEM) {
+				if (cmd_desc_is(desc, MI_LOAD_REGISTER_MEM)) {
 					DRM_DEBUG("CMD: Rejected LRM to masked register 0x%08X\n",
 						  reg_addr);
 					return false;
 				}
 
-				if (desc->cmd.value == MI_LOAD_REGISTER_REG) {
+				if (cmd_desc_is(desc, MI_LOAD_REGISTER_REG)) {
 					DRM_DEBUG("CMD: Rejected LRR to masked register 0x%08X\n",
 						  reg_addr);
 					return false;
 				}
 
-				if (desc->cmd.value == MI_LOAD_REGISTER_IMM(1) &&
+				if (cmd_desc_is(desc, MI_LOAD_REGISTER_IMM(1)) &&
 				    (offset + 2 > length ||
 				     (cmd[offset + 1] & reg->mask) != reg->value)) {
 					DRM_DEBUG("CMD: Rejected LRI to masked register 0x%08X\n",
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

