Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB0CF31BCE6
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbhBOPhM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:37:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:46648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231169AbhBOPf0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:35:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6900D64ECE;
        Mon, 15 Feb 2021 15:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403112;
        bh=K1aMfQFonvXHYyiQK0hl5trGHrfEt1bpMziYEyre7wE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=arfovcFUWr3+6NikuktjY9aV8OEPwXpYVFRw8y4ZO42+H2SYhGOD8cEHYYBHeULdS
         se4GG91jGNdy91X2CbbLwJwmpNYTlHv0a56U3J9Ws0f+u/mzaAoHroTJaihbfbjEgy
         v7W9W8VGy/YqeiYTjAJakVijDsazQMACK7YYEKcU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, George Shen <george.shen@amd.com>,
        Wenjing Liu <Wenjing.Liu@amd.com>,
        Anson Jacob <Anson.Jacob@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 031/104] drm/amd/display: Fix DPCD translation for LTTPR AUX_RD_INTERVAL
Date:   Mon, 15 Feb 2021 16:26:44 +0100
Message-Id: <20210215152720.495406792@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: George Shen <george.shen@amd.com>

[ Upstream commit 2b6b7ab4b1cabfbee1af5d818efcab5d51d62c7e ]

[Why]
The translation between the DPCD value and the specified AUX_RD_INTERVAL
in the DP spec do not match.

[How]
Update values to match the spec.

Signed-off-by: George Shen <george.shen@amd.com>
Reviewed-by: Wenjing Liu <Wenjing.Liu@amd.com>
Acked-by: Anson Jacob <Anson.Jacob@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index 17e6fd8201395..32b73ea866737 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -877,13 +877,13 @@ static uint32_t translate_training_aux_read_interval(uint32_t dpcd_aux_read_inte
 
 	switch (dpcd_aux_read_interval) {
 	case 0x01:
-		aux_rd_interval_us = 400;
+		aux_rd_interval_us = 4000;
 		break;
 	case 0x02:
-		aux_rd_interval_us = 4000;
+		aux_rd_interval_us = 8000;
 		break;
 	case 0x03:
-		aux_rd_interval_us = 8000;
+		aux_rd_interval_us = 12000;
 		break;
 	case 0x04:
 		aux_rd_interval_us = 16000;
-- 
2.27.0



