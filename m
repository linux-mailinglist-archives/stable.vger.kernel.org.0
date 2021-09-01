Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 231B43FDB91
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344449AbhIAMmS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:42:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:42460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344191AbhIAMkh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:40:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8BC5611C0;
        Wed,  1 Sep 2021 12:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499810;
        bh=XFi6cA/Q/hPW4JHtHpkD+8ah60OgiCKtUl0ylHe1CM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=usCn5TB8X1jDcQMe8WUalQ+Yx6XCBQwODIXip3AmalEKulg2/vMneRqDDUFztBZvw
         5a7OwGP5yV9qRIVgBbg870nGPNSpVr7y9xT6wr2VC3uByZFBdvi0ZAGak/VlA78wGe
         BLdBHo3CI+o6QIFodudqiMPn4JQ7hpfvj8K5PDXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kenneth Feng <kenneth.feng@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 064/103] Revert "drm/amd/pm: fix workload mismatch on vega10"
Date:   Wed,  1 Sep 2021 14:28:14 +0200
Message-Id: <20210901122302.726463459@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
References: <20210901122300.503008474@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kenneth Feng <kenneth.feng@amd.com>

[ Upstream commit 2fd31689f9e44af949f60ff4f8aca013e628ab81 ]

This reverts commit 0979d43259e13846d86ba17e451e17fec185d240.
Revert this because it does not apply to all the cards.

Signed-off-by: Kenneth Feng <kenneth.feng@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
index 132c269c7c89..ed4eafc744d3 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
@@ -5159,7 +5159,7 @@ static int vega10_set_power_profile_mode(struct pp_hwmgr *hwmgr, long *input, ui
 
 out:
 	smum_send_msg_to_smc_with_parameter(hwmgr, PPSMC_MSG_SetWorkloadMask,
-						(!power_profile_mode) ? 0 : 1 << (power_profile_mode - 1),
+						1 << power_profile_mode,
 						NULL);
 	hwmgr->power_profile_mode = power_profile_mode;
 
-- 
2.30.2



