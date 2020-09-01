Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23B5C2595CB
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731860AbgIAPpL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:45:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:33078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731859AbgIAPpF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:45:05 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97D5C206FA;
        Tue,  1 Sep 2020 15:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598975105;
        bh=JbFLvfjExjWOPOeRFdjCRvZoSadmNbaonpxOsDWk65w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FITfeFyWgUoyCFBA7eQDQ9bX1fiOHPOS2YvKf4N7h+5ekADphnj7W7vCv2hiB9+jP
         +puKTZvApnT2nxYMFFjLVdVXrxQjOx3VkLcQ2hycCAUJZqHCWx6zndn0Jw760MfraQ
         c2EIbgazEmjRj1PSCAwSqe7haML2huZAFhybwHiM=
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
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.8 210/255] drm/i915: Fix cmd parser desc matching with masks
Date:   Tue,  1 Sep 2020 17:11:06 +0200
Message-Id: <20200901151010.761208181@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Kuoppala <mika.kuoppala@linux.intel.com>

commit e5f10d6385cda083037915c12b130887c8831d2b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_cmd_parser.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/i915/i915_cmd_parser.c
+++ b/drivers/gpu/drm/i915/i915_cmd_parser.c
@@ -1204,6 +1204,12 @@ static u32 *copy_batch(struct drm_i915_g
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
@@ -1242,19 +1248,19 @@ static bool check_cmd(const struct intel
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
@@ -1478,7 +1484,7 @@ int intel_engine_cmd_parser(struct intel
 			break;
 		}
 
-		if (desc->cmd.value == MI_BATCH_BUFFER_START) {
+		if (cmd_desc_is(desc, MI_BATCH_BUFFER_START)) {
 			ret = check_bbstart(cmd, offset, length, batch_length,
 					    batch_addr, shadow_addr,
 					    jump_whitelist);


