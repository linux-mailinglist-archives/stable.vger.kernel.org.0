Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9620E56FC40
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233019AbiGKJlZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232588AbiGKJks (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:40:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 344EF52FC3;
        Mon, 11 Jul 2022 02:20:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BFD04B80D2C;
        Mon, 11 Jul 2022 09:20:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31378C341C0;
        Mon, 11 Jul 2022 09:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531242;
        bh=KK7PIPZHfYTfjyg6++h92jso97+euDiUBqTojabpj+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cvdG1C/cE5ckqbNmdGP9l3UNAZi8s8dHPyctJOF1hzlTs69fs2EXKikKl6Ku/wBFu
         cdU7+UianTqWaaXNarv9oPUuflqnc5oz8GNYLK/ubzF97bTP4fy4R2aGGI5aNFmBql
         IfaSI94DXSPiwquMlIvnZhrY19YNJBq0nVgyZpuI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Dave Airlie <airlied@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 033/230] drm/i915: Replace the unconditional clflush with drm_clflush_virt_range()
Date:   Mon, 11 Jul 2022 11:04:49 +0200
Message-Id: <20220711090605.019193919@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit ef7ec41f17cbc0861891ccc0634d06a0c8dcbf09 ]

Not all machines have clflush, so don't go assuming they do.
Not really sure why the clflush is even here since hwsp
is supposed to get snooped I thought.

Although in my case we're talking about a i830 machine where
render/blitter snooping is definitely busted. But it might
work for the hswp perhaps. Haven't really reverse engineered
that one fully.

Cc: stable@vger.kernel.org
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Fixes: b436a5f8b6c8 ("drm/i915/gt: Track all timelines created using the HWSP")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211014090941.12159-2-ville.syrjala@linux.intel.com
Reviewed-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_ring_submission.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_ring_submission.c b/drivers/gpu/drm/i915/gt/intel_ring_submission.c
index 6f2f6ba87397..02e18e70c78e 100644
--- a/drivers/gpu/drm/i915/gt/intel_ring_submission.c
+++ b/drivers/gpu/drm/i915/gt/intel_ring_submission.c
@@ -292,7 +292,7 @@ static void xcs_sanitize(struct intel_engine_cs *engine)
 	sanitize_hwsp(engine);
 
 	/* And scrub the dirty cachelines for the HWSP */
-	clflush_cache_range(engine->status_page.addr, PAGE_SIZE);
+	drm_clflush_virt_range(engine->status_page.addr, PAGE_SIZE);
 
 	intel_engine_reset_pinned_contexts(engine);
 }
-- 
2.35.1



