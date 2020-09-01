Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8C2B25941F
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729571AbgIAPf5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:35:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:42248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731234AbgIAPf4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:35:56 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 081FA2158C;
        Tue,  1 Sep 2020 15:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974555;
        bh=1RGGtrnl1sk6xJJ/Ju6CQOJOtmLTB5bs8EuDe2g18QA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QLYk3nWHlSwGbJ62yYwL+ARHSJy7eQbajIlKpvDhUAnzaVnuTxnPIZvchbyfWH0hA
         MOLvDWAEnctFHV8UWZO+P693nYHimJPF4pMFivCy2B6vSEuHt/XxM3zOvTObA2Z76v
         BIzJEWECW0rVk6egGq14sMtoX3K/h4a5Hz23TCoY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolai Stange <nstange@suse.de>,
        Miroslav Benes <mbenes@suse.cz>, Takashi Iwai <tiwai@suse.de>,
        Tyler Hicks <tyhicks@canonical.com>,
        Jon Bloomfield <jon.bloomfield@intel.com>,
        Chris Wilson <chris.p.wilson@intel.com>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 200/214] drm/i915: Fix cmd parser desc matching with masks
Date:   Tue,  1 Sep 2020 17:11:20 +0200
Message-Id: <20200901151002.527351535@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Kuoppala <mika.kuoppala@linux.intel.com>

[ Upstream commit e5f10d6385cda083037915c12b130887c8831d2b ]

Our variety of defined gpu commands have the actual
command id field and possibly length and flags applied.

We did start to apply the mask during initialization of
the cmd descriptors but forgot to also apply it on comparisons.

Fix comparisons in order to properly deny access with
associated commands.

v2: fix lri with correct mask (Chris)

Reported-by: Nicolai Stange <nstange@suse.de>
Cc: stable@vger.kernel.org # v5.4+
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Tyler Hicks <tyhicks@canonical.com>
Cc: Jon Bloomfield <jon.bloomfield@intel.com>
Cc: Chris Wilson <chris.p.wilson@intel.com>
Signed-off-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Link: https://patchwork.freedesktop.org/patch/msgid/20200817195926.12671-1-mika.kuoppala@linux.intel.com
(cherry picked from commit 3b4efa148da36f158cce3f662e831af2834b8e0f)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/i915_cmd_parser.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_cmd_parser.c b/drivers/gpu/drm/i915/i915_cmd_parser.c
index 21417ac8e878e..a9a69760c18d0 100644
--- a/drivers/gpu/drm/i915/i915_cmd_parser.c
+++ b/drivers/gpu/drm/i915/i915_cmd_parser.c
@@ -1207,6 +1207,12 @@ static u32 *copy_batch(struct drm_i915_gem_object *dst_obj,
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
@@ -1245,19 +1251,19 @@ static bool check_cmd(const struct intel_engine_cs *engine,
 			 * allowed mask/value pair given in the whitelist entry.
 			 */
 			if (reg->mask) {
-				if (desc->cmd.value == MI_LOAD_REGISTER_MEM) {
+				if (cmd_desc_is(desc, MI_LOAD_REGISTER_MEM)) {
 					DRM_DEBUG_DRIVER("CMD: Rejected LRM to masked register 0x%08X\n",
 							 reg_addr);
 					return false;
 				}
 
-				if (desc->cmd.value == MI_LOAD_REGISTER_REG) {
+				if (cmd_desc_is(desc, MI_LOAD_REGISTER_REG)) {
 					DRM_DEBUG_DRIVER("CMD: Rejected LRR to masked register 0x%08X\n",
 							 reg_addr);
 					return false;
 				}
 
-				if (desc->cmd.value == MI_LOAD_REGISTER_IMM(1) &&
+				if (cmd_desc_is(desc, MI_LOAD_REGISTER_IMM(1)) &&
 				    (offset + 2 > length ||
 				     (cmd[offset + 1] & reg->mask) != reg->value)) {
 					DRM_DEBUG_DRIVER("CMD: Rejected LRI to masked register 0x%08X\n",
@@ -1488,7 +1494,7 @@ int intel_engine_cmd_parser(struct i915_gem_context *ctx,
 			goto err;
 		}
 
-		if (desc->cmd.value == MI_BATCH_BUFFER_START) {
+		if (cmd_desc_is(desc, MI_BATCH_BUFFER_START)) {
 			ret = check_bbstart(ctx, cmd, offset, length,
 					    batch_len, batch_start,
 					    shadow_batch_start);
-- 
2.25.1



