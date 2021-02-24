Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21C1F323D7B
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236089AbhBXNMs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:12:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:58442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235714AbhBXNFD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:05:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E5F664F80;
        Wed, 24 Feb 2021 12:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171246;
        bh=EomfylCSApmaTvl+siIcJT0taEri7bkI5Dnz8wQmmE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mABoQ9uNJ4N1RkJUm7MSqbpT1ohqu+G7EokN9qpijd+lIwK2rLisUIPHV4cx5wuHR
         zTHOfX/MQ8YeLGlvwBjqk2nG2gwUsMwRUFvPUiFyvaWFIdMZny/vZHUtxESmXhv+uS
         7ELQlrwLMLxaiwT4Flo0iGZYjDyHg0Lnl+sqE+clpDygF00BYUB2gCmUJFQX4TWDcB
         rYwQ6nPVdwgnmW/PeQ+QPIAsBW+IGLYyxLvU0zZMBZGf0XGeo3leTyWhOHgkgG0fNQ
         CieAK8TAo+fE/SCEPkxXq14jfpVPpfRgH9Azh3gL9W9NNl4dQpo/vW6nb/EjaG+fkC
         bVLNqDKFyNe4Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Eric Yang <eric.yang2@amd.com>,
        Anson Jacob <anson.jacob@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 19/40] drm/amd/display: Guard against NULL pointer deref when get_i2c_info fails
Date:   Wed, 24 Feb 2021 07:53:19 -0500
Message-Id: <20210224125340.483162-19-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125340.483162-1-sashal@kernel.org>
References: <20210224125340.483162-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index fa92b88bc5a13..40041c61a100e 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -1303,6 +1303,11 @@ static bool construct(
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
2.27.0

