Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9920D32E9DA
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbhCEMfD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:35:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:46402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231860AbhCEMen (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:34:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 510676501D;
        Fri,  5 Mar 2021 12:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947681;
        bh=/KBQUc3XBQeTdmbwSV/TnNC2PL+nXl0zvygNZc+Jvlk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bXTlT+23k2cbt5j9HHoDq0F/mXLuo5h5yZ328uMFC/dJe8c9zVqGS0JGcjOF4wA5i
         PpMpozYm7kwlguE+KhSA5nTHm9LkdQMi0LQtXU3eDCJ101NPxVpG2tr8sytYQbTlmX
         6JsCKFu71vbEbyZ5zC8aVMBTjXMB7zcpYoaCUgIU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Wheeler <daniel.wheeler@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Eric Yang <eric.yang2@amd.com>,
        Anson Jacob <anson.jacob@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 45/72] drm/amd/display: Guard against NULL pointer deref when get_i2c_info fails
Date:   Fri,  5 Mar 2021 13:21:47 +0100
Message-Id: <20210305120859.550735603@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120857.341630346@linuxfoundation.org>
References: <20210305120857.341630346@linuxfoundation.org>
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
index fa92b88bc5a1..40041c61a100 100644
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
2.30.1



