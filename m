Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF1C6157DF
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbiKBCkh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbiKBCkg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:40:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46CC21F60E
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:40:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDE3C617A9
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:40:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 731F4C433D7;
        Wed,  2 Nov 2022 02:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667356835;
        bh=5dcll94JCn/zQ7pNoiU+QNZML0UbQSImMB8GYCqoNhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=swTVPIh96vWg8GVzHKMV83fTfF5m38q/Td0FnKo+sFYIITr+39lT6WvxswoQ+D236
         7cvBmVvuqRFf5jFTnmxYdbLDLEcsJtAKoAdan2Ye6s9e9GR2v961Rcqbf+5nUsKMX4
         U1TGXVyXjR+2x/pRTuTSZpRwd4DVBgHGq9WuxLSQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>
Subject: [PATCH 6.0 060/240] drm/i915: Extend Wa_1607297627 to Alderlake-P
Date:   Wed,  2 Nov 2022 03:30:35 +0100
Message-Id: <20221102022112.756331270@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: José Roberto de Souza <jose.souza@intel.com>

commit 1a3abd12a394f5c66943fee75cef533069e831fb upstream.

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
(cherry picked from commit 847eec69f01a28ca44f5ac7e1d71d3a60263d680)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gt/intel_workarounds.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -2301,11 +2301,11 @@ rcs_engine_wa_init(struct intel_engine_c
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


