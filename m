Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B90A37864C
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234754AbhEJLFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:05:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:52158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232700AbhEJK5n (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:57:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFDBE61C51;
        Mon, 10 May 2021 10:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643923;
        bh=DFaUFvaFSzNv+2K395Ty4lHD4aIvOZei9Y2R13qGQcc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ynRUYMd9tfVKGaXBWmclDiDiobPotpvJoILwoCq78Tu85ga5VAdPJABPbO90vNwnV
         V603aZjBP1wmmZuIcyVDS9k3WJRR+EpUqBQia92tfQa4E7N+G4wpOCG4JByrFMbd/O
         QUbzLLvtC6ZuJ+kdzbJfraXpdz8DlDnb4chJ78eM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kenneth Feng <kenneth.feng@amd.com>,
        Kevin Wang <kevin1.wang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 170/342] drm/amd/pm: fix workload mismatch on vega10
Date:   Mon, 10 May 2021 12:19:20 +0200
Message-Id: <20210510102015.724399482@linuxfoundation.org>
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

From: Kenneth Feng <kenneth.feng@amd.com>

[ Upstream commit 0979d43259e13846d86ba17e451e17fec185d240 ]

Workload number mapped to the correct one.
This issue is only on vega10.

Signed-off-by: Kenneth Feng <kenneth.feng@amd.com>
Reviewed-by: Kevin Wang <kevin1.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
index 892f08f2ba42..13b5ae1c106f 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
@@ -5161,7 +5161,7 @@ static int vega10_set_power_profile_mode(struct pp_hwmgr *hwmgr, long *input, ui
 
 out:
 	smum_send_msg_to_smc_with_parameter(hwmgr, PPSMC_MSG_SetWorkloadMask,
-						1 << power_profile_mode,
+						(!power_profile_mode) ? 0 : 1 << (power_profile_mode - 1),
 						NULL);
 	hwmgr->power_profile_mode = power_profile_mode;
 
-- 
2.30.2



