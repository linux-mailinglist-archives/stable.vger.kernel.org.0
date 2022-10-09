Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 576385F960A
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 02:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232776AbiJJA0d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 20:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232727AbiJJAWa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 20:22:30 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D39A812606;
        Sun,  9 Oct 2022 16:56:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2E355CE0F9B;
        Sun,  9 Oct 2022 23:56:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E15C2C433D7;
        Sun,  9 Oct 2022 23:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665359777;
        bh=IqXIc2zb1gPqjZAiZAuDXqBufstMjobSxTTlD79UXjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vHoL5kBNDazaWPJCLoFqyom6jsACj53P4JdQ4cVIxCPge90Kjls3P0wFT9ecjLq2T
         2iirsr8mDjO9Lks7mTtlDfjbgko/EhI3ld8ANulKMIqJgJWMqPS3q88mrUyu5mqcaj
         ibJqGCUrPb/HkumWx67oYktTeWNeEHCeaxu2V1b2umj66oyWPyEesrghJydT8UIIb9
         fsacNaY8CG83BoMqrgiQQVOJ9O2DMrfRS4Qqir9AN03E3mi4Z5Isb9nTYEBKPOHNMM
         2YnIqgu0SHXCGo1IkzJubHbCRSQ3NiX2wMa/DPtiQTcubpLdbXCXkCuAQ1x6ONTx3E
         jtKawdxl1oEFQ==
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
Subject: [PATCH AUTOSEL 5.10 05/22] drm/amd/display: fix overflow on MIN_I64 definition
Date:   Sun,  9 Oct 2022 19:55:23 -0400
Message-Id: <20221009235540.1231640-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009235540.1231640-1-sashal@kernel.org>
References: <20221009235540.1231640-1-sashal@kernel.org>
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
 drivers/gpu/drm/amd/display/dc/calcs/bw_fixed.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/calcs/bw_fixed.c b/drivers/gpu/drm/amd/display/dc/calcs/bw_fixed.c
index 6ca288fb5fb9..2d46bc527b21 100644
--- a/drivers/gpu/drm/amd/display/dc/calcs/bw_fixed.c
+++ b/drivers/gpu/drm/amd/display/dc/calcs/bw_fixed.c
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

