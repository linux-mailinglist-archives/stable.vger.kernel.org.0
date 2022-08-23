Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A477359D79C
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241557AbiHWJrD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352245AbiHWJqG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:46:06 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D0E86050A;
        Tue, 23 Aug 2022 01:43:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 96C79CE1B41;
        Tue, 23 Aug 2022 08:28:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B33A0C433D6;
        Tue, 23 Aug 2022 08:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243332;
        bh=j1xQ+IIYNGAXrtO8PnOzFliezrN84TmBv/RgoyfbKOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I03ve2DhgVglL7mwGz0DlcrplVEzpozn0C6ObDpiYyOd/UM75hGhXetivz95wyRuN
         HMNV8kZGkWzIsmWF9hAUuCry1C+qjLh7rRSVno2aEgs5gLnH3fQ4XzqnyWXLMJPsKW
         bKOWUQDVtovFHjXAsiOx/CY1ETkEyX/VVHQ9wzoo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Auld <matthew.auld@intel.com>,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= 
        <thomas.hellstrom@linux.intel.com>,
        Ramalingam C <ramalingam.c@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 244/365] drm/i915/ttm: dont leak the ccs state
Date:   Tue, 23 Aug 2022 10:02:25 +0200
Message-Id: <20220823080128.429516312@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Auld <matthew.auld@intel.com>

[ Upstream commit 232d150fa15606e96c0e01e5c7a2d4e03f621787 ]

The kernel only manages the ccs state with lmem-only objects, however
the kernel should still take care not to leak the CCS state from the
previous user.

Fixes: 48760ffe923a ("drm/i915/gt: Clear compress metadata for Flat-ccs objects")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Ramalingam C <ramalingam.c@intel.com>
Reviewed-by: Ramalingam C <ramalingam.c@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220727164346.282407-1-matthew.auld@intel.com
(cherry picked from commit 353819d85f87be46aeb9c1dd929d445a006fc6ec)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_migrate.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_migrate.c b/drivers/gpu/drm/i915/gt/intel_migrate.c
index 2c35324b5f68..2b10b96b17b5 100644
--- a/drivers/gpu/drm/i915/gt/intel_migrate.c
+++ b/drivers/gpu/drm/i915/gt/intel_migrate.c
@@ -708,7 +708,7 @@ intel_context_migrate_copy(struct intel_context *ce,
 	u8 src_access, dst_access;
 	struct i915_request *rq;
 	int src_sz, dst_sz;
-	bool ccs_is_src;
+	bool ccs_is_src, overwrite_ccs;
 	int err;
 
 	GEM_BUG_ON(ce->vm != ce->engine->gt->migrate.context->vm);
@@ -749,6 +749,8 @@ intel_context_migrate_copy(struct intel_context *ce,
 			get_ccs_sg_sgt(&it_ccs, bytes_to_cpy);
 	}
 
+	overwrite_ccs = HAS_FLAT_CCS(i915) && !ccs_bytes_to_cpy && dst_is_lmem;
+
 	src_offset = 0;
 	dst_offset = CHUNK_SZ;
 	if (HAS_64K_PAGES(ce->engine->i915)) {
@@ -852,6 +854,25 @@ intel_context_migrate_copy(struct intel_context *ce,
 			if (err)
 				goto out_rq;
 			ccs_bytes_to_cpy -= ccs_sz;
+		} else if (overwrite_ccs) {
+			err = rq->engine->emit_flush(rq, EMIT_INVALIDATE);
+			if (err)
+				goto out_rq;
+
+			/*
+			 * While we can't always restore/manage the CCS state,
+			 * we still need to ensure we don't leak the CCS state
+			 * from the previous user, so make sure we overwrite it
+			 * with something.
+			 */
+			err = emit_copy_ccs(rq, dst_offset, INDIRECT_ACCESS,
+					    dst_offset, DIRECT_ACCESS, len);
+			if (err)
+				goto out_rq;
+
+			err = rq->engine->emit_flush(rq, EMIT_INVALIDATE);
+			if (err)
+				goto out_rq;
 		}
 
 		/* Arbitration is re-enabled between requests. */
-- 
2.35.1



