Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0145C664ABE
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238782AbjAJSf5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:35:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239470AbjAJSfa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:35:30 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E3B71A39A
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:31:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EA3D1CE18E6
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:31:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1237C433EF;
        Tue, 10 Jan 2023 18:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375461;
        bh=iMIRrFvbe1IzCAmqDaxOxj3PL0rcPPKy0ZMQAZ2u4nU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C8Fv0T1RteqN1xfE2lnYGZqrsQwqBCsIJxp3rxeUrZadkNKcCmQsMDgLMOqN/ErBS
         4seNo5as43IYXDpSgCDYVdtg3Xkygq/KGbzT8/8zKrPF/AwvZPAEQsdUne1vg9EZJv
         XQrLWPPO/7WJPfAQpy9JsWFuGBvlaCbyma6GxwvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Matthew Auld <matthew.auld@intel.com>,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= 
        <thomas.hellstrom@linux.intel.com>,
        Ramalingam C <ramalingam.c@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 195/290] drm/i915/migrate: fix offset calculation
Date:   Tue, 10 Jan 2023 19:04:47 +0100
Message-Id: <20230110180038.684427260@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Matthew Auld <matthew.auld@intel.com>

[ Upstream commit 08c7c122ad90799cc3ae674e7f29f236f91063ce ]

Ensure we add the engine base only after we calculate the qword offset
into the PTE window.

Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Ramalingam C <ramalingam.c@intel.com>
Reviewed-by: Ramalingam C <ramalingam.c@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211206112539.3149779-2-matthew.auld@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_migrate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_migrate.c b/drivers/gpu/drm/i915/gt/intel_migrate.c
index aa05c26ff792..fb7fe3a2b6c6 100644
--- a/drivers/gpu/drm/i915/gt/intel_migrate.c
+++ b/drivers/gpu/drm/i915/gt/intel_migrate.c
@@ -279,10 +279,10 @@ static int emit_pte(struct i915_request *rq,
 	GEM_BUG_ON(GRAPHICS_VER(rq->engine->i915) < 8);
 
 	/* Compute the page directory offset for the target address range */
-	offset += (u64)rq->engine->instance << 32;
 	offset >>= 12;
 	offset *= sizeof(u64);
 	offset += 2 * CHUNK_SZ;
+	offset += (u64)rq->engine->instance << 32;
 
 	cs = intel_ring_begin(rq, 6);
 	if (IS_ERR(cs))
-- 
2.35.1



