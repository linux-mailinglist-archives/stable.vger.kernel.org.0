Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8BA60B2C1
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbiJXQvB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235406AbiJXQtb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:49:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E39C717FD4A;
        Mon, 24 Oct 2022 08:32:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E537AB811EC;
        Mon, 24 Oct 2022 12:03:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 469E9C433C1;
        Mon, 24 Oct 2022 12:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612985;
        bh=IqXIc2zb1gPqjZAiZAuDXqBufstMjobSxTTlD79UXjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cGWUC15kFAwA7wcupt1PX4XhVR2VVQha1VQlYrYg0JhO7ZrDTCXM/iyRiRXbfjfqv
         WFJ4x/F1Tqd70b5DtS3ajEZJCvUDSpB8xazf/O8K3USWg/CYKGcm0KapzLiR6rRFpD
         JrZrGll04YsThrRoC48hCvh/EmaCxzkG0hhkItY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Gow <davidgow@google.com>,
        Tales Aparecida <tales.aparecida@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 195/229] drm/amd/display: fix overflow on MIN_I64 definition
Date:   Mon, 24 Oct 2022 13:31:54 +0200
Message-Id: <20221024113005.440623785@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112959.085534368@linuxfoundation.org>
References: <20221024112959.085534368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



