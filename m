Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09CC23742CE
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 18:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235355AbhEEQs2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:48:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:49994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236026AbhEEQp0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:45:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5929E61424;
        Wed,  5 May 2021 16:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232579;
        bh=cuJraNm/ySXusB0u5w9lhScTSuhxVXyuD3eYZplHLlQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S8w248PEnXNwjONsGd6NJM2wIVd4LGOswzZhrjzTbhNRxSX5CVTdRHznOpJ7B82MM
         24s6V59dtxcYRIvoRmJilp/05A9TK0tVppaXOsZPVdq4XrOu6IJ8zo4TtetmIl6SaH
         3NDdFlbrxRiD7kJ8WhDU79DJ0snGXebpCcsRIV4tNZT5J3mcrIew4tAwuVax1GyQh1
         +qQfDas9T7ngF8MzJLjtFp2Tuao8N4NZVWxc0FITD4uOOFHPHcMC4svbotT9CCINba
         f5cWt1c/Djeo7aZ62qJ2Plol+780G8u/D76+gZI1kt5l37+W9ohp0eFi4lhcu69bps
         to6Yvagu7jxjg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Dingchen (David) Zhang" <dingchen.zhang@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.11 086/104] drm/amd/display: add handling for hdcp2 rx id list validation
Date:   Wed,  5 May 2021 12:33:55 -0400
Message-Id: <20210505163413.3461611-86-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163413.3461611-1-sashal@kernel.org>
References: <20210505163413.3461611-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Dingchen (David) Zhang" <dingchen.zhang@amd.com>

[ Upstream commit 4ccf9446b2a3615615045346c97f8a1e2a16568a ]

[why]
the current implementation of hdcp2 rx id list validation does not
have handler/checker for invalid message status, e.g. HMAC, the V
parameter calculated from PSP not matching the V prime from Rx.

[how]
return a generic FAILURE for any message status not SUCCESS or
REVOKED.

Signed-off-by: Dingchen (David) Zhang <dingchen.zhang@amd.com>
Reviewed-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/modules/hdcp/hdcp_psp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_psp.c b/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_psp.c
index 3a367a5968ae..972f2600f967 100644
--- a/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_psp.c
+++ b/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_psp.c
@@ -789,6 +789,8 @@ enum mod_hdcp_status mod_hdcp_hdcp2_validate_rx_id_list(struct mod_hdcp *hdcp)
 			   TA_HDCP2_MSG_AUTHENTICATION_STATUS__RECEIVERID_REVOKED) {
 			hdcp->connection.is_hdcp2_revoked = 1;
 			status = MOD_HDCP_STATUS_HDCP2_RX_ID_LIST_REVOKED;
+		} else {
+			status = MOD_HDCP_STATUS_HDCP2_VALIDATE_RX_ID_LIST_FAILURE;
 		}
 	}
 	mutex_unlock(&psp->hdcp_context.mutex);
-- 
2.30.2

