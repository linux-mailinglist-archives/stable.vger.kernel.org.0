Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E080D590040
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 17:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234970AbiHKPjq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:39:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236245AbiHKPjP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:39:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B442956AB;
        Thu, 11 Aug 2022 08:34:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2FD6EB82144;
        Thu, 11 Aug 2022 15:34:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13DA5C43470;
        Thu, 11 Aug 2022 15:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232084;
        bh=Znb4vMMUW0CvqnK5eP1hSzIzgUAQiLBAoxM54auJynM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RiCExWtXsLFysZq2w9NZpU85iiLhgxaewWZ5xcwpIOubmxXsDk9KCpX448uMd2OjW
         K3TqSsS/Cpod2tr9DshDRUcxQioCuUjAxJudG6P9dZUiUCwliZaBVA+hg5vgyoO84U
         ysAJkypKedcHH7HoXLuBpeBf6dnGReM5nGmhhC9Sx9gWo6+2PsoaZBppBsDATX4pKI
         y0q8574cdMABdZ6ZWK+X01RzpCDHeZzOazV01LO2gamJMVyKndhWJEmvGv7Nh2kSG6
         /JlA0N5ysIkG5nx8Fm4mTiAEp7qc0v2ncUSeufulv116x1glvve3hgkNz0W2GYNGQU
         8OVnJtsd8uJBQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Michael Strauss <Michael.Strauss@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, christian.koenig@amd.com, Xinhui.Pan@amd.com,
        airlied@linux.ie, daniel@ffwll.ch, wyatt.wood@amd.com,
        aric.cyr@amd.com, arnd@arndb.de,
        meenakshikumar.somasundaram@amd.com, Jing.Zhou@amd.com,
        baihaowen@meizu.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.19 058/105] drm/amd/display: Guard against ddc_pin being NULL for AUX
Date:   Thu, 11 Aug 2022 11:27:42 -0400
Message-Id: <20220811152851.1520029-58-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811152851.1520029-1-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit bc19909f19fdc8253d720d11c948935786fbfa08 ]

[Why]
In the case where we don't support DMUB aux but we have DPIA links
in the configuration we might try to message AUX using the legacy
path - where DDC pin is NULL. This causes a NULL pointer dereference.

[How]
Guard against NULL DDC pin, return a failure for aux engine acquire.

Reviewed-by: Michael Strauss <Michael.Strauss@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dce_aux.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_aux.c b/drivers/gpu/drm/amd/display/dc/dce/dce_aux.c
index 9e39cd7b203e..49d3145ae8fb 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_aux.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_aux.c
@@ -572,6 +572,11 @@ int dce_aux_transfer_raw(struct ddc_service *ddc,
 
 	memset(&aux_req, 0, sizeof(aux_req));
 
+	if (ddc_pin == NULL) {
+		*operation_result = AUX_RET_ERROR_ENGINE_ACQUIRE;
+		return -1;
+	}
+
 	aux_engine = ddc->ctx->dc->res_pool->engines[ddc_pin->pin_data->en];
 	if (!acquire(aux_engine, ddc_pin)) {
 		*operation_result = AUX_RET_ERROR_ENGINE_ACQUIRE;
-- 
2.35.1

