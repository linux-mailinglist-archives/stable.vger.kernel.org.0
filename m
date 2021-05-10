Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6891937861A
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232486AbhEJLDx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:03:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:52212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234921AbhEJK5P (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:57:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6881B619C3;
        Mon, 10 May 2021 10:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643822;
        bh=VUsUoSoPL5v+qZayowjA+mySGwhYA3TEbe5Rg7Vt3YI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J8kWYPN/dIvPZG0KMu9fZP2pnG8Vk+1xSUkPrq8gTDCLRfoUTUgWdMagLMjO77XJ8
         +Tj2oTYDr+Xz8Kl6wNGF+2Fjc2Jn9OGaOccYLRsG+Z2jy79TxsUx+g6h2DTYsvOC3s
         kSPWHIa6cAFhvvXIFcrk6W886ynDInqrSMvgJbik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Wheeler <daniel.wheeler@amd.com>,
        Wyatt Wood <wyatt.wood@amd.com>,
        Anthony Koo <Anthony.Koo@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 138/342] drm/amd/display: Return invalid state if GPINT times out
Date:   Mon, 10 May 2021 12:18:48 +0200
Message-Id: <20210510102014.636230245@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wyatt Wood <wyatt.wood@amd.com>

[ Upstream commit 8039bc7130ef4206a58e4dc288621bc97eba08eb ]

[Why]
GPINT timeout is causing PSR_STATE_0 to be returned when it shouldn't.
We must guarantee that PSR is fully disabled before doing hw programming
on driver-side.

[How]
Return invalid state if GPINT command times out. Let existing retry
logic send the GPINT until successful.

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Wyatt Wood <wyatt.wood@amd.com>
Reviewed-by: Anthony Koo <Anthony.Koo@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dmub_psr.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce/dmub_psr.c b/drivers/gpu/drm/amd/display/dc/dce/dmub_psr.c
index 17e84f34ceba..e0b195cad9ce 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dmub_psr.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dmub_psr.c
@@ -81,13 +81,18 @@ static void dmub_psr_get_state(struct dmub_psr *dmub, enum dc_psr_state *state)
 {
 	struct dmub_srv *srv = dmub->ctx->dmub_srv->dmub;
 	uint32_t raw_state;
+	enum dmub_status status = DMUB_STATUS_INVALID;
 
 	// Send gpint command and wait for ack
-	dmub_srv_send_gpint_command(srv, DMUB_GPINT__GET_PSR_STATE, 0, 30);
-
-	dmub_srv_get_gpint_response(srv, &raw_state);
-
-	*state = convert_psr_state(raw_state);
+	status = dmub_srv_send_gpint_command(srv, DMUB_GPINT__GET_PSR_STATE, 0, 30);
+
+	if (status == DMUB_STATUS_OK) {
+		// GPINT was executed, get response
+		dmub_srv_get_gpint_response(srv, &raw_state);
+		*state = convert_psr_state(raw_state);
+	} else
+		// Return invalid state when GPINT times out
+		*state = 0xFF;
 }
 
 /**
-- 
2.30.2



