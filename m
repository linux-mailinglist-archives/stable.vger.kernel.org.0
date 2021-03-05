Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9D332EA7C
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:39:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233065AbhCEMit (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:38:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:52118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230462AbhCEMie (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:38:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B70A165012;
        Fri,  5 Mar 2021 12:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947913;
        bh=1JkpQNtZ3SdC0LsOZyLxa+V3Yxg6V5nE2CLt/WhrWlU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NlffRs5WanOdsHrYi5UPlekxdNNwvcG16iJzEenrF1hBoovU07nqW49N/XsPfhCBb
         MNEICVB4xS19WS8NjNNVLKD743TEeAtMzksWIRF++RPwlaad0k8hzfT+yGad5gXZ+d
         kkPz3oHyKogHZgunW9qRP4WJmGMq8f6rbWYs83Eg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Wheeler <daniel.wheeler@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Eric Yang <eric.yang2@amd.com>,
        Anson Jacob <anson.jacob@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 33/52] drm/amd/display: Guard against NULL pointer deref when get_i2c_info fails
Date:   Fri,  5 Mar 2021 13:22:04 +0100
Message-Id: <20210305120855.298573239@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120853.659441428@linuxfoundation.org>
References: <20210305120853.659441428@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit 44a09e3d95bd2b7b0c224100f78f335859c4e193 ]

[Why]
If the BIOS table is invalid or corrupt then get_i2c_info can fail
and we dereference a NULL pointer.

[How]
Check that ddc_pin is not NULL before using it and log an error if it
is because this is unexpected.

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Reviewed-by: Eric Yang <eric.yang2@amd.com>
Acked-by: Anson Jacob <anson.jacob@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link.c b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
index fa0e6c8e2447..e3bedf4cc9c0 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -1124,6 +1124,11 @@ static bool construct(
 		goto ddc_create_fail;
 	}
 
+	if (!link->ddc->ddc_pin) {
+		DC_ERROR("Failed to get I2C info for connector!\n");
+		goto ddc_create_fail;
+	}
+
 	link->ddc_hw_inst =
 		dal_ddc_get_line(
 			dal_ddc_service_get_ddc_pin(link->ddc));
-- 
2.30.1



