Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 572366810C7
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:06:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237088AbjA3OGk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:06:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237091AbjA3OGj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:06:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3A5F3B3E7
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:06:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A7E9B81147
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:06:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2790C433EF;
        Mon, 30 Jan 2023 14:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087596;
        bh=IawFp/nV9b5Krmw1txI9XqGLgDj4bpwTJGFs457JIkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ssiS6IYpn7AYyNPjrFn4d2C+nkbu9hy2zLXaA910uXA1SQWOqWGQEKmK/KUn8n1Sz
         YDqvKEL7WhoXvTRKZ85bhTsoGY5ZpnFJ3VCD42stNvoA+5B/szV4verHUkQSpw4970
         WtxbGZJlcx4M/dnquQWn9nZxVJ5WrLjp/xjzcalw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Arnd Bergmann <arnd@arndb.de>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 260/313] drm/i915/selftest: fix intel_selftest_modify_policy argument types
Date:   Mon, 30 Jan 2023 14:51:35 +0100
Message-Id: <20230130134348.843710098@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 2255bbcdc39d5b0311968f86614ae4f25fdd465d ]

The definition of intel_selftest_modify_policy() does not match the
declaration, as gcc-13 points out:

drivers/gpu/drm/i915/selftests/intel_scheduler_helpers.c:29:5: error: conflicting types for 'intel_selftest_modify_policy' due to enum/integer mismatch; have 'int(struct intel_engine_cs *, struct intel_selftest_saved_policy *, u32)' {aka 'int(struct intel_engine_cs *, struct intel_selftest_saved_policy *, unsigned int)'} [-Werror=enum-int-mismatch]
   29 | int intel_selftest_modify_policy(struct intel_engine_cs *engine,
      |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from drivers/gpu/drm/i915/selftests/intel_scheduler_helpers.c:11:
drivers/gpu/drm/i915/selftests/intel_scheduler_helpers.h:28:5: note: previous declaration of 'intel_selftest_modify_policy' with type 'int(struct intel_engine_cs *, struct intel_selftest_saved_policy *, enum selftest_scheduler_modify)'
   28 | int intel_selftest_modify_policy(struct intel_engine_cs *engine,
      |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~

Change the type in the definition to match.

Fixes: 617e87c05c72 ("drm/i915/selftest: Fix hangcheck self test for GuC submission")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230117163743.1003219-1-arnd@kernel.org
(cherry picked from commit 8d7eb8ed3f83f248e01a4f548d9c500a950a2c2d)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/selftests/intel_scheduler_helpers.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/selftests/intel_scheduler_helpers.c b/drivers/gpu/drm/i915/selftests/intel_scheduler_helpers.c
index 310fb83c527e..2990dd4d4a0d 100644
--- a/drivers/gpu/drm/i915/selftests/intel_scheduler_helpers.c
+++ b/drivers/gpu/drm/i915/selftests/intel_scheduler_helpers.c
@@ -28,8 +28,7 @@ struct intel_engine_cs *intel_selftest_find_any_engine(struct intel_gt *gt)
 
 int intel_selftest_modify_policy(struct intel_engine_cs *engine,
 				 struct intel_selftest_saved_policy *saved,
-				 u32 modify_type)
-
+				 enum selftest_scheduler_modify modify_type)
 {
 	int err;
 
-- 
2.39.0



