Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36EE9469E31
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379288AbhLFPg6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:36:58 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49218 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348085AbhLFPdv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:33:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98F8A61316;
        Mon,  6 Dec 2021 15:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C7C1C34900;
        Mon,  6 Dec 2021 15:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804621;
        bh=WEDwQ3wOC3GAroyf5zaiy5t5xDgGyXYmS6IHrZYp6XU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wfXHO4x5Og/8zxAp4B33UVaUT6eZ3xGJFtWkms87UXeXFwCkjbpndmNtQlpfGoaOk
         r0l1E/Gy8O795Rr0CGzJAGE7/bdzTrRutqrwszaKR8K4V2EaWsdS4DeRQidnPdthsT
         TwTXNm3i3k9WCrvv952GC7jolEbFFyYJ20fAzytI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Matt Atwood <matthew.s.atwood@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 170/207] Revert "drm/i915: Implement Wa_1508744258"
Date:   Mon,  6 Dec 2021 15:57:04 +0100
Message-Id: <20211206145616.154001280@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: José Roberto de Souza <jose.souza@intel.com>

[ Upstream commit 72641d8d60401a5f1e1a0431ceaf928680d34418 ]

This workarounds are causing hangs, because I missed the fact that it
needs to be enabled for all cases and disabled when doing a resolve
pass.

So KMD only needs to whitelist it and UMD will be the one setting it
on per case.

This reverts commit 28ec02c9cbebf3feeaf21a59df9dfbc02bda3362.

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/4145
Signed-off-by: José Roberto de Souza <jose.souza@intel.com>
Fixes: 28ec02c9cbeb ("drm/i915: Implement Wa_1508744258")
Reviewed-by: Matt Atwood <matthew.s.atwood@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211119140931.32791-1-jose.souza@intel.com
(cherry picked from commit f3799ff16fcfacd44aee55db162830df461b631f)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_workarounds.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
index aae609d7d85dd..6b5ab19a2ada9 100644
--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -621,13 +621,6 @@ static void gen12_ctx_workarounds_init(struct intel_engine_cs *engine,
 	       FF_MODE2_GS_TIMER_MASK,
 	       FF_MODE2_GS_TIMER_224,
 	       0, false);
-
-	/*
-	 * Wa_14012131227:dg1
-	 * Wa_1508744258:tgl,rkl,dg1,adl-s,adl-p
-	 */
-	wa_masked_en(wal, GEN7_COMMON_SLICE_CHICKEN1,
-		     GEN9_RHWO_OPTIMIZATION_DISABLE);
 }
 
 static void dg1_ctx_workarounds_init(struct intel_engine_cs *engine,
-- 
2.33.0



