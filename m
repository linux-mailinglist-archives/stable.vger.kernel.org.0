Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07F59CA7EE
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405762AbfJCQsx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:48:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:34994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405098AbfJCQsv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:48:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD4262070B;
        Thu,  3 Oct 2019 16:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121331;
        bh=s1xHu8LphYSTJupvhJsAxrab1Glumm0UXtfw4+RHFfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BPWbKwTLSRFjobgyL75jmbJnXwLBuHTNq+RerqTxT/+MNvD2LbBCcc2e35ampw6Bz
         XPmPAQfhoRtGTGCxU13Qgysv4V221c7snl4S+OAISjfTNFAtcy7XQ2zwRciTnEH+bU
         N5zFlGJWOSe6dfjt+CqIgetOOZ/KEDKyMIABfth0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Ahzo <Ahzo@tutanota.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 222/344] drm/amd/powerplay/smu7: enforce minimal VBITimeout (v2)
Date:   Thu,  3 Oct 2019 17:53:07 +0200
Message-Id: <20191003154602.270747929@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ahzo <Ahzo@tutanota.com>

[ Upstream commit f659bb6dae58c113805f92822e4c16ddd3156b79 ]

This fixes screen corruption/flickering on 75 Hz displays.

v2: make print statement debug only (Alex)

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=102646
Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Ahzo <Ahzo@tutanota.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c b/drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c
index 487aeee1cf8a5..3c1084de5d59f 100644
--- a/drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c
+++ b/drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c
@@ -4068,6 +4068,11 @@ static int smu7_program_display_gap(struct pp_hwmgr *hwmgr)
 
 	data->frame_time_x2 = frame_time_in_us * 2 / 100;
 
+	if (data->frame_time_x2 < 280) {
+		pr_debug("%s: enforce minimal VBITimeout: %d -> 280\n", __func__, data->frame_time_x2);
+		data->frame_time_x2 = 280;
+	}
+
 	display_gap2 = pre_vbi_time_in_us * (ref_clock / 100);
 
 	cgs_write_ind_register(hwmgr->device, CGS_IND_REG__SMC, ixCG_DISPLAY_GAP_CNTL2, display_gap2);
-- 
2.20.1



