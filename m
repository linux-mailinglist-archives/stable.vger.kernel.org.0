Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7D8579E1B
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242492AbiGSM6N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242351AbiGSM5K (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:57:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4A495C96B;
        Tue, 19 Jul 2022 05:23:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0872B81B1C;
        Tue, 19 Jul 2022 12:23:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 019CEC341C6;
        Tue, 19 Jul 2022 12:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233382;
        bh=1hAtghOKEH8FSD8tecwcdFljb7QXypnWi+WQSL/Z5Lg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YiNB1Hh7LdxY1Q/jd6Wh2+wbjdZY6i9riteKen3WXB1wCXH/dTolbxiy6kGPgSq8f
         nIOBi/VGH+vlbE5/ahAIteDrIFB8xoqG65JWg5LlbydSsDKmSY18WYd2LhoYTzqp1w
         6NYwwmpmxvoADJvx0AirgoyyXFhD2qiRZdzdqxl0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrzej Hajda <andrzej.hajda@intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 104/231] drm/i915/selftests: fix subtraction overflow bug
Date:   Tue, 19 Jul 2022 13:53:09 +0200
Message-Id: <20220719114723.384437849@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrzej Hajda <andrzej.hajda@intel.com>

[ Upstream commit 333991c4e66b3d4b5613315f18016da80344f659 ]

On some machines hole_end can be small enough to cause subtraction
overflow. On the other side (addr + 2 * min_alignment) can overflow
in case of mock tests. This patch should handle both cases.

Fixes: e1c5f754067b59 ("drm/i915: Avoid overflow in computing pot_hole loop termination")
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/3674
Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220624113528.2159210-1-andrzej.hajda@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit ab3edc679c552a466e4bf0b11af3666008bd65a2)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/selftests/i915_gem_gtt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/selftests/i915_gem_gtt.c b/drivers/gpu/drm/i915/selftests/i915_gem_gtt.c
index ab751192eb3b..34d1ef015233 100644
--- a/drivers/gpu/drm/i915/selftests/i915_gem_gtt.c
+++ b/drivers/gpu/drm/i915/selftests/i915_gem_gtt.c
@@ -742,7 +742,7 @@ static int pot_hole(struct i915_address_space *vm,
 		u64 addr;
 
 		for (addr = round_up(hole_start + min_alignment, step) - min_alignment;
-		     addr <= round_down(hole_end - (2 * min_alignment), step) - min_alignment;
+		     hole_end > addr && hole_end - addr >= 2 * min_alignment;
 		     addr += step) {
 			err = i915_vma_pin(vma, 0, 0, addr | flags);
 			if (err) {
-- 
2.35.1



