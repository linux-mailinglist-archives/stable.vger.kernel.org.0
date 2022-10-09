Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8BDA5F94D7
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 02:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbiJJAM4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 20:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230424AbiJJAMl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 20:12:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16F8610050;
        Sun,  9 Oct 2022 16:49:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6512B60D2B;
        Sun,  9 Oct 2022 23:49:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 428CFC433D6;
        Sun,  9 Oct 2022 23:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665359385;
        bh=Bl4G7PhvvFyNlas+R2mIUh5HCYKgCqnCPCHdtZQ7cm4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F4FzgYJUxGur39HhBtlcIPEsgP4L/q7AS082Ti5VVs36E4AlUQjmO0uKUrYipn+hu
         o0zdkCS4WJU19AsISMa3SMGLd3bEQ4vP2UCkq3mq/RnNTS1bwv7f4aU0a/hfTN99m4
         SOfmNUhHIr7hKNw2PxVf7qX08ul5d60z4F3Gzt9E4g2vm/J+cqrnDmBK9e2t+9dFyH
         Z9JoHwOW1qnoOGqxG0yNLQh08tA8n2SdCo1CSIi96lGmCmRiwwuGcDgN9ctH9GoYjY
         WIG5WQ7hUUWMUPVmBy8536EHVakezK2eutEU/2Rnm/1UKPvfyVwYQZjRdVHANT98CO
         mcFEm8v23Zwjw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Gow <davidgow@google.com>,
        Tales Aparecida <tales.aparecida@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@gmail.com,
        daniel@ffwll.ch, isabbasso@riseup.net,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.0 06/44] drm/amd/display: fix overflow on MIN_I64 definition
Date:   Sun,  9 Oct 2022 19:48:54 -0400
Message-Id: <20221009234932.1230196-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009234932.1230196-1-sashal@kernel.org>
References: <20221009234932.1230196-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Gow <davidgow@google.com>

[ Upstream commit 6ae0632d17759852c07e2d1e0a31c728eb6ba246 ]

The definition of MIN_I64 in bw_fixed.c can cause gcc to whinge about
integer overflow, because it is treated as a positive value, which is
then negated. The temporary positive value is not necessarily
representable.

This causes the following warning:
../drivers/gpu/drm/amd/amdgpu/../display/dc/dml/calcs/bw_fixed.c:30:19:
warning: integer overflow in expression ‘-9223372036854775808’ of type
‘long long int’ results in ‘-9223372036854775808’ [-Woverflow]
  30 |         (int64_t)(-(1LL << 63))
     |                   ^

Writing out (-MAX_I64 - 1) works instead.

Signed-off-by: David Gow <davidgow@google.com>
Signed-off-by: Tales Aparecida <tales.aparecida@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml/calcs/bw_fixed.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/calcs/bw_fixed.c b/drivers/gpu/drm/amd/display/dc/dml/calcs/bw_fixed.c
index 6ca288fb5fb9..2d46bc527b21 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/calcs/bw_fixed.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/calcs/bw_fixed.c
@@ -26,12 +26,12 @@
 #include "bw_fixed.h"
 
 
-#define MIN_I64 \
-	(int64_t)(-(1LL << 63))
-
 #define MAX_I64 \
 	(int64_t)((1ULL << 63) - 1)
 
+#define MIN_I64 \
+	(-MAX_I64 - 1)
+
 #define FRACTIONAL_PART_MASK \
 	((1ULL << BW_FIXED_BITS_PER_FRACTIONAL_PART) - 1)
 
-- 
2.35.1

