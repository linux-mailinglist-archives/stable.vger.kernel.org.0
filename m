Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA09633B7EE
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233469AbhCOOBn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:01:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:37540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232500AbhCON7v (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DEE864F37;
        Mon, 15 Mar 2021 13:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816758;
        bh=a77GqLSXsGmp8xbkH5T6Phr1hqd34GJGS40ghwUy/FM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OSB1wpWBonPuxC+T0NPvUBgF6Q8fWXrgyqU2R0r4dYXQTZ2PNyNGYoQBNIFtNXS+i
         VzqDMhgsSbYyEkiAm4L61CCg+cGj5lHuZD3d8XtigtZfe64T1w4sJqa6ktPIdj5LNd
         w2sEu9NLqtA9gtkw3/hZmwaAyzO6rfz1iLkA1rKQ=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Jon Bloomfield <jon.bloomfield@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Chris Wilson <chris.p.wilson@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [PATCH 5.10 097/290] drm/i915: Wedge the GPU if command parser setup fails
Date:   Mon, 15 Mar 2021 14:53:10 +0100
Message-Id: <20210315135545.196139488@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

commit a829f033e966d5e4aa27c3ef2b381f51734e4a7f upstream.

Commit 311a50e76a33 ("drm/i915: Add support for mandatory cmdparsing")
introduced mandatory command parsing but setup failures were not
translated into wedging the GPU which was probably the intent.

Possible errors come in two categories. Either the sanity check on
internal tables has failed, which should be caught in CI unless an
affected platform would be missed in testing; or memory allocation failure
happened during driver load, which should be extremely unlikely but for
correctness should still be handled.

v2:
 * Tidy coding style. (Chris)

[airlied: cherry-picked to avoid rc1 base]
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Fixes: 311a50e76a33 ("drm/i915: Add support for mandatory cmdparsing")
Cc: Jon Bloomfield <jon.bloomfield@intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Chris Wilson <chris.p.wilson@intel.com>
Reviewed-by: Chris Wilson <chris.p.wilson@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210302114213.1102223-1-tvrtko.ursulin@linux.intel.com
(cherry picked from commit 5a1a659762d35a6dc51047c9127c011303c77b7f)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gt/intel_engine_cs.c |    7 ++++++-
 drivers/gpu/drm/i915/i915_cmd_parser.c    |   19 +++++++++++++------
 drivers/gpu/drm/i915/i915_drv.h           |    2 +-
 3 files changed, 20 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/i915/gt/intel_engine_cs.c
+++ b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
@@ -708,9 +708,12 @@ static int engine_setup_common(struct in
 		goto err_status;
 	}
 
+	err = intel_engine_init_cmd_parser(engine);
+	if (err)
+		goto err_cmd_parser;
+
 	intel_engine_init_active(engine, ENGINE_PHYSICAL);
 	intel_engine_init_execlists(engine);
-	intel_engine_init_cmd_parser(engine);
 	intel_engine_init__pm(engine);
 	intel_engine_init_retire(engine);
 
@@ -724,6 +727,8 @@ static int engine_setup_common(struct in
 
 	return 0;
 
+err_cmd_parser:
+	intel_breadcrumbs_free(engine->breadcrumbs);
 err_status:
 	cleanup_status_page(engine);
 	return err;
--- a/drivers/gpu/drm/i915/i915_cmd_parser.c
+++ b/drivers/gpu/drm/i915/i915_cmd_parser.c
@@ -939,7 +939,7 @@ static void fini_hash_table(struct intel
  * struct intel_engine_cs based on whether the platform requires software
  * command parsing.
  */
-void intel_engine_init_cmd_parser(struct intel_engine_cs *engine)
+int intel_engine_init_cmd_parser(struct intel_engine_cs *engine)
 {
 	const struct drm_i915_cmd_table *cmd_tables;
 	int cmd_table_count;
@@ -947,7 +947,7 @@ void intel_engine_init_cmd_parser(struct
 
 	if (!IS_GEN(engine->i915, 7) && !(IS_GEN(engine->i915, 9) &&
 					  engine->class == COPY_ENGINE_CLASS))
-		return;
+		return 0;
 
 	switch (engine->class) {
 	case RENDER_CLASS:
@@ -1012,19 +1012,19 @@ void intel_engine_init_cmd_parser(struct
 		break;
 	default:
 		MISSING_CASE(engine->class);
-		return;
+		goto out;
 	}
 
 	if (!validate_cmds_sorted(engine, cmd_tables, cmd_table_count)) {
 		drm_err(&engine->i915->drm,
 			"%s: command descriptions are not sorted\n",
 			engine->name);
-		return;
+		goto out;
 	}
 	if (!validate_regs_sorted(engine)) {
 		drm_err(&engine->i915->drm,
 			"%s: registers are not sorted\n", engine->name);
-		return;
+		goto out;
 	}
 
 	ret = init_hash_table(engine, cmd_tables, cmd_table_count);
@@ -1032,10 +1032,17 @@ void intel_engine_init_cmd_parser(struct
 		drm_err(&engine->i915->drm,
 			"%s: initialised failed!\n", engine->name);
 		fini_hash_table(engine);
-		return;
+		goto out;
 	}
 
 	engine->flags |= I915_ENGINE_USING_CMD_PARSER;
+
+out:
+	if (intel_engine_requires_cmd_parser(engine) &&
+	    !intel_engine_using_cmd_parser(engine))
+		return -EINVAL;
+
+	return 0;
 }
 
 /**
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -1946,7 +1946,7 @@ const char *i915_cache_level_str(struct
 
 /* i915_cmd_parser.c */
 int i915_cmd_parser_get_version(struct drm_i915_private *dev_priv);
-void intel_engine_init_cmd_parser(struct intel_engine_cs *engine);
+int intel_engine_init_cmd_parser(struct intel_engine_cs *engine);
 void intel_engine_cleanup_cmd_parser(struct intel_engine_cs *engine);
 int intel_engine_cmd_parser(struct intel_engine_cs *engine,
 			    struct i915_vma *batch,


