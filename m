Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A899C2F465
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729290AbfE3EiE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:38:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:56188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729219AbfE3DMq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:12:46 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7675A23E29;
        Thu, 30 May 2019 03:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185966;
        bh=ZeohyddH6FkTCMAWCFJ5ZMUegBhCJh5LZK63ycK1bl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t64I0aytXrtW+6o10G7iKf12VY/ftyaJvGsieZYFyE27WYe6JlYPMd3r7Ff4kF8hV
         M4Tb57pHXsHDfN6Fh+zF21n4UMrz45ubB8U27DDsQkWIPpZRywmKwAAALgirP4poVm
         RYKFGlpEn6HQy2mDg4Qg6Y3urIjvmyiWrRJzwUJE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anthony Koo <Anthony.Koo@amd.com>,
        Aric Cyr <Aric.Cyr@amd.com>, Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 395/405] drm/amd/display: Fix exception from AUX acquire failure
Date:   Wed, 29 May 2019 20:06:33 -0700
Message-Id: <20190530030600.578945165@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit dcf1a988678e2e39ce2b4115b8ce14d208c8c481 ]

[Why]
AUX arbitration occurs between SW and FW components.
When AUX acquire fails, it causes engine->ddc to be NULL,
which leads to an exception when we try to release the AUX
engine.

[How]
When AUX engine acquire fails, it should return from the
function without trying to continue the operation.
The upper level will determine if it wants to retry.
i.e. dce_aux_transfer_with_retries will be used and retry.

Signed-off-by: Anthony Koo <Anthony.Koo@amd.com>
Reviewed-by: Aric Cyr <Aric.Cyr@amd.com>
Acked-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dce_aux.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_aux.c b/drivers/gpu/drm/amd/display/dc/dce/dce_aux.c
index 4fe3664fb4950..5ecfcb9ee8a0c 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_aux.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_aux.c
@@ -377,7 +377,6 @@ static bool acquire(
 	struct dce_aux *engine,
 	struct ddc *ddc)
 {
-
 	enum gpio_result result;
 
 	if (!is_engine_available(engine))
@@ -458,7 +457,8 @@ int dce_aux_transfer(struct ddc_service *ddc,
 	memset(&aux_rep, 0, sizeof(aux_rep));
 
 	aux_engine = ddc->ctx->dc->res_pool->engines[ddc_pin->pin_data->en];
-	acquire(aux_engine, ddc_pin);
+	if (!acquire(aux_engine, ddc_pin))
+		return -1;
 
 	if (payload->i2c_over_aux)
 		aux_req.type = AUX_TRANSACTION_TYPE_I2C;
-- 
2.20.1



