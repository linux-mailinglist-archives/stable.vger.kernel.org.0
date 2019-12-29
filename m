Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9E612C66C
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730841AbfL2Rqq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:46:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:56790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731124AbfL2Rqp (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:46:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A01820718;
        Sun, 29 Dec 2019 17:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641605;
        bh=n66rELhtRP7TuDCSuJ2fjZ2102XfdZBQlIS6TWQiDGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h+0gUGqdwfcb1pHzQHzIRqeWHS9GiBIPY72YdVNGM8bl3e5/MPKzD6PkDpcQEWvJo
         0ALBAr6SoGrxkimHHUw7xJG4V3OXB9+Vyrg11Q/wzXW7JGo5R0/Qh+/MEV3iXpNaO6
         duVs5WpUjd9kWlfE545ZyXSeCBk4Ilog669EBcrQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josip Pavic <Josip.Pavic@amd.com>,
        Anthony Koo <Anthony.Koo@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 134/434] drm/amd/display: wait for set pipe mcp command completion
Date:   Sun, 29 Dec 2019 18:23:07 +0100
Message-Id: <20191229172710.609979700@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josip Pavic <Josip.Pavic@amd.com>

[ Upstream commit 15caeabc5787c15babad7ee444afe9c26df1c8b3 ]

[Why]
When the driver sends a pipe set command to the DMCU FW, it does not wait
for the command to complete. This can lead to unpredictable behavior if,
for example, the driver were to request a pipe disable to the FW via MCP,
then power down some hardware before the firmware has completed processing
the command.

[How]
Wait for the DMCU FW to finish processing set pipe commands

Signed-off-by: Josip Pavic <Josip.Pavic@amd.com>
Reviewed-by: Anthony Koo <Anthony.Koo@amd.com>
Acked-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dce_abm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_abm.c b/drivers/gpu/drm/amd/display/dc/dce/dce_abm.c
index 58bd131d5b48..7700a855d77c 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_abm.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_abm.c
@@ -77,6 +77,9 @@ static bool dce_abm_set_pipe(struct abm *abm, uint32_t controller_id)
 	/* notifyDMCUMsg */
 	REG_UPDATE(MASTER_COMM_CNTL_REG, MASTER_COMM_INTERRUPT, 1);
 
+	REG_WAIT(MASTER_COMM_CNTL_REG, MASTER_COMM_INTERRUPT, 0,
+			1, 80000);
+
 	return true;
 }
 
-- 
2.20.1



