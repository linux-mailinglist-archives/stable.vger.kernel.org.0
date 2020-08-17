Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92B542476F8
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732603AbgHQTnl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:43:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:50770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729540AbgHQPX0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:23:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 764AE2339E;
        Mon, 17 Aug 2020 15:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597677805;
        bh=4Abc2RcV96zkWCXOb26k7nxJQ2yw3b6kMzMkLIEkKJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xTrvTOoHxh35uO++C80GrPbYIkGZc8I8bqblo6MwpXmM1b1H7bdgvA6rj7VWYf8K3
         VaFx7aVR+QWEBKB/0WBApd2WXY9rTwJAJadi6mFNtRSDEt2oC+u9+ioxhwzmeRGFSC
         frGnq+P/7p6FfKRoTJffQfd5yTnoSo/Mj4gi0Yh8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenjing Liu <wenjing.liu@amd.com>,
        Jun Lei <Jun.Lei@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 114/464] drm/amd/display: allow query ddc data over aux to be read only operation
Date:   Mon, 17 Aug 2020 17:11:07 +0200
Message-Id: <20200817143839.270709622@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenjing Liu <wenjing.liu@amd.com>

[ Upstream commit 26b4750d6cf84cb2b3f0a84c9b345e7b71886410 ]

[why]
Two issues:
1. Add read only operation support for query ddc data over aux.
2. Fix a bug where if read size is multiple of 16,
mot of the last read transaction will not be set to 0.

Signed-off-by: Wenjing Liu <wenjing.liu@amd.com>
Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/core/dc_link_ddc.c | 29 ++++++++++++-------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_ddc.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_ddc.c
index aefd29a440b52..be8f265976b09 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_ddc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_ddc.c
@@ -503,7 +503,7 @@ bool dal_ddc_service_query_ddc_data(
 	uint8_t *read_buf,
 	uint32_t read_size)
 {
-	bool ret = false;
+	bool success = true;
 	uint32_t payload_size =
 		dal_ddc_service_is_in_aux_transaction_mode(ddc) ?
 			DEFAULT_AUX_MAX_DATA_SIZE : EDID_SEGMENT_SIZE;
@@ -527,7 +527,6 @@ bool dal_ddc_service_query_ddc_data(
 	 *  but we want to read 256 over i2c!!!!*/
 	if (dal_ddc_service_is_in_aux_transaction_mode(ddc)) {
 		struct aux_payload payload;
-		bool read_available = true;
 
 		payload.i2c_over_aux = true;
 		payload.address = address;
@@ -536,21 +535,26 @@ bool dal_ddc_service_query_ddc_data(
 
 		if (write_size != 0) {
 			payload.write = true;
-			payload.mot = false;
+			/* should not set mot (middle of transaction) to 0
+			 * if there are pending read payloads
+			 */
+			payload.mot = read_size == 0 ? false : true;
 			payload.length = write_size;
 			payload.data = write_buf;
 
-			ret = dal_ddc_submit_aux_command(ddc, &payload);
-			read_available = ret;
+			success = dal_ddc_submit_aux_command(ddc, &payload);
 		}
 
-		if (read_size != 0 && read_available) {
+		if (read_size != 0 && success) {
 			payload.write = false;
+			/* should set mot (middle of transaction) to 0
+			 * since it is the last payload to send
+			 */
 			payload.mot = false;
 			payload.length = read_size;
 			payload.data = read_buf;
 
-			ret = dal_ddc_submit_aux_command(ddc, &payload);
+			success = dal_ddc_submit_aux_command(ddc, &payload);
 		}
 	} else {
 		struct i2c_command command = {0};
@@ -573,7 +577,7 @@ bool dal_ddc_service_query_ddc_data(
 		command.number_of_payloads =
 			dal_ddc_i2c_payloads_get_count(&payloads);
 
-		ret = dm_helpers_submit_i2c(
+		success = dm_helpers_submit_i2c(
 				ddc->ctx,
 				ddc->link,
 				&command);
@@ -581,7 +585,7 @@ bool dal_ddc_service_query_ddc_data(
 		dal_ddc_i2c_payloads_destroy(&payloads);
 	}
 
-	return ret;
+	return success;
 }
 
 bool dal_ddc_submit_aux_command(struct ddc_service *ddc,
@@ -598,7 +602,7 @@ bool dal_ddc_submit_aux_command(struct ddc_service *ddc,
 
 	do {
 		struct aux_payload current_payload;
-		bool is_end_of_payload = (retrieved + DEFAULT_AUX_MAX_DATA_SIZE) >
+		bool is_end_of_payload = (retrieved + DEFAULT_AUX_MAX_DATA_SIZE) >=
 			payload->length;
 
 		current_payload.address = payload->address;
@@ -607,7 +611,10 @@ bool dal_ddc_submit_aux_command(struct ddc_service *ddc,
 		current_payload.i2c_over_aux = payload->i2c_over_aux;
 		current_payload.length = is_end_of_payload ?
 			payload->length - retrieved : DEFAULT_AUX_MAX_DATA_SIZE;
-		current_payload.mot = !is_end_of_payload;
+		/* set mot (middle of transaction) to false
+		 * if it is the last payload
+		 */
+		current_payload.mot = is_end_of_payload ? payload->mot:true;
 		current_payload.reply = payload->reply;
 		current_payload.write = payload->write;
 
-- 
2.25.1



