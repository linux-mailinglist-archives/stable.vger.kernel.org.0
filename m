Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02BC865D631
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:42:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239680AbjADOmC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:42:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239721AbjADOlf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:41:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 491ED3753F
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 06:41:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA30161746
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:41:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFC42C433F1;
        Wed,  4 Jan 2023 14:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672843293;
        bh=ccjwhWiJEMQovf3xL5MGurz8wF6WHeG8v9MYihh33rM=;
        h=Subject:To:Cc:From:Date:From;
        b=FqT9ZPFOQnZG0BwU6elsAEqvEjpBiK535+fZ8L340FGJWiQ64FJLXd2BAia8G0M8g
         IwpQowQAbPnN7z7djou4AYKECfNWmOUvK0ZlovGp3MQRD62Zs64HBlFyV/g2Zfybau
         4NFtjpXrp5WRKulS3PaKU5vW+wOlvHInQGeUVO5E=
Subject: FAILED: patch "[PATCH] drm/i915: Extend Wa_1607297627 to Alderlake-P" failed to apply to 6.0-stable tree
To:     jose.souza@intel.com, lucas.demarchi@intel.com,
        stable@vger.kernel.org, tvrtko.ursulin@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 15:41:22 +0100
Message-ID: <167284328223553@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

847eec69f01a ("drm/i915: Extend Wa_1607297627 to Alderlake-P")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 847eec69f01a28ca44f5ac7e1d71d3a60263d680 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>
Date: Mon, 17 Oct 2022 06:24:32 -0700
Subject: [PATCH] drm/i915: Extend Wa_1607297627 to Alderlake-P
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Workaround 1607297627 was missed for Alderlake-P, so here extending it
to it and adding the fixes tag so this WA is backported to all
stable kernels.

v2:
- fixed subject
- added Fixes tag

BSpec: 54369
Cc: <stable@vger.kernel.org> # v5.17+
Fixes: dfb924e33927 ("drm/i915/adlp: Remove require_force_probe protection")
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: José Roberto de Souza <jose.souza@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221017132432.112850-1-jose.souza@intel.com

diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
index 31e129329fb0..a79798777887 100644
--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -2293,11 +2293,11 @@ rcs_engine_wa_init(struct intel_engine_cs *engine, struct i915_wa_list *wal)
 	}
 
 	if (IS_DG1_GRAPHICS_STEP(i915, STEP_A0, STEP_B0) ||
-	    IS_ROCKETLAKE(i915) || IS_TIGERLAKE(i915)) {
+	    IS_ROCKETLAKE(i915) || IS_TIGERLAKE(i915) || IS_ALDERLAKE_P(i915)) {
 		/*
 		 * Wa_1607030317:tgl
 		 * Wa_1607186500:tgl
-		 * Wa_1607297627:tgl,rkl,dg1[a0]
+		 * Wa_1607297627:tgl,rkl,dg1[a0],adlp
 		 *
 		 * On TGL and RKL there are multiple entries for this WA in the
 		 * BSpec; some indicate this is an A0-only WA, others indicate

