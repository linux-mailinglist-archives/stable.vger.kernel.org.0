Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F99227CBD2
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732823AbgI2Mav (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:30:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:43228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729344AbgI2L3g (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:29:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 902B723AAA;
        Tue, 29 Sep 2020 11:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378653;
        bh=//ADPIBJVW5dyfiG5iHFZA/xCA2SvA5QdiLIX7CKf+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uh+WSJNkgRJjzXs9k9z/HbEJaePdgRZ1bMXPmrYZRMvm4ElHDIA8Mjy5ZEsVbCbdu
         XdfeT1vBpSvNYYpteX0hFdvEPRkymY5smyjHhrcA37kNO6kudUuMIzm8GSzkV2Geij
         7zXNeXLkAgWClYzYuwPVTtYY8GB0YNT95xvedDgE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aric Cyr <aric.cyr@amd.com>,
        Joshua Aberback <Joshua.Aberback@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 091/245] drm/amd/display: dal_ddc_i2c_payloads_create can fail causing panic
Date:   Tue, 29 Sep 2020 12:59:02 +0200
Message-Id: <20200929105951.417760720@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aric Cyr <aric.cyr@amd.com>

[ Upstream commit 6a6c4a4d459ecacc9013c45dcbf2bc9747fdbdbd ]

[Why]
Since the i2c payload allocation can fail need to check return codes

[How]
Clean up i2c payload allocations and check for errors

Signed-off-by: Aric Cyr <aric.cyr@amd.com>
Reviewed-by: Joshua Aberback <Joshua.Aberback@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Acked-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/core/dc_link_ddc.c | 52 +++++++++----------
 1 file changed, 25 insertions(+), 27 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_ddc.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_ddc.c
index 46c9cb47a96e5..145af3bb2dfcb 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_ddc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_ddc.c
@@ -127,22 +127,16 @@ struct aux_payloads {
 	struct vector payloads;
 };
 
-static struct i2c_payloads *dal_ddc_i2c_payloads_create(struct dc_context *ctx, uint32_t count)
+static bool dal_ddc_i2c_payloads_create(
+		struct dc_context *ctx,
+		struct i2c_payloads *payloads,
+		uint32_t count)
 {
-	struct i2c_payloads *payloads;
-
-	payloads = kzalloc(sizeof(struct i2c_payloads), GFP_KERNEL);
-
-	if (!payloads)
-		return NULL;
-
 	if (dal_vector_construct(
 		&payloads->payloads, ctx, count, sizeof(struct i2c_payload)))
-		return payloads;
-
-	kfree(payloads);
-	return NULL;
+		return true;
 
+	return false;
 }
 
 static struct i2c_payload *dal_ddc_i2c_payloads_get(struct i2c_payloads *p)
@@ -155,14 +149,12 @@ static uint32_t dal_ddc_i2c_payloads_get_count(struct i2c_payloads *p)
 	return p->payloads.count;
 }
 
-static void dal_ddc_i2c_payloads_destroy(struct i2c_payloads **p)
+static void dal_ddc_i2c_payloads_destroy(struct i2c_payloads *p)
 {
-	if (!p || !*p)
+	if (!p)
 		return;
-	dal_vector_destruct(&(*p)->payloads);
-	kfree(*p);
-	*p = NULL;
 
+	dal_vector_destruct(&p->payloads);
 }
 
 static struct aux_payloads *dal_ddc_aux_payloads_create(struct dc_context *ctx, uint32_t count)
@@ -580,9 +572,13 @@ bool dal_ddc_service_query_ddc_data(
 
 	uint32_t payloads_num = write_payloads + read_payloads;
 
+
 	if (write_size > EDID_SEGMENT_SIZE || read_size > EDID_SEGMENT_SIZE)
 		return false;
 
+	if (!payloads_num)
+		return false;
+
 	/*TODO: len of payload data for i2c and aux is uint8!!!!,
 	 *  but we want to read 256 over i2c!!!!*/
 	if (dal_ddc_service_is_in_aux_transaction_mode(ddc)) {
@@ -613,23 +609,25 @@ bool dal_ddc_service_query_ddc_data(
 		dal_ddc_aux_payloads_destroy(&payloads);
 
 	} else {
-		struct i2c_payloads *payloads =
-			dal_ddc_i2c_payloads_create(ddc->ctx, payloads_num);
+		struct i2c_command command = {0};
+		struct i2c_payloads payloads;
 
-		struct i2c_command command = {
-			.payloads = dal_ddc_i2c_payloads_get(payloads),
-			.number_of_payloads = 0,
-			.engine = DDC_I2C_COMMAND_ENGINE,
-			.speed = ddc->ctx->dc->caps.i2c_speed_in_khz };
+		if (!dal_ddc_i2c_payloads_create(ddc->ctx, &payloads, payloads_num))
+			return false;
+
+		command.payloads = dal_ddc_i2c_payloads_get(&payloads);
+		command.number_of_payloads = 0;
+		command.engine = DDC_I2C_COMMAND_ENGINE;
+		command.speed = ddc->ctx->dc->caps.i2c_speed_in_khz;
 
 		dal_ddc_i2c_payloads_add(
-			payloads, address, write_size, write_buf, true);
+			&payloads, address, write_size, write_buf, true);
 
 		dal_ddc_i2c_payloads_add(
-			payloads, address, read_size, read_buf, false);
+			&payloads, address, read_size, read_buf, false);
 
 		command.number_of_payloads =
-			dal_ddc_i2c_payloads_get_count(payloads);
+			dal_ddc_i2c_payloads_get_count(&payloads);
 
 		ret = dm_helpers_submit_i2c(
 				ddc->ctx,
-- 
2.25.1



